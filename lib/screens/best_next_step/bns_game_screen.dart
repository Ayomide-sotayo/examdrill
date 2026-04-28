import 'dart:async';
import 'dart:math';

import 'package:examdril/data/bns_question_data.dart';
import 'package:examdril/models/bns_question_model.dart';
import 'package:examdril/screens/best_next_step/bns_instructions_screen.dart';
import 'package:examdril/screens/best_next_step/bns_option_card.dart';
import 'package:examdril/screens/best_next_step/bns_pregame_screen.dart';
import 'package:examdril/screens/best_next_step/bns_result_screen.dart';
import 'package:examdril/screens/best_next_step/bns_retry_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

enum _Phase { playing, evaluating, correcting, corrected }

class BnsGameScreen extends StatefulWidget {
  final BnsTheme theme;
  const BnsGameScreen({super.key, required this.theme});

  @override
  State<BnsGameScreen> createState() => _BnsGameScreenState();
}

class _BnsGameScreenState extends State<BnsGameScreen>
    with TickerProviderStateMixin {
  int _currentQuestion = 0;
  int _score = 0;
  int _lives = 4;
  int _perfectRounds = 0;

  List<int> _slotAssignment = [];
  List<BnsCardState> _cardStates = [];
  final List<BnsQuestionResult> _questionHistory = [];

  _Phase _phase = _Phase.playing;
  bool _hasInteracted = false;
  bool _showSubmit = false;
  bool _isPaused = false;

  Timer? _idleTimer;
  bool _showHandHint = false;
  late AnimationController _hintController;
  late Animation<double> _hintAnimation;

  late AnimationController _entryController;
  late Animation<Offset> _panelSlide;

  late AnimationController _submitPulse;
  final GlobalKey _panelKey = GlobalKey();

  // ── TIMER ───────────────────────────────
  late AnimationController _timerController;
  late Animation<double> _timerAnim;

  @override
  void initState() {
    super.initState();
    _initControllers();
    _initQuestion();
    _entryController.forward();
    _startIdleTimer();
  }

  void _initControllers() {
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _panelSlide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _entryController, curve: Curves.easeOutCubic),
        );

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _hintAnimation = Tween<double>(begin: 0, end: -30.0).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );

    _submitPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _timerController =
        AnimationController(
          vsync: this,
          duration: const Duration(seconds: 30),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed && _phase == _Phase.playing) {
            _onSubmit();
          }
        });
    _timerAnim = Tween<double>(begin: 0, end: 1).animate(_timerController);
  }

  void _initQuestion() {
    final count = bnsQuestions[_currentQuestion].options.length;
    _slotAssignment = List.generate(count, (i) => i)..shuffle(Random());
    _cardStates = List.filled(count, BnsCardState.normal);
    _phase = _Phase.playing;
    _hasInteracted = false;
    _showSubmit = false;
    _showHandHint = false;
    _hintController.stop();
    _hintController.reset();

    _timerController.reset();
    _timerController.forward();
  }

  void _startIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(seconds: 5), () {
      if (!_hasInteracted &&
          mounted &&
          _phase == _Phase.playing &&
          !_isPaused) {
        setState(() => _showHandHint = true);
        _hintController.repeat(reverse: true);
      }
    });
  }

  void _togglePause() {
    if (_phase != _Phase.playing) return;
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _timerController.stop();
        _idleTimer?.cancel();
        _hintController.stop();
      } else {
        _timerController.forward();
        _startIdleTimer();
      }
    });
  }

  void _restartGame() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _lives = 4;
      _isPaused = false;
      _questionHistory.clear();
      _initQuestion();
    });
  }

  void _dismissHint() {
    if (_showHandHint) {
      setState(() => _showHandHint = false);
      _hintController.stop();
      _hintController.reset();
    }
  }

  void _onSwap(int fromSlot, int toSlot) {
    if (fromSlot == toSlot || _phase != _Phase.playing || _isPaused) return;
    _dismissHint();
    setState(() {
      final tmp = _slotAssignment[fromSlot];
      _slotAssignment[fromSlot] = _slotAssignment[toSlot];
      _slotAssignment[toSlot] = tmp;

      if (!_hasInteracted) {
        _hasInteracted = true;
        _showSubmit = true;
        _idleTimer?.cancel();
      }
    });
  }

  Future<void> _onSubmit() async {
    if (_phase != _Phase.playing) return;
    _timerController.stop();

    setState(() {
      _phase = _Phase.evaluating;
      _showSubmit = false;
    });

    final correct = List.generate(5, (i) => _slotAssignment[i] == i);
    final allCorrect = correct.every((c) => c);

    setState(() {
      if (allCorrect) {
        _score += 500;
        _perfectRounds++;
      } else {
        _lives = max(0, _lives - 1);
      }

      for (int i = 0; i < 5; i++) {
        _cardStates[i] = correct[i] ? BnsCardState.correct : BnsCardState.wrong;
      }

      // Record History
      _questionHistory.add(
        BnsQuestionResult(
          question: bnsQuestions[_currentQuestion],
          slotAssignment: List.from(_slotAssignment),
          finalStates: List.from(_cardStates),
          isPerfect: allCorrect,
        ),
      );
    });

    await Future.delayed(const Duration(milliseconds: 1400));

    if (allCorrect) {
      await Future.delayed(const Duration(milliseconds: 400));
      _nextQuestion();
      return;
    }

    if (_lives == 0) {
      await _animateCorrection();
      await Future.delayed(const Duration(milliseconds: 500));
      _goToRetry();
      return;
    }

    setState(() => _phase = _Phase.correcting);
    await _animateCorrection();

    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _cardStates = List.filled(5, BnsCardState.correction);
      _phase = _Phase.corrected;
    });
  }

  Future<void> _animateCorrection() async {
    final tracking = List<int>.from(_slotAssignment);
    for (int target = 0; target < 5; target++) {
      if (tracking[target] != target) {
        final src = tracking.indexOf(target);
        if (src != -1) {
          if (mounted) {
            setState(() {
              final tmpOpt = _slotAssignment[target];
              _slotAssignment[target] = _slotAssignment[src];
              _slotAssignment[src] = tmpOpt;

              final tmpState = _cardStates[target];
              _cardStates[target] = _cardStates[src];
              _cardStates[src] = tmpState;

              tracking[src] = tmpOpt;
              tracking[target] = target;
            });
          }
          await Future.delayed(const Duration(milliseconds: 550));
        }
      }
    }
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void _nextQuestion() {
    if (_currentQuestion < bnsQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
        _initQuestion();
      });
      _entryController.reset();
      _entryController.forward();
      _startIdleTimer();
    } else {
      _goToResults();
    }
  }

  void _goToResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BnsResultScreen(
          score: _score,
          correctAnswers: _perfectRounds,
          speedyAnswers: 1, // Placeholder
          totalQuestions: bnsQuestions.length,
          results: _questionHistory,
          theme: widget.theme,
        ),
      ),
    );
  }

  void _goToRetry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BnsRetryScreen(
          results: _questionHistory,
          theme: widget.theme,
        ),
      ),
    );

    if (result == 'retry') {
      _restartGame();
    } else if (result == 'quit') {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _hintController.dispose();
    _entryController.dispose();
    _submitPulse.dispose();
    _timerController.dispose();
    _idleTimer?.cancel();
    super.dispose();
  }

  // ─────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final question = bnsQuestions[_currentQuestion];

    return Scaffold(
      body: GestureDetector(
        onTap: _dismissHint,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // ── Themed background ──────────────────
            Positioned.fill(
              child: Image.asset(
                widget.theme.bgAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: widget.theme.cardAreaColor.withValues(alpha: 0.3),
                ),
              ),
            ),

            // ── TIMER BARS ─────────────────────────
            _buildTimerBars(),

            // ── Main UI ────────────────────────────
            SafeArea(
              child: Opacity(
                opacity: _isPaused ? 0.45 : 1.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(),

                    Center(child: _buildScenarioText(question.scenario)),
                    Expanded(
                      child: SlideTransition(
                        position: _panelSlide,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),
                            Center(child: _buildOptionsPanel(question)),
                            SizedBox(height: 20.h),
                            SizedBox(
                              height: 60.h,
                              child: Center(child: _buildActionArea()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_showHandHint && !_isPaused) _buildHandHint(),

            if (_isPaused) _buildPauseOverlay(),
          ],
        ),
      ),
    );
  }

  // ── TIMER BARS WIDGET ────────────────────
  Widget _buildTimerBars() {
    return AnimatedBuilder(
      animation: _timerAnim,
      builder: (context, child) {
        final progress = _timerAnim.value;
        final isPlaying = _phase == _Phase.playing;
        final color = Color.lerp(
          const Color(0xFF4CAF50),
          const Color(0xFFE53935),
          progress,
        );

        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isPlaying ? 1.0 : 0.0,
          child: Stack(
            children: [
              // Left bar
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  width: 6.w,
                  height: MediaQuery.sizeOf(context).height * 0.69 * progress,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.r),
                    ),
                  ),
                ),
              ),
              // Right bar
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 6.w,
                  height: MediaQuery.sizeOf(context).height * 0.69 * progress,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  TOP BAR
  // ─────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _togglePause,
                child: Icon(
                  Icons.pause,
                  color: widget.theme.textColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                '$_score',
                style: TextStyle(
                  color: widget.theme.textColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: List.generate(4, (i) {
              final alive = i >= (4 - _lives);
              return Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: alive ? 1.0 : 0.25,
                  child: Image.asset(
                    'assets/images/bunny.png',
                    height: 26.h,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                      size: 22.sp,
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
  //  SCENARIO TEXT
  // ─────────────────────────────────────────
  Widget _buildScenarioText(String scenario) {
    return Container(
      width: 358.w,
      height: 170.h,
      padding: EdgeInsets.only(top: 12.6.h, right: 12.2.w, left: 12.2.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
      child: SingleChildScrollView(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: Text(
            scenario,
            key: ValueKey(_currentQuestion),
            style: TextStyle(
              fontFamily: 'Roboto',
              color: widget.theme.textColor,
              fontSize: 19.2.sp,
              fontWeight: FontWeight.w500, // Medium
              height: 1.5,
              letterSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  OPTIONS PANEL (STACK-BASED FOR FLYING)
  // ─────────────────────────────────────────
  Offset _getSlotPosition(int slotIndex) {
    final double x0 = 12.w;
    final double x1 = 126.w;
    final double x2 = 241.w;

    final double y0 = 50.h;
    final double y1 = 270.h;

    switch (slotIndex) {
      case 0:
        return Offset(x0, y0);
      case 1:
        return Offset(x1, y0);
      case 2:
        return Offset(x2, y0);
      case 3:
        return Offset(x0, y1);
      case 4:
        return Offset(x1, y1);
      default:
        return Offset.zero;
    }
  }

  Widget _buildOptionsPanel(BnsQuestion question) {
    return Container(
      key: _panelKey,
      width: 358.w,
      height: 460.h,
      decoration: BoxDecoration(
        color: widget.theme.cardAreaColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        children: [
          // 1. Static labels and DragTargets
          for (int slot = 0; slot < 5; slot++) _buildStaticSlotTarget(slot),

          // 2. The flying/draggable cards
          for (int opt = 0; opt < 5; opt++) _buildFlyingCard(opt, question),

          // 3. Hand hint icon tracking slot 0
          if (_showHandHint && !_isPaused)
            AnimatedBuilder(
              animation: _hintAnimation,
              builder: (ctx, child) {
                final pos0 = _getSlotPosition(0);
                return Positioned(
                  left: pos0.dx + 40.w,
                  top: pos0.dy + 80.h + _hintAnimation.value,
                  child: IgnorePointer(
                    child: Image.asset('assets/images/hand.png', width: 48.w),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStaticSlotTarget(int slotIndex) {
    final pos = _getSlotPosition(slotIndex);
    final label = kSlotLabels[slotIndex];

    return Positioned(
      left: pos.dx,
      top: pos.dy + 160.h, // Positioned just below where the card sits
      width: 105.w,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildFlyingCard(int optionIndex, BnsQuestion question) {
    final currentSlot = _slotAssignment.indexOf(optionIndex);
    final pos = _getSlotPosition(currentSlot);
    final cardState = _cardStates[currentSlot];
    final optionText = question.options[optionIndex];

    final cardWidget = BnsOptionCard(
      key: ValueKey('opt-$optionIndex'),
      text: optionText,
      state: cardState,
      themeCardColor: widget.theme.cardColor,
      colorIndex: optionIndex, // Assign distinct color based on option
    );

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 550), // Smooth flying animation
      curve: Curves.easeInOutCubic,
      left: pos.dx,
      top: pos.dy,
      width: 92.w,
      height: 145.6.h,
      child: DragTarget<int>(
        onWillAcceptWithDetails: (details) {
          // details.data is the optionIndex of the card being dragged
          final draggedOption = details.data;
          final draggedSlot = _slotAssignment.indexOf(draggedOption);
          if (draggedSlot != currentSlot && _phase == _Phase.playing && !_isPaused) {
            // Immediately swap so the displaced card flies to the old slot
            _onSwap(draggedSlot, currentSlot);
          }
          return true;
        },
        onAcceptWithDetails: (_) {
          // Swap already happened on hover, nothing to do on drop
        },
        builder: (ctx, candidates, rejected) {
          final isHovered = candidates.isNotEmpty;
          Widget content = AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.4.r),
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        blurRadius: 10.r,
                      ),
                    ]
                  : [],
            ),
            child: _phase == _Phase.playing
                ? Draggable<int>(
                    data: optionIndex, // Pass the option identity, not the slot
                    onDragStarted: _dismissHint,
                    feedback: cardWidget,
                    childWhenDragging: Opacity(opacity: 0.2, child: cardWidget),
                    child: cardWidget,
                  )
                : cardWidget,
          );

          // Animate card 0 moving slightly with the hand
          if (_showHandHint &&
              !_isPaused &&
              currentSlot == 0 &&
              _phase == _Phase.playing) {
            return AnimatedBuilder(
              animation: _hintAnimation,
              builder: (ctx, child) {
                return Transform.translate(
                  offset: Offset(0, _hintAnimation.value),
                  child: child,
                );
              },
              child: content,
            );
          }

          return content;
        },
      ),
    );
  }

  Widget _buildActionArea() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _phase == _Phase.corrected
          ? _buildContinueButton()
          : _showSubmit
          ? _buildSubmitButton()
          : const SizedBox.shrink(),
    );
  }

  Widget _buildSubmitButton() {
    return AnimatedBuilder(
      animation: _submitPulse,
      builder: (_, child) =>
          Transform.scale(scale: 1.0 + 0.02 * _submitPulse.value, child: child),
      child: SizedBox(
        height: 50.h,
        width: 180.w,
        child: ElevatedButton(
          onPressed: _onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.theme.cardColor,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
            elevation: 4,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Submit',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 8.w),
              Image.asset('assets/images/arrow.png', width: 18.sp, height: 18.sp, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      height: 50.h,
      width: 180.w,
      child: ElevatedButton(
        onPressed: _nextQuestion,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.theme.cardColor,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Continue',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: 8.w),
            Image.asset('assets/images/arrow.png', width: 18.sp, height: 18.sp, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildHandHint() {
    Offset panelOffset = Offset.zero;
    if (_panelKey.currentContext != null) {
      final RenderBox box =
          _panelKey.currentContext!.findRenderObject() as RenderBox;
      panelOffset = box.localToGlobal(Offset.zero);
    }
    final pos0 = _getSlotPosition(0);

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Dark Overlay
            Container(color: Colors.black.withOpacity(0.8)),

            // The Hand (Tracking Slot 0)
            AnimatedBuilder(
              animation: _hintAnimation,
              builder: (ctx, child) {
                return Positioned(
                  left: panelOffset.dx + pos0.dx + 40.w,
                  top: panelOffset.dy + pos0.dy + 80.h + _hintAnimation.value,
                  child: Image.asset('assets/images/hand.png', width: 48.w),
                );
              },
            ),

            // Hint Text
            Positioned(
              top:
                  panelOffset.dy +
                  448.h +
                  30.h, // A little below the options panel
              left: 0,
              right: 0,
              child: Text(
                'Swap the cards to play',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  PAUSE OVERLAY
  // ─────────────────────────────────────────
  Widget _buildPauseOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Colors.black.withOpacity(0.6),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Paused',
              style: TextStyle(
                color: Colors.white,
                fontSize: 42.sp,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 60.h),
            _buildPauseButton('Resume', _togglePause),
            SizedBox(height: 16.h),
            _buildPauseButton('Restart', _restartGame),
            SizedBox(height: 16.h),
            _buildPauseButton('Quit', () => Navigator.pop(context)),
            SizedBox(height: 80.h),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BnsInstructionsScreen(theme: widget.theme),
                  ),
                );
              },
              child: Text(
                'Game Instructions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPauseButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: 300.w,
      height: 60.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.theme.cardColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
