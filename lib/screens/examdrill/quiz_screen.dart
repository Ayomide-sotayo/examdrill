import 'dart:async';
import 'dart:ui';
import 'package:examdril/data/question_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import '../../models/question_model.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String? selectedTheme;
  final bool isSoundEnabled;
  const QuizScreen({super.key, this.selectedTheme, this.isSoundEnabled = true});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int? _selectedOptionIndex;
  final List<bool> _results = [];
  bool _isAnimating = false;
  bool _showFullImage = false;
  bool _isPaused = false;

  // Timer
  static const int _questionDuration = 20;
  int _secondsLeft = _questionDuration;
  Timer? _questionTimer;

  late AudioPlayer _bgPlayer;
  late AudioPlayer _sfxPlayer;

  @override
  void initState() {
    super.initState();
    _bgPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();
    _initAudio();
    _startTimer();
  }

  Future<void> _initAudio() async {
    try {
      await _bgPlayer.setAsset('assets/audio/good_background_sound.mp3');
      await _bgPlayer.setLoopMode(LoopMode.one);
      await _sfxPlayer.setAsset('assets/audio/correct_sound_2.mp3');
      _playBackgroundMusic();
    } catch (e) {
      debugPrint("Audio init error: $e");
    }
  }

  Future<void> _playBackgroundMusic() async {
    if (!widget.isSoundEnabled) return;
    try {
      await _bgPlayer.seek(Duration.zero);
      _bgPlayer.play();
    } catch (e) {
      debugPrint("BG music error: $e");
    }
  }

  Future<void> _playCorrectSound() async {
    if (!widget.isSoundEnabled) return;
    try {
      await _sfxPlayer.seek(Duration.zero);
      _sfxPlayer.play();
    } catch (e) {
      debugPrint("SFX error: $e");
    }
  }

  void _startTimer() {
    _cancelTimer();
    setState(() => _secondsLeft = _questionDuration);
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isAnimating || _isPaused) return;
      if (_secondsLeft <= 1) {
        _cancelTimer();
        _onTimeExpired();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _cancelTimer() {
    _questionTimer?.cancel();
    _questionTimer = null;
  }

  void _onTimeExpired() async {
    if (_isAnimating || _selectedOptionIndex != null) return;
    setState(() => _isAnimating = true);
    await _bgPlayer.stop();
    _results.add(false);
    await Future.delayed(const Duration(milliseconds: 800));
    if (_currentQuestion < quizQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedOptionIndex = null;
        _isAnimating = false;
        _showFullImage = false;
      });
      _startTimer();
      await _playBackgroundMusic();
    } else {
      await _bgPlayer.stop();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(results: _results)),
        );
      }
    }
  }

  void _onOptionSelected(int index) async {
    if (_isAnimating || _selectedOptionIndex != null) return;
    _cancelTimer();

    setState(() {
      _selectedOptionIndex = index;
      _isAnimating = true;
    });

    await _bgPlayer.stop();
    await _playCorrectSound();

    await Future.delayed(const Duration(milliseconds: 1600));

    final isCorrect = index == quizQuestions[_currentQuestion].correctIndex;
    _results.add(isCorrect);

    if (_currentQuestion < quizQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedOptionIndex = null;
        _isAnimating = false;
        _showFullImage = false;
      });
      _startTimer();
      await _playBackgroundMusic();
    } else {
      await _bgPlayer.stop();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(results: _results)),
        );
      }
    }
  }

  // Theme helpers
  bool get _isTheme2 => widget.selectedTheme == 'assets/images/theme_2.png';
  bool get _isTheme3 => widget.selectedTheme == 'assets/images/theme_3.png';
  bool get _isTheme4 => widget.selectedTheme == 'assets/images/theme_4.png';
  bool get _isDarkTheme => _isTheme3;
  bool get _isTransitioning => _isAnimating;

  // Color getters (unchanged logic)
  Color get _baseTextColor {
    if (_isTransitioning) return const Color(0xFF0D2D5E);
    if (_isDarkTheme) return Colors.white;
    if (_isTheme2) return const Color(0xFF0D3157);
    if (_isTheme4) return const Color(0xFF6B2D52);
    return const Color(0xFF6B1F3A);
  }

  Color get _unselectedOptionBg {
    if (_isTransitioning) return Colors.white.withOpacity(0.20);
    if (_isDarkTheme) return const Color(0xFF0B5A7F);
    return Colors.white.withOpacity(0.72);
  }

  Color get _selectedOptionBg {
    if (_isTransitioning) return Colors.white.withOpacity(0.30);
    if (_isDarkTheme) return Colors.white;
    if (_isTheme2) return const Color(0xFF0D3157);
    if (_isTheme4) return Colors.white;
    return Colors.white;
  }

  Color get _selectedOptionText {
    if (_isTransitioning) return const Color(0xFF0D2D5E);
    if (_isDarkTheme) return const Color(0xFF0D1F44);
    if (_isTheme2) return Colors.white;
    if (_isTheme4) return const Color(0xFF6B2D52);
    return const Color(0xFF6B1F3A);
  }

  Color get _selectedOptionBorder {
    if (_isTransitioning) return Colors.white.withOpacity(0.6);
    if (_isDarkTheme) return Colors.white.withOpacity(0.9);
    if (_isTheme2) return const Color(0xFF0D3157);
    if (_isTheme4) return const Color(0xFFD48BA0);
    return const Color(0xFFB15F83);
  }

  Color get _unselectedOptionBorder {
    if (_isTransitioning) return Colors.white.withOpacity(0.3);
    if (_isDarkTheme) return Colors.white.withOpacity(0.15);
    if (_isTheme2) return const Color(0xFF0D3157).withOpacity(0.25);
    if (_isTheme4) return const Color(0xFFD48BA0).withOpacity(0.3);
    return const Color(0xFFB15F83).withOpacity(0.3);
  }

  Color get _unselectedOptionText {
    if (_isTransitioning) return const Color(0xFF0D2D5E);
    if (_isDarkTheme) return Colors.white.withOpacity(0.90);
    if (_isTheme2) return const Color(0xFF0D3157);
    if (_isTheme4) return const Color(0xFF6B2D52);
    return const Color(0xFF6B1F3A);
  }

  Color get _graphLineColor {
    if (_isTransitioning) return const Color(0xFF0D2D5E);
    if (_isDarkTheme) return Colors.white;
    if (_isTheme2) return const Color(0xFF0D3157);
    if (_isTheme4) return const Color(0xFF6B2D52);
    return const Color(0xFF6B1F3A);
  }

  Color get _tableBorderColor {
    if (_isTransitioning) return Colors.white.withOpacity(0.6);
    if (_isDarkTheme) return Colors.white.withOpacity(0.2);
    if (_isTheme2) return const Color(0xFF0D3157).withOpacity(0.4);
    if (_isTheme4) return const Color(0xFF6B2D52).withOpacity(0.4);
    return const Color(0xFF6B1F3A).withOpacity(0.4);
  }

  Color get _topBarIconColor {
    if (_isTransitioning) return Colors.white;
    if (_isDarkTheme) return Colors.white;
    if (_isTheme2) return const Color(0xFF0D3157);
    if (_isTheme4) return const Color(0xFF6B2D52);
    return const Color(0xFF893B5D);
  }

  Color get _progressBarActiveColor {
    if (_isTransitioning) return Colors.white;
    if (_isDarkTheme) return Colors.white;
    if (_isTheme2) return const Color(0xFF0D3157);
    if (_isTheme4) return const Color(0xFFD48BA0);
    return const Color(0xFFB15F83);
  }

  bool _hasTopContent(QuestionModel question) {
    return question.type != QuestionType.text;
  }

  @override
  void dispose() {
    _cancelTimer();
    _bgPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  void _togglePause() {
    if (_isAnimating) return;
    setState(() {
      _isPaused = !_isPaused;
    });
    if (_isPaused) {
      _bgPlayer.pause();
    } else {
      if (widget.isSoundEnabled) {
        _bgPlayer.play();
      }
    }
  }

  void _resumeGame() {
    _togglePause();
  }

  void _restartGame() {
    setState(() {
      _currentQuestion = 0;
      _selectedOptionIndex = null;
      _results.clear();
      _isAnimating = false;
      _showFullImage = false;
      _isPaused = false;
      _secondsLeft = _questionDuration;
    });
    _bgPlayer.seek(Duration.zero);
    if (widget.isSoundEnabled) {
      _bgPlayer.play();
    }
    _startTimer();
  }

  void _quitGame() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final question = quizQuestions[_currentQuestion];

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
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
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: _buildOptions(question),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_showFullImage && question.imagePath != null)
            _buildFullImageOverlay(question.imagePath!),

          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomProgressBar(),
          ),
          if (_isPaused) _buildPauseOverlay(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    final fallbackColors = _isDarkTheme
        ? const [Color(0xFF0D2137), Color(0xFF1A3A5C), Color(0xFF0D2137)]
        : const [Color(0xFF5CE1E6), Colors.white, Color(0xFFD3C5E5)];

    final Widget baseBg = widget.selectedTheme != null
        ? Image.asset(
            widget.selectedTheme!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : Container(color: const Color(0xFFF5C2D0));

    final Widget transitionLayer = AnimatedOpacity(
      opacity: _isAnimating ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Image.asset(
        'assets/images/transition_bg.png',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: fallbackColors,
            ),
          ),
        ),
      ),
    );

    return Stack(fit: StackFit.expand, children: [baseBg, transitionLayer]);
  }

  Widget _buildTopBar() {
    final bool isWarning = _secondsLeft <= 5;
    final Color ringColor = isWarning ? Colors.red.shade400 : _topBarIconColor;

    return Container(
      width: double.infinity,
      height: 60.h,
      margin: EdgeInsets.only(top: 12.h, bottom: 12.h),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -25.h,
            right: -4.w,
            child: Transform.rotate(
              angle: -1.3,
              child: Image.asset(
                'assets/images/rabbit.png',
                height: 50.h,
                errorBuilder: (_, __, ___) =>
                    const SizedBox(width: 75, height: 75),
              ),
            ),
          ),
          SizedBox(
            width: 52.r,
            height: 52.r,
            child: CustomPaint(
              painter: _TimerRingPainter(
                progress: _secondsLeft / _questionDuration,
                color: ringColor,
                trackColor: ringColor.withOpacity(0.18),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _togglePause,
                  child: Icon(Icons.pause_rounded, color: ringColor, size: 24.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomProgressBar() {
    return Row(
      children: List.generate(quizQuestions.length, (i) {
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 8.h,
            margin: EdgeInsets.only(right: 2.w),
            decoration: BoxDecoration(
              color: i <= _currentQuestion
                  ? _progressBarActiveColor
                  : Colors.white54,
              borderRadius: BorderRadius.zero,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildImageSection(String imagePath, String? label) {
    final radius = _isTransitioning
        ? BorderRadius.zero
        : BorderRadius.circular(12.r);

    final bool isSvg = imagePath.toLowerCase().endsWith('.svg');

    return Column(
      children: [
        Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: double.infinity,
              height: 180.h,
              margin: EdgeInsets.only(top: 8.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: radius,
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: isSvg
                    ? SvgPicture.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          _graphLineColor,
                          BlendMode.srcIn,
                        ),
                        placeholderBuilder: (_) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 50,
                            color: Colors.white38,
                          ),
                        ),
                      ),
              ),
            ),
            if (!_isTransitioning)
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
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'Full view',
                      style: TextStyle(
                        color: _isDarkTheme
                            ? const Color(0xFF0D1F44)
                            : _topBarIconColor,
                        fontSize: 12.sp,
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
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: _baseTextColor.withOpacity(0.7),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCaseText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        child: Text(
          text,
          style: TextStyle(
            color: _baseTextColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            height: 2.0,
          ),
        ),
      ),
    );
  }

  Widget _buildTableSection(QuestionModel question) {
    if (question.tableData == null || question.tableData!.isEmpty) {
      return const SizedBox();
    }
    final headers = question.tableData!.first;
    final rows = question.tableData!.skip(1).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: DataTable(
        headingRowHeight: 50.h,
        dataRowMinHeight: 45.h,
        dataRowMaxHeight: 45.h,
        columnSpacing: 0,
        border: TableBorder.all(color: _tableBorderColor, width: 1.5.w),
        columns: headers
            .map(
              (h) => DataColumn(
                label: Expanded(
                  child: Center(
                    child: Text(
                      h,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: _baseTextColor,
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
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: _baseTextColor,
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

  Widget _buildQuestionText(String question) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Text(
        question,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _baseTextColor,
          fontSize: 21.sp,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildTopContent(QuestionModel question) {
    return AnimatedScale(
      scale: _isAnimating ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Column(
          key: ValueKey<int>(_currentQuestion),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (question.type == QuestionType.imageGraph &&
                question.imagePath != null)
              _buildImageSection(question.imagePath!, 'Graph/Image Reference'),

            if (question.type == QuestionType.table)
              _buildTableSection(question),

            if (question.type == QuestionType.caseStudy &&
                question.caseText != null)
              _buildCaseText(question.caseText!),

            SizedBox(height: _hasTopContent(question) ? 12.h : 0),
            _buildQuestionText(question.question),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(QuestionModel question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(question.options.length, (i) {
        final isSelected = _selectedOptionIndex == i;
        final falling = _isAnimating && !isSelected;

        return Expanded(
          child: AnimatedSlide(
            offset: falling ? const Offset(0, 3.0) : Offset.zero,
            duration: const Duration(milliseconds: 1000),
            curve: falling ? Curves.easeInBack : Curves.easeOutBack,
            child: AnimatedOpacity(
              opacity: falling ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 1000),
              child: GestureDetector(
                onTap: () => _onOptionSelected(i),
                child: AnimatedScale(
                  scale: isSelected ? 1.02 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: isSelected && _isTransitioning
                      ? Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 6.h),
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.8),
                                  width: 1.5.w,
                                ),
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.lightBlue.withOpacity(0.6),
                                      blurRadius: 20.r,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    child: Text(
                                      question.options[i],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0D2D5E),
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 6.h),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _selectedOptionBg
                                : _unselectedOptionBg,
                            border: Border.all(
                              color: isSelected
                                  ? _selectedOptionBorder
                                  : _unselectedOptionBorder,
                              width: isSelected ? 2.w : 1.w,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.lightBlue.withOpacity(0.3),
                                      blurRadius: 15.r,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                question.options[i],
                                key: ValueKey<String>(question.options[i]),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? _selectedOptionText
                                      : _unselectedOptionText,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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

  Widget _buildFullImageOverlay(String imagePath) {
    final bool isSvg = imagePath.toLowerCase().endsWith('.svg');

    return GestureDetector(
      onTap: () => setState(() => _showFullImage = false),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: Colors.black.withOpacity(0.3),
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              width: 0.85.sw,
              height: 0.75.sh,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.zero,
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.5.w,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
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
                                  colorFilter: ColorFilter.mode(
                                    _graphLineColor,
                                    BlendMode.srcIn,
                                  ),
                                )
                              : Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white,
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
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 26.sp,
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

  Widget _buildPauseOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPauseButton('RESUME', _resumeGame),
              SizedBox(height: 16.h),
              _buildPauseButton('RESTART', _restartGame),
              SizedBox(height: 16.h),
              _buildPauseButton('QUIT', _quitGame),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPauseButton(String label, VoidCallback onTap) {
    return SizedBox(
      width: 220.w,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF6B1F3A),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

// Timer Ring Painter (unchanged)
class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  const _TimerRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 3.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    final sweepAngle = -2 * 3.141592653589793 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      -sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_TimerRingPainter old) =>
      old.progress != progress || old.color != color;
}
