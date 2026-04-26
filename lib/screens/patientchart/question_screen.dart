import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../../models/patient_model.dart';
import '../../data/patients_data.dart';
import 'result_screen_patient.dart';
import 'patient_chart_instructions_screen.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with TickerProviderStateMixin {
  // â”€â”€ Data â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _lives = 4;
  int _currentPatientIndex = 0;
  int _correctAnswersCount = 0;
  int _speedyAnswersCount = 0;

  // â”€â”€ Phase â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // 'reading'    = introducing patients one by one
  // 'question'   = question shown, avatars in 2x2 grid
  // 'correction' = correction overlay visible
  String _phase = 'reading';

  // patients introduced so far
  final List<Patient> _readPatients = [];

  // top bar feedback color
  Color _topBarColor = const Color(0xFFD9D9D9);

  // whether top bar is in answered state (green or red)
  bool get _isAnswered =>
      _topBarColor == const Color(0xFF54CA6E) ||
      _topBarColor == const Color(0xFFCF594A);

  // top bar content color â€” white when answered for visibility
  Color get _topBarContentColor =>
      _isAnswered ? Colors.white : const Color(0xFF6B5B7B);

  // whether to show avatars in top bar
  bool _showAvatarsInTopBar = false;

  // whether center avatar is currently flying
  bool _isAvatarFlyingToTopBar = false;

  // whether top bar avatars are currently flying
  bool _isAvatarsFlyingToGrid = false;

  // whether to show question text before grid
  bool _showQuestionText = false;

  // â”€â”€ Pause State â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  bool _isPaused = false;
  bool _isMuted = false;
  bool _wasTimerRunning = false;
  int _currentCorrectionPage = 0;

  // â”€â”€ Global keys for position tracking â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final GlobalKey _centerAvatarKey = GlobalKey();
  final List<GlobalKey> _topBarAvatarKeys = List.generate(
    4,
    (_) => GlobalKey(),
  );
  final List<GlobalKey> _gridAvatarKeys = List.generate(4, (_) => GlobalKey());

  // â”€â”€ TTS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  final FlutterTts _tts = FlutterTts();

  // â”€â”€ Timer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late AnimationController _timerController;
  static const int _timerDuration = 20;

  // â”€â”€ Video Wave â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late VideoPlayerController _videoController;

  // â”€â”€ Top bar slide â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late AnimationController _topBarController;
  late Animation<double> _topBarSize;

  final GlobalKey _topBarKey = GlobalKey();
  double _topBarHeight = 0;

  // â”€â”€ Patient zoom in â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late AnimationController _patientZoomController;
  late Animation<double> _patientScale;
  late Animation<double> _patientOpacity;

  // â”€â”€ Question text fade in â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late AnimationController _questionTextController;
  late Animation<double> _questionTextOpacity;

  // â”€â”€ Grid animation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late AnimationController _gridController;
  late Animation<double> _gridOpacity;

  // â”€â”€ Timer return animation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late AnimationController _timerReturnController;
  late Animation<double> _timerReturnAnimation;

  // â”€â”€ Correction overlay â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  late AnimationController _correctionController;
  late Animation<Offset> _correctionSlide;

  // â”€â”€ Flying avatar overlay entries â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  OverlayEntry? _flyingAvatarEntry;

  PatientQuestion get _currentQuestion =>
      patientQuestions[_currentQuestionIndex];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _topBarKey.currentContext != null) {
        setState(() {
          _topBarHeight = _topBarKey.currentContext!.size!.height;
        });
      }
    });

    _setupAnimations();
    _setupTts();
    _topBarController.forward().then((_) => _introduceNextPatient());
  }

  void _setupAnimations() {
    _topBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _topBarSize = CurvedAnimation(parent: _topBarController, curve: Curves.easeOut);

    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _timerDuration),
    );
    _timerController.addListener(() => setState(() {}));
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _onTimerExpired();
    });

    _timerReturnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _timerReturnAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _timerReturnController, curve: Curves.easeInOut),
    );
    _timerReturnController.addListener(() => setState(() {}));

    _videoController = VideoPlayerController.asset('assets/images/wave.mp4')
      ..initialize().then((_) {
        _videoController.setLooping(true);
        _videoController.setVolume(0.0); // Mutes the audio
        _videoController.play();
        if (mounted) setState(() {});
      });

    _patientZoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _patientScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _patientZoomController,
        curve: Curves.easeOutBack,
      ),
    );
    _patientOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _patientZoomController, curve: Curves.easeIn),
    );

    _questionTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _questionTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _questionTextController, curve: Curves.easeIn),
    );

    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _gridOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _gridController, curve: Curves.easeIn));

    _correctionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _correctionSlide =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: _correctionController, curve: Curves.easeOut),
        );
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
  }

  // â”€â”€ Flying avatar animation â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _flyAvatarToTopBar(Patient patient, int topBarSlot) async {
    // Get center avatar position
    final centerBox =
        _centerAvatarKey.currentContext?.findRenderObject() as RenderBox?;
    final topBarBox =
        _topBarAvatarKeys[topBarSlot].currentContext?.findRenderObject()
            as RenderBox?;

    if (centerBox == null || topBarBox == null) return;

    final centerPos = centerBox.localToGlobal(Offset.zero);
    final topBarPos = topBarBox.localToGlobal(Offset.zero);
    final centerSize = centerBox.size;
    final topBarSize = topBarBox.size;

    // Animate from center to top bar
    final animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final xAnim = Tween<double>(
      begin: centerPos.dx,
      end: topBarPos.dx,
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeInOut));
    final yAnim = Tween<double>(
      begin: centerPos.dy,
      end: topBarPos.dy,
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeInOut));
    final sizeAnim = Tween<double>(
      begin: centerSize.width,
      end: topBarSize.width,
    ).animate(CurvedAnimation(parent: animController, curve: Curves.easeInOut));

    _flyingAvatarEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: animController,
        builder: (context, child) {
          return Positioned(
            left: xAnim.value,
            top: yAnim.value,
            width: sizeAnim.value,
            height: sizeAnim.value,
            child: CircleAvatar(
              backgroundImage: AssetImage(patient.imagePath),
              backgroundColor: const Color(0xFFE8E8E8),
            ),
          );
        },
      ),
    );

    Overlay.of(context).insert(_flyingAvatarEntry!);
    await animController.forward();
    _flyingAvatarEntry?.remove();
    _flyingAvatarEntry = null;
    animController.dispose();
  }

  Future<void> _flyAvatarsToGrid() async {
    // Get top bar positions and grid positions
    final List<OverlayEntry> entries = [];
    final List<AnimationController> controllers = [];

    for (int i = 0; i < 4; i++) {
      final topBarBox =
          _topBarAvatarKeys[i].currentContext?.findRenderObject() as RenderBox?;
      final gridBox =
          _gridAvatarKeys[i].currentContext?.findRenderObject() as RenderBox?;

      if (topBarBox == null || gridBox == null) continue;

      final topBarPos = topBarBox.localToGlobal(Offset.zero);
      final gridPos = gridBox.localToGlobal(Offset.zero);
      final topBarSize = topBarBox.size;
      final gridSize = gridBox.size;
      final patient = _currentQuestion.patients[i];

      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      controllers.add(ctrl);

      final xAnim = Tween<double>(
        begin: topBarPos.dx,
        end: gridPos.dx,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));
      final yAnim = Tween<double>(
        begin: topBarPos.dy,
        end: gridPos.dy,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));
      final sizeAnim = Tween<double>(
        begin: topBarSize.width,
        end: gridSize.width,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));

      final entry = OverlayEntry(
        builder: (context) => AnimatedBuilder(
          animation: ctrl,
          builder: (context, child) {
            return Positioned(
              left: xAnim.value,
              top: yAnim.value,
              width: sizeAnim.value,
              height: sizeAnim.value,
              child: CircleAvatar(
                backgroundImage: AssetImage(patient.imagePath),
                backgroundColor: const Color(0xFFE8E8E8),
              ),
            );
          },
        ),
      );
      entries.add(entry);
      Overlay.of(context).insert(entry);
    }

    // Animate all simultaneously
    await Future.wait(controllers.map((c) => c.forward()));

    for (final e in entries) {
      e.remove();
    }
    for (final c in controllers) {
      c.dispose();
    }
  }

  // â”€â”€ Patient introduction â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _introduceNextPatient() async {
    if (_currentPatientIndex >= _currentQuestion.patients.length) {
      await Future.delayed(const Duration(milliseconds: 300));
      _showQuestion();
      return;
    }

    _patientZoomController.reset();
    _patientZoomController.forward();
    setState(() {});

    final patient = _currentQuestion.patients[_currentPatientIndex];
    final speech = '${patient.name}. ${patient.prescriptions.join('. ')}';

    await Future.delayed(const Duration(milliseconds: 500));
    await _tts.speak(speech);

    _tts.setCompletionHandler(() async {
      if (!mounted) return;

      // Wait for top bar slot to be rendered
      await Future.delayed(const Duration(milliseconds: 100));

      setState(() => _isAvatarFlyingToTopBar = true);
      // Fly avatar from center to top bar
      await _flyAvatarToTopBar(patient, _currentPatientIndex);

      setState(() {
        _isAvatarFlyingToTopBar = false;
        _readPatients.add(patient);
        _currentPatientIndex++;
      });

      await Future.delayed(const Duration(milliseconds: 200));
      _introduceNextPatient();
    });
  }

  // â”€â”€ Show question text then fly avatars to grid â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Future<void> _showQuestion() async {
    // Switch to question phase immediately so question text shows below top bar
    setState(() {
      _phase = 'question';
      _showAvatarsInTopBar = true; // KEEP THEM VISIBLE WHILE READING
      _showQuestionText = false;
    });

    // Read the question out loud
    await Future.delayed(const Duration(milliseconds: 200));
    await _tts.speak(_currentQuestion.question);

    _tts.setCompletionHandler(() async {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 100));
      
      setState(() => _isAvatarsFlyingToGrid = true);
      await _flyAvatarsToGrid();
      setState(() {
        _isAvatarsFlyingToGrid = false;
        _showAvatarsInTopBar = false; // Hide permanently for this question
      });
      
      _gridController.forward();
      _timerController.forward();
    });
  }

  // â”€â”€ Answer â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _onPatientSelected(int index) async {
    if (_phase != 'question') return;
    _timerController.stop();
    _tts.stop();

    final isCorrect = index == _currentQuestion.correctPatientIndex;

    if (isCorrect) {
      setState(() {
        _score += 500;
        _correctAnswersCount++;
        // If answered within 5 seconds (5/20 = 0.25)
        if (_timerController.value <= 0.25) {
          _speedyAnswersCount++;
        }
        _topBarColor = const Color(0xFF54CA6E);
      });
      // Animate timer back up smoothly
      _timerReturnController.forward().then((_) async {
        await Future.delayed(const Duration(milliseconds: 400));
        _nextQuestion();
      });
    } else {
      if (_lives > 0) setState(() => _lives--);
      setState(() => _topBarColor = const Color(0xFFCF594A));
      _timerReturnController.forward().then((_) async {
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          _phase = 'correction';
          _currentCorrectionPage = 0;
        });
        _correctionController.forward();
      });
    }
  }

  void _onTimerExpired() async {
    if (_phase != 'question') return;
    if (_lives > 0) setState(() => _lives--);
    setState(() => _topBarColor = const Color(0xFFCF594A));
    _timerReturnController.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _phase = 'correction';
        _currentCorrectionPage = 0;
      });
      _correctionController.forward();
    });
  }

  // â”€â”€ Pause & Game Flow â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _togglePause() async {
    if (_isPaused) {
      // Resume
      setState(() => _isPaused = false);
      if (_wasTimerRunning && _phase == 'question') {
        _timerController.forward();
      }
    } else {
      // Pause
      _wasTimerRunning = _timerController.isAnimating;
      _timerController.stop();
      _tts.pause();

      setState(() => _isPaused = true);
    }
  }

  void _restartGame() {
    _tts.stop();
    _videoController.pause();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const QuestionScreen()),
    );
  }

  void _quitGame() {
    _tts.stop();
    _videoController.pause();
    Navigator.pop(context);
  }

  // â”€â”€ Next question â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _nextQuestion() async {
    setState(() {
      _topBarColor = const Color(0xFFD9D9D9);
      _showAvatarsInTopBar = false;
      _showQuestionText = false;
      _currentCorrectionPage = 0;
    });

    if (_currentQuestionIndex < patientQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _currentPatientIndex = 0;
        _readPatients.clear();
        _phase = 'reading';
      });
      _timerController.reset();
      _timerReturnController.reset();
      _gridController.reset();
      _correctionController.reset();
      _questionTextController.reset();
      _patientZoomController.reset();
      await Future.delayed(const Duration(milliseconds: 300));
      _introduceNextPatient();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: _score,
            correctAnswers: _correctAnswersCount,
            speedyAnswers: _speedyAnswersCount,
            totalQuestions: patientQuestions.length,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _topBarController.dispose();
    _timerController.dispose();
    _timerReturnController.dispose();
    _videoController.dispose();
    _patientZoomController.dispose();
    _questionTextController.dispose();
    _gridController.dispose();
    _correctionController.dispose();
    _flyingAvatarEntry?.remove();
    _tts.stop();
    super.dispose();
  }

  // â”€â”€ Build â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  @override
  Widget build(BuildContext context) {
    final question = _currentQuestion;
    final currentPatient =
        _phase == 'reading' && _currentPatientIndex < question.patients.length
        ? question.patients[_currentPatientIndex]
        : null;
    final correctPatient = question.patients[question.correctPatientIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // â”€â”€ Unified Top Bar & Timer background â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          AnimatedBuilder(
            animation: Listenable.merge([
              _topBarController,
              _timerController,
              _timerReturnController,
            ]),
            builder: (context, child) {
              final double currentTimerFill =
                  _timerReturnController.isAnimating || _timerReturnController.isCompleted
                  ? _timerReturnAnimation.value * _timerController.value
                  : _timerController.value;

              final topPadding = MediaQuery.of(context).padding.top;
              final heightEstimated = 136.h + topPadding;
              final restingHeight =
                  _topBarHeight > 0 ? _topBarHeight + topPadding : heightEstimated;

              double currentHeight = restingHeight * _topBarController.value;

              if (_phase == 'question' ||
                  _timerReturnController.isAnimating ||
                  _timerReturnController.isCompleted) {
                double remainingHeight =
                    MediaQuery.of(context).size.height - restingHeight;
                currentHeight += remainingHeight * currentTimerFill;
              }

              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: currentHeight,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  color: _topBarColor,
                ),
              );
            },
          ),

          SafeArea(
            child: Column(
              children: [
                // â”€â”€ Top bar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                SizeTransition(
                  sizeFactor: _topBarSize,
                  axisAlignment: -1.0,
                  child: _buildTopBar(question),
                ),

                // â”€â”€ Body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                Expanded(
                  child: _phase == 'reading' || _showQuestionText
                      ? _buildReadingPhase(currentPatient)
                      : _buildQuestionPhase(question),
                ),
              ],
            ),
          ),

          // â”€â”€ Correction overlay â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
          // NOTE: Positioned.fill must be a direct Stack child â€” NOT inside
          // SlideTransition â€” or it collapses to zero size in release/AOT mode.
          if (_phase == 'correction')
            Positioned.fill(
              child: SlideTransition(
                position: _correctionSlide,
                child: _buildCorrectionOverlay(correctPatient, question),
              ),
            ),

          // Pause Overlay
          _buildPauseOverlay(),
        ],
      ),
    );
  }

  // Top bar  
  Widget _buildTopBar(PatientQuestion question) {
    return Container(
      key: _topBarKey,
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: _togglePause,
                    child: Icon(
                      Icons.pause_outlined,
                      size: 18.sp,
                      color: _topBarContentColor,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '$_score',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: _isAnswered ? Colors.white : const Color(0xff83828866),
                    ),
                  ),
                ],
              ),
              Row(
                children: List.generate(4, (i) {
                  return Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Opacity(
                      opacity: i >= (4 - _lives) ? 1.0 : 0.25,
                      child: ColorFiltered(
                        colorFilter: _isAnswered
                            ? const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn)
                            : const ColorFilter.mode(
                                Colors.transparent, BlendMode.dst),
                        child: Image.asset(
                          'assets/images/bunny.png',
                          height: 22.h,
                          width: 17.44.w,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.cruelty_free,
                            size: 22.sp,
                            color: _topBarContentColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Avatar slots â€” always rendered for GlobalKey tracking
          SizedBox(
            height: 50.h,
            child: Row(
              children: List.generate(4, (i) {
                final patient = i < question.patients.length
                    ? question.patients[i]
                    : null;
                final isRead = i < _readPatients.length;
                return Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: Opacity(
                    // Show in top bar during reading, and during question read (before flying to grid)
                    opacity: isRead && !_isAvatarsFlyingToGrid && (_phase == 'reading' || _showAvatarsInTopBar) ? 1.0 : 0.0,
                    child: patient != null
                        ? CircleAvatar(
                            key: _topBarAvatarKeys[i],
                            radius: 22.4.r,
                            backgroundColor: const Color(0xFFADADAC),
                            backgroundImage: AssetImage(patient.imagePath),
                          )
                        : SizedBox(
                            key: _topBarAvatarKeys[i],
                            width: 40.r,
                            height: 40.r,
                          ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // â”€â”€ Reading phase â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildReadingPhase(Patient? currentPatient) {
    return Column(
      children: [
        Expanded(
          child: _showQuestionText
              ? _buildQuestionTextOnly()
              : currentPatient != null
              ? _buildPatientCard(currentPatient)
              : const SizedBox(),
        ),
        // Wave only during reading
        _buildWave(),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildPatientCard(Patient patient) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ScaleTransition(
          scale: _patientScale,
          child: FadeTransition(
            opacity: _patientOpacity,
            child: Opacity(
              opacity: _isAvatarFlyingToTopBar ? 0.0 : 1.0,
              child: CircleAvatar(
                key: _centerAvatarKey,
                radius: 108.r,
                backgroundColor: const Color(0xFFE8E8E8),
                backgroundImage: AssetImage(patient.imagePath),
              ),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Text(
            patient.name,
            key: ValueKey(patient.name),
            style: TextStyle(
              fontSize: 33.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF766784),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Column(
            key: ValueKey(patient.name + 'presc'),
            children: patient.prescriptions
                .map(
                  (p) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      p,
                      style: TextStyle(
                        fontSize: 21.sp,
                        color: const Color(0xFF766784),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionTextOnly() {
    return FadeTransition(
      opacity: _questionTextOpacity,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            _currentQuestion.question,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF766784),
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  // â”€â”€ Question phase â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildQuestionPhase(PatientQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question pinned right below top bar
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
          child: Text(
            question.question,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF766784),
              height: 1.4,
            ),
          ),
        ),
        const Spacer(),
        // 2x2 grid fades in after avatars fly in
        FadeTransition(
          opacity: _gridOpacity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.85,
              children: List.generate(question.patients.length, (i) {
                final patient = question.patients[i];
                return GestureDetector(
                  onTap: () => _onPatientSelected(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        key: _gridAvatarKeys[i],
                        radius: 80.r,
                        backgroundColor: const Color(0xFFDDDAD1),
                        backgroundImage: AssetImage(patient.imagePath),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        patient.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF766784),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        const Spacer(),
        Center(
          child: GestureDetector(
            onTap: () {
              _tts.stop();
              _timerController.stop();
              setState(() {
                _phase = 'reading';
                _currentPatientIndex = 0;
                _readPatients.clear();
                _showQuestionText = false;
                _showAvatarsInTopBar = false;
                _timerController.reset();
                _timerReturnController.reset();
                _gridController.reset();
              });
              _introduceNextPatient();
            },
            child: Text(
              'RETURN TO PROFILES',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9E9E9E),
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
        SizedBox(height: 30.h),
      ],
    );
  }

  // â”€â”€ Correction overlay â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildCorrectionOverlay(
    Patient correctPatient,
    PatientQuestion question,
  ) {
    final otherPatients = question.patients
        .where((p) => p != correctPatient)
        .toList();

    return Container(
      color: const Color(0xFFF0F0F0),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
                child: Column(
                  children: [
                    // â”€â”€ Correct patient card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 40.r,
                                backgroundImage: AssetImage(
                                  correctPatient.imagePath,
                                ),
                                backgroundColor: const Color(0xFFE8E8E8),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: correctPatient.prescriptions
                                      .map(
                                        (p) => Padding(
                                          padding: EdgeInsets.only(bottom: 4.h),
                                          child: Text(
                                            p,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: const Color(0xFF6B5B7B),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            correctPatient.name,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4CAF50),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            question.explanation,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              color: const Color(0xFF4A4A4A),
                              height: 1.7,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            question.explanation1,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              color: const Color(0xFF4A4A4A),
                              height: 1.7,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            question.explanation2,
                            style: TextStyle(
                              fontSize: 13.5.sp,
                              color: const Color(0xFF4A4A4A),
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    // â”€â”€ Other patients carousel â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    SizedBox(
                      height: 240.h,
                      child: PageView.builder(
                        itemCount: otherPatients.length,
                        controller: PageController(viewportFraction: 0.65),
                        padEnds: false,
                        onPageChanged: (int page) {
                          setState(() => _currentCorrectionPage = page);
                        },
                        itemBuilder: (context, i) {
                          final p = otherPatients[i];
                          return Container(
                            margin: EdgeInsets.only(right: 20.w),
                            padding: EdgeInsets.all(13.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40.r,
                                  backgroundImage: AssetImage(p.imagePath),
                                  backgroundColor: const Color(0xFFE8E8E8),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  p.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF6B5B7B),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                ...p.prescriptions.map(
                                  (presc) => Text(
                                    presc,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF9E9E9E),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // â”€â”€ Carousel notch indicator â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(otherPatients.length, (index) {
                        final isActive = index == _currentCorrectionPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          height: 4.h,
                          width: isActive ? 40.w : 16.w,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF6B5B7B)
                                : const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            // â”€â”€ Continue button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
              child: GestureDetector(
                onTap: _nextQuestion,
                child: Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6B5B7B),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // â”€â”€ Wave â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildWave() {
    return SizedBox(
      height: 158.h,
      width: double.infinity,
      child: _videoController.value.isInitialized
          ? VideoPlayer(_videoController)
          : const SizedBox(),
    );
  }

  // â”€â”€ Pause Overlay â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildPauseOverlay() {
    if (!_isPaused) return const SizedBox.shrink();

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 47.8, sigmaY: 47.8),
            child: Container(
              color: const Color(0x33000000),
            ),
          ),
        ),
        SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 20.h,
                right: 20.w,
                child: IconButton(
                  icon: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _isMuted = !_isMuted;
                      _tts.setVolume(_isMuted ? 0.0 : 1.0);
                    });
                  },
                ),
              ),
              Center(
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
              Positioned(
                bottom: 50.h,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PatientChartInstructionsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Game Instructions',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
          backgroundColor: const Color(0xFF7A6A87),
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
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
