import 'dart:async';
import 'dart:math';

import 'package:examdril/data/bns_question_data.dart';
import 'package:examdril/models/bns_question_model.dart';
import 'package:examdril/screens/best_next_step/bns_option_card.dart';
import 'package:examdril/screens/best_next_step/bns_pregame_screen.dart';
import 'package:examdril/screens/best_next_step/bns_result_screen.dart';
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
  late Animation<Offset> _hintAnim;

  late AnimationController _entryController;
  late Animation<Offset> _panelSlide;

  late AnimationController _submitPulse;

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
    _hintAnim = Tween<Offset>(begin: Offset.zero, end: const Offset(0.08, 0))
        .animate(
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
      if (!_hasInteracted && mounted && _phase == _Phase.playing && !_isPaused) {
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
      _goToResults();
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
                    SizedBox(height: 12.h),
                    _buildScenarioText(question.scenario),
                    SizedBox(height: 14.h),

                    Expanded(
                      child: SlideTransition(
                        position: _panelSlide,
                        child: Column(
                          children: [
                            Expanded(child: _buildOptionsPanel(question)),
                            SizedBox(height: 12.h),
                            _buildActionArea(),
                            SizedBox(height: 20.h),
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
        final color = Color.lerp(
          const Color(0xFF4DB89A),
          const Color(0xFFE53935),
          progress,
        );

        return Stack(
          children: [
            // Left bar
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: 6.w,
                height: MediaQuery.sizeOf(context).height * 0.7 * progress,
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
                height: MediaQuery.sizeOf(context).height * 0.7 * progress,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────
  //  TOP BAR
  // ─────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _togglePause,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: widget.theme.textColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.pause, color: widget.theme.textColor, size: 20.sp),
                ),
              ),
              SizedBox(width: 14.w),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: Text(
          scenario,
          key: ValueKey(_currentQuestion),
          style: TextStyle(
            color: widget.theme.textColor,
            fontSize: 19.2.sp,
            fontWeight: FontWeight.w700,
            height: 1.7,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  OPTIONS PANEL
  // ─────────────────────────────────────────
  Widget _buildOptionsPanel(BnsQuestion question) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: widget.theme.cardAreaColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildSlot(0, question)),
                SizedBox(width: 20.w),
                Expanded(child: _buildSlot(1, question)),
                SizedBox(width: 20.w),
                Expanded(child: _buildSlot(2, question)),
              ],
            ),
          ),
          SizedBox(height: 70.h),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildSlot(3, question)),
                SizedBox(width: 20.w),
                Expanded(child: _buildSlot(4, question)),
                SizedBox(width: 20.w),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlot(int slotIndex, BnsQuestion question) {
    final optionIndex = _slotAssignment[slotIndex];
    final optionText = question.options[optionIndex];
    final cardState = _cardStates[slotIndex];
    final label = kSlotLabels[slotIndex];

    return Column(
      children: [
        Expanded(
          child: _phase == _Phase.playing
              ? _buildDraggableSlot(
                  slotIndex,
                  optionIndex,
                  optionText,
                  cardState,
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: BnsOptionCard(
                    key: ValueKey('$slotIndex-$optionIndex-static'),
                    text: optionText,
                    state: cardState,
                    themeCardColor: widget.theme.cardColor,
                  ),
                ),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildDraggableSlot(
    int slotIndex,
    int optionIndex,
    String optionText,
    BnsCardState cardState,
  ) {
    final cardWidget = BnsOptionCard(
      key: ValueKey('$slotIndex-$optionIndex'),
      text: optionText,
      state: cardState,
      themeCardColor: widget.theme.cardColor,
    );

    return DragTarget<int>(
      onWillAcceptWithDetails: (details) => details.data != slotIndex,
      onAcceptWithDetails: (details) => _onSwap(details.data, slotIndex),
      builder: (ctx, candidates, rejected) {
        final isHovered = candidates.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.4),
                      blurRadius: 10.r,
                    ),
                  ]
                : [],
          ),
          child: Draggable<int>(
            data: slotIndex,
            onDragStarted: _dismissHint,
            feedback: Material(
              color: Colors.transparent,
              child: SizedBox(
                width: (MediaQuery.sizeOf(ctx).width - 56.w) / 3,
                height: 185.h,
                child: Transform.scale(
                  scale: 1.06,
                  child: BnsOptionCard(
                    text: optionText,
                    state: cardState,
                    themeCardColor: widget.theme.cardColor,
                  ),
                ),
              ),
            ),
            childWhenDragging: Opacity(opacity: 0.2, child: cardWidget),
            child: cardWidget,
          ),
        );
      },
    );
  }

  Widget _buildActionArea() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _phase == _Phase.corrected
            ? _buildContinueButton()
            : _showSubmit
            ? _buildSubmitButton()
            : const SizedBox.shrink(),
      ),
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
              Icon(Icons.double_arrow_rounded, size: 18.sp),
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
            Icon(Icons.double_arrow_rounded, size: 18.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildHandHint() {
    return Positioned(
      bottom: 100.h,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: SlideTransition(
            position: _hintAnim,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.swipe_rounded, color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Drag cards to swap',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
              onPressed: () {},
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
