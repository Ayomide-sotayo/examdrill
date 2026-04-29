import 'dart:ui';
// dart:ui kept for BackdropFilter used in full-image overlay
import 'package:examdril/data/practice_drill_question_data.dart';
import 'package:examdril/models/practice_drill_question_model.dart';
import 'package:examdril/screens/practice_drill/practice_drill_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────
//  CONSTANTS
// ─────────────────────────────────────────────
const _kBlack = Color(0xFF0A0A0A);
const _kGreen = Color(0xFF19B875);
const _kRed = Color(0xFFFE3A3C);
const _kOptionBorder = Color(0xFF2E2E2E);
const _kOptionBg = Color.fromARGB(0, 20, 20, 20);
const _kWhiteText = Colors.white;
const _kSubText = Color(0xFF9E9E9E);

// ─────────────────────────────────────────────
//  WIDGET
// ─────────────────────────────────────────────
class PracticeDrillScreen extends StatefulWidget {
  final bool isSoundEnabled;
  const PracticeDrillScreen({super.key, this.isSoundEnabled = true});

  @override
  State<PracticeDrillScreen> createState() => _PracticeDrillScreenState();
}

class _PracticeDrillScreenState extends State<PracticeDrillScreen>
    with TickerProviderStateMixin {
  // ── state ──────────────────────────────────
  int _currentQuestion = 0;
  int? _selectedOptionIndex;
  bool _isCorrect = false;
  bool _hasAnswered = false;
  bool _showCorrection = false;
  bool _showFullImage = false;
  bool _isPaused = false;
  int _score = 0;
  int _lives = 4;
  final List<bool> _results = [];

  // ── animation controllers ──────────────────
  late AnimationController _bgFlashController;
  late Animation<double> _bgFlashAnimation;
  late AnimationController _ringFillController;
  late AnimationController _pulseController;

  /// Drives the radial-collapse circle animation (0 → 1)
  late AnimationController _radialController;

  /// Whether the radial bg animation is currently active
  bool _showRadial = false;

  /// Color to lerp toward during animation (green or red)
  Color _radialColor = _kGreen;

  /// GlobalKeys for each progress ring
  late List<GlobalKey> _ringKeys;

  // ── audio ──────────────────────────────────
  late AudioPlayer _bgPlayer;
  late AudioPlayer _correctPlayer;
  late AudioPlayer _wrongPlayer;

  // ─────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    // bg flash (green or red) fades in then out back to black
    _bgFlashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _bgFlashAnimation = CurvedAnimation(
      parent: _bgFlashController,
      curve: Curves.easeInOut,
    );

    // ring fill animates when correct
    _ringFillController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // active question pulse animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    // radial collapse animation
    _radialController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // one key per question for ring position targeting
    _ringKeys = List.generate(
      practiceDrillQuestions.length,
      (_) => GlobalKey(),
    );

    _bgPlayer = AudioPlayer();
    _correctPlayer = AudioPlayer();
    _wrongPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _bgPlayer.setAsset('assets/audio/good_background_sound.mp3');
      await _bgPlayer.setLoopMode(LoopMode.one);
      await _correctPlayer.setAsset('assets/audio/correct_sound_2.mp3');
      await _wrongPlayer.setAsset('assets/audio/wrong_sound.mp3');
      _playBg();
    } catch (e) {
      debugPrint('Audio init error: $e');
    }
  }

  Future<void> _playBg() async {
    if (!widget.isSoundEnabled) return;
    try {
      await _bgPlayer.seek(Duration.zero);
      _bgPlayer.play();
    } catch (e) {
      debugPrint('BG error: $e');
    }
  }

  Future<void> _playCorrect() async {
    if (widget.isSoundEnabled) {
      try {
        await _correctPlayer.seek(Duration.zero);
        _correctPlayer.play();
      } catch (e) {
        debugPrint('Correct SFX error: $e');
      }
    }
    HapticFeedback.lightImpact();
  }

  Future<void> _playWrong() async {
    if (widget.isSoundEnabled) {
      try {
        await _wrongPlayer.seek(Duration.zero);
        _wrongPlayer.play();
      } catch (e) {
        debugPrint('Wrong SFX error: $e');
      }
    }
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _bgFlashController.dispose();
    _ringFillController.dispose();
    _pulseController.dispose();
    _radialController.dispose();
    _bgPlayer.dispose();
    _correctPlayer.dispose();
    _wrongPlayer.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  //  ANSWER LOGIC
  // ─────────────────────────────────────────
  void _onOptionSelected(int index) async {
    if (_hasAnswered) return;

    final question = practiceDrillQuestions[_currentQuestion];
    final correct = index == question.correctIndex;

    setState(() {
      _selectedOptionIndex = index;
      _hasAnswered = true;
      _isCorrect = correct;
      _radialColor = correct ? _kGreen : _kRed;
    });

    // capture ring center NOW before we hide the rings
    final key = _ringKeys[_currentQuestion];
    key.currentContext?.findRenderObject(); // keep key active

    setState(() {
      _showRadial = true;
    });

    await _bgPlayer.stop();

    if (correct) {
      _score += 500;
      await _playCorrect();
    } else {
      setState(() {
        if (_lives > 0) _lives--;
      });
      await _playWrong();
    }

    // ── phase 1: expand full-screen circle ──
    _radialController.reset();
    // drive to 0.45 (expand phase only) then pause briefly
    await _radialController.animateTo(
      0.45,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOut,
    );

    if (!correct) {
      // show correction screen during the pause, circle stays full
      await Future.delayed(const Duration(milliseconds: 350));
    } else {
      await Future.delayed(const Duration(milliseconds: 250));
    }

    // ── phase 2: collapse circle into the ring ──
    _ringFillController.forward();
    await _radialController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInBack,
    );

    setState(() {
      _showRadial = false;
    });
    _radialController.reset();

    _results.add(correct);

    if (!correct) {
      setState(() => _showCorrection = true);
    } else {
      await Future.delayed(const Duration(milliseconds: 150));
      _nextQuestion();
    }
  }

  void _onContinueFromCorrection() {
    setState(() => _showCorrection = false);
    _nextQuestion();
  }

  void _nextQuestion() async {
    if (_currentQuestion < practiceDrillQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedOptionIndex = null;
        _hasAnswered = false;
        _isCorrect = false;
        _showFullImage = false;
        _showRadial = false;
      });
      _ringFillController.reset();
      _radialController.reset();
      await _playBg();
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                PracticeDrillResultScreen(results: _results, score: _score),
          ),
        );
      }
    }
  }

  // ─────────────────────────────────────────
  //  PAUSE & GAME FLOW
  // ─────────────────────────────────────────
  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
    if (_isPaused) {
      _bgPlayer.pause();
      if (_pulseController.isAnimating) _pulseController.stop();
    } else {
      _bgPlayer.play();
      if (!_hasAnswered && !_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    }
  }

  void _restartGame() {
    _bgPlayer.stop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PracticeDrillScreen()),
    );
  }

  void _quitGame() {
    _bgPlayer.stop();
    Navigator.pop(context);
  }

  // ─────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────
  bool _hasTopContent(PracticeDrillQuestion q) => q.type != QuestionType.text;

  // ─────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final question = practiceDrillQuestions[_currentQuestion];

    return AnimatedBuilder(
      animation: _radialController,
      builder: (context, child) {
        // Lerp bg: black → radialColor (0→0.45) then back → black (0.45→1.0)
        Color bgColor = _kBlack;
        if (_showRadial) {
          final t = _radialController.value <= 0.45
              ? Curves.easeOut.transform(_radialController.value / 0.45)
              : 1.0 -
                    Curves.easeInBack.transform(
                      (_radialController.value - 0.45) / 0.55,
                    );
          bgColor = Color.lerp(_kBlack, _radialColor, t)!;
        }

        return Scaffold(
          backgroundColor: bgColor,
          body: child,
        );
      },
      child: Stack(
        children: [
          // ── main content ───────────────────
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                _buildProgressRings(),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: question.type == QuestionType.caseStudy
                                ? 0.20.sh
                                : _hasTopContent(question)
                                ? 0.34.sh
                                : 0.16.sh,
                          ),
                          child: Center(child: _buildTopContent(question)),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: _buildOptions(question),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── full image overlay ─────────────
          if (_showFullImage && question.imagePath != null)
            _buildFullImageOverlay(question.imagePath!),

          // ── correction overlay ─────────────
          if (_showCorrection)
            _buildCorrectionScreen(practiceDrillQuestions[_currentQuestion]),

          // ── pause overlay ──────────────────
          _buildPauseOverlay(),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  TOP BAR  (score left | rabbits right)
  // ─────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // score
          Row(
            children: [
              GestureDetector(
                onTap: _togglePause,
                child: Icon(
                  Icons.pause,
                  color: _kWhiteText.withOpacity(0.7),
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '$_score',
                style: TextStyle(
                  color: _kWhiteText,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // rabbits (lives tracking)
          Row(
            children: List.generate(4, (i) {
              final isAlive = i >= (4 - _lives);
              return Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isAlive ? 1.0 : 0.25,
                  child: Image.asset(
                    'assets/images/bunny.png',
                    height: 28.h,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.cruelty_free_rounded,
                      color: _kWhiteText.withOpacity(0.5),
                      size: 24.sp,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  PROGRESS RINGS
  // ─────────────────────────────────────────
  Widget _buildProgressRings() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(practiceDrillQuestions.length, (i) {
          Color ringColor;
          bool filled = false;

          if (i < _results.length) {
            // already answered
            ringColor = _results[i] ? _kGreen : _kRed;
            filled = true;
          } else if (i == _currentQuestion && _hasAnswered && _isCorrect) {
            // current — just answered correctly, ring animating
            ringColor = _kGreen;
            filled = true;
          } else {
            ringColor = Colors.white24;
            filled = false;
          }

          return AnimatedBuilder(
            animation: Listenable.merge([_ringFillController, _pulseController]),
            builder: (_, __) {
              final isAnimatingNow =
                  i == _currentQuestion && _hasAnswered && _isCorrect;
              final size = isAnimatingNow
                  ? 14.r + (2.r * _ringFillController.value)
                  : 14.r;

              final isCurrentBlinking = i == _currentQuestion && !_hasAnswered;
              final opacity = isCurrentBlinking ? 0.3 + (0.7 * _pulseController.value) : 1.0;

              return Opacity(
                opacity: opacity,
                child: Container(
                  key: _ringKeys[i],
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? ringColor : Colors.transparent,
                    border: Border.all(
                      color: filled ? ringColor : (isCurrentBlinking ? Colors.white : Colors.white24),
                      width: 1.5.w,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  TOP CONTENT (image / table / case / question)
  // ─────────────────────────────────────────
  Widget _buildTopContent(PracticeDrillQuestion question) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Column(
        key: ValueKey<int>(_currentQuestion),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (question.type == QuestionType.imageGraph &&
              question.imagePath != null)
            _buildImageSection(question.imagePath!, 'Graph / Image Reference'),

          if (question.type == QuestionType.table) _buildTableSection(question),

          if (question.type == QuestionType.caseStudy &&
              question.caseText != null)
            _buildCaseText(question.caseText!),

          SizedBox(height: _hasTopContent(question) ? 14.h : 0),
          _buildQuestionText(question.question),
        ],
      ),
    );
  }

  Widget _buildQuestionText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _kWhiteText,
          fontSize: 21.sp,
          fontWeight: FontWeight.bold,
          height: 1.35,
        ),
      ),
    );
  }

  Widget _buildCaseText(String text) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 20.w, right: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: _kWhiteText.withOpacity(0.88),
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          height: 1.8,
        ),
      ),
    );
  }

  Widget _buildImageSection(String imagePath, String? label) {
    final bool isSvg = imagePath.toLowerCase().endsWith('.svg');
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 180.h,
              margin: EdgeInsets.only(top: 8.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: isSvg
                    ? SvgPicture.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        placeholderBuilder: (_) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white38,
                          ),
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 50,
                            color: Colors.white24,
                          ),
                        ),
                      ),
              ),
            ),
            Positioned(
              bottom: 8.h,
              right: 8.w,
              child: GestureDetector(
                onTap: () => setState(() => _showFullImage = true),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    'Full view',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (label != null)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: _kSubText),
            ),
          ),
      ],
    );
  }

  Widget _buildTableSection(PracticeDrillQuestion question) {
    if (question.tableData == null || question.tableData!.isEmpty) {
      return const SizedBox();
    }
    final headers = question.tableData!.first;
    final rows = question.tableData!.skip(1).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: DataTable(
        headingRowHeight: 46.h,
        dataRowMinHeight: 42.h,
        dataRowMaxHeight: 42.h,
        columnSpacing: 0,
        border: TableBorder.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.w,
        ),
        headingRowColor: WidgetStateProperty.all(
          Colors.white.withOpacity(0.07),
        ),
        dataRowColor: WidgetStateProperty.all(Colors.white.withOpacity(0.03)),
        columns: headers
            .map(
              (h) => DataColumn(
                label: Expanded(
                  child: Center(
                    child: Text(
                      h,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: _kWhiteText,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        rows: rows
            .map(
              (r) => DataRow(
                cells: r
                    .map(
                      (cell) => DataCell(
                        Center(
                          child: Text(
                            cell,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: _kWhiteText.withOpacity(0.85),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  OPTIONS
  // ─────────────────────────────────────────
  Widget _buildOptions(PracticeDrillQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(question.options.length, (i) {
        final isSelected = _selectedOptionIndex == i;
        final isCorrectOption = i == question.correctIndex;
        final falling = _hasAnswered && !isSelected;

        // after answer: correct option stays green, selected-wrong is red, rest fall
        Color optionBg = _kOptionBg;
        Color optionBorder = _kOptionBorder;
        Color optionText = _kWhiteText;

        if (_hasAnswered) {
          if (isSelected && _isCorrect) {
            optionBg = Color(0xFF58FEB2);
            optionBorder = _kGreen;
            optionText = const Color.fromARGB(255, 2, 2, 2);
          } else if (isSelected && !_isCorrect) {
            optionBg = _kRed;
            optionBorder = _kWhiteText;
            optionText = Colors.white;
          }
        }

        return Expanded(
          child: AnimatedSlide(
            offset: falling ? const Offset(0, 3.0) : Offset.zero,
            duration: const Duration(milliseconds: 900),
            curve: falling ? Curves.easeInBack : Curves.easeOutBack,
            child: AnimatedOpacity(
              opacity: falling ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 900),
              child: GestureDetector(
                onTap: () => _onOptionSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: optionBg,
                    border: Border.all(color: optionBorder, width: 1.5.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      question.options[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: optionText,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ─────────────────────────────────────────
  //  PAUSE OVERLAY
  // ─────────────────────────────────────────
  Widget _buildPauseOverlay() {
    if (!_isPaused) return const SizedBox.shrink();

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 47.8, sigmaY: 47.8),
            child: Container(
              color: const Color(0x33000000),
            ),
          ),
        ),
        SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Paused',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  _buildPauseButton('Resume', _togglePause),
                  SizedBox(height: 16.h),
                  _buildPauseButton('Restart', _restartGame),
                  SizedBox(height: 16.h),
                  _buildPauseButton('Quit', _quitGame),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPauseButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  CORRECTION SCREEN OVERLAY
  // ─────────────────────────────────────────
  Widget _buildCorrectionScreen(PracticeDrillQuestion question) {
    return GestureDetector(
      onTap: _onContinueFromCorrection,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // image / graph shown on correction screen too
                      if (question.type == QuestionType.imageGraph &&
                          question.imagePath != null)
                        _buildCorrectionImage(question.imagePath!),

                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 22.sp,
                            height: 1.55,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          children: question.explanation.map((span) {
                            Color color;
                            FontWeight weight;
                            String text = span.text;
                            switch (span.type) {
                              case SpanType.correct:
                                color = _kGreen;
                                weight = FontWeight.w700;
                                break;
                              case SpanType.wrong:
                                color = _kRed;
                                weight = FontWeight.w700;
                                if (_selectedOptionIndex != null && 
                                    _selectedOptionIndex != question.correctIndex) {
                                  text = question.options[_selectedOptionIndex!].toUpperCase();
                                }
                                break;
                              case SpanType.plain:
                                color = Colors.black87;
                                weight = FontWeight.w500;
                                break;
                            }
                            return TextSpan(
                              text: text,
                              style: TextStyle(
                                color: color,
                                fontWeight: weight,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // tap to continue
              Padding(
                padding: EdgeInsets.only(bottom: 32.h),
                child: Text(
                  'TAP TO CONTINUE',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCorrectionImage(String imagePath) {
    final bool isSvg = imagePath.toLowerCase().endsWith('.svg');
    return Container(
      width: double.infinity,
      height: 0.25.sh,
      margin: EdgeInsets.only(bottom: 16.h),
      child: isSvg
          ? SvgPicture.asset(
              imagePath,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                Colors.black87,
                BlendMode.srcIn,
              ),
            )
          : Image.asset(imagePath, fit: BoxFit.contain),
    );
  }

  // ─────────────────────────────────────────
  //  FULL IMAGE OVERLAY
  // ─────────────────────────────────────────
  Widget _buildFullImageOverlay(String imagePath) {
    final bool isSvg = imagePath.toLowerCase().endsWith('.svg');
    return GestureDetector(
      onTap: () => setState(() => _showFullImage = false),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              width: 0.88.sw,
              height: 0.72.sh,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                border: Border.all(color: Colors.white24, width: 1.5.w),
              ),
              child: ClipRect(
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 4.0,
                        child: Center(
                          child: isSvg
                              ? SvgPicture.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white38,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      left: 10.w,
                      child: GestureDetector(
                        onTap: () => setState(() => _showFullImage = false),
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}