import 'package:examdril/data/question_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'theme_selection_screen.dart';
import 'dashboard_screen.dart';

class ResultScreen extends StatefulWidget {
  final List<bool> results;
  const ResultScreen({super.key, required this.results});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnimation = Tween<double>(begin: 0, end: _getScore()).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  double _getScore() {
    int correct = widget.results.where((r) => r).length;
    return correct / widget.results.length;
  }

  int _getCorrectCount() {
    return widget.results.where((r) => r).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    _buildHeader(),
                    SizedBox(height: 30.h),
                    _buildProgressCircle(),
                    SizedBox(height: 30.h),
                    _buildFeedbackSection(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 71.4.w,
          height: 71.4.h,
          child: Image.asset(
            'assets/images/congrats.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                 Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 32.sp),
          ),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Congratulations!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'New Best Score',
              style: TextStyle(color: Colors.white54, fontSize: 16.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCircle() {
    return Center(
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          final percentage = (_progressAnimation.value * 100).toInt();
          return SizedBox(
            width: 180.w,
            height: 180.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background track
                SizedBox(
                  width: 180.w,
                  height: 180.h,
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 16.w,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                // Yellow segment (wrong answers)
                SizedBox(
                  width: 180.w,
                  height: 180.h,
                  child: CircularProgressIndicator(
                    value: _progressAnimation.value,
                    strokeWidth: 16.w,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFF5A623),
                    ),
                  ),
                ),
                // Purple segment (correct answers)
                SizedBox(
                  width: 180.w,
                  height: 180.h,
                  child: CircularProgressIndicator(
                    value: _progressAnimation.value * (_getCorrectCount() / widget.results.length),
                    strokeWidth: 16.w,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF7B4FA0),
                    ),
                  ),
                ),
                // Percentage text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_getCorrectCount()}/${widget.results.length} correct',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Report Feedback',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        ...List.generate(quizQuestions.length, (i) {
          final question = quizQuestions[i];
          final correctAnswer = question.options[question.correctIndex];
          final userGotIt = i < widget.results.length ? widget.results[i] : false;
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(12.r),
              
              border: Border.all(
                color: userGotIt
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFFFFFFFF),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      userGotIt ? Icons.check_circle : Icons.cancel,
                      color: userGotIt
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFFF5252),
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Answer: $correctAnswer',
                      style: TextStyle(
                        color: userGotIt
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFFF5252),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const ThemeSelectionScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF454A87),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: Text(
                'Play Again',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF454A87),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  side: const BorderSide(color: Colors.white24),
                ),
              ),
              child: Text(
                'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}