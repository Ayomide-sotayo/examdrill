import 'dart:math' as math;
import 'package:examdril/models/bns_question_model.dart';
import 'package:examdril/screens/best_next_step/bns_feedback_screen.dart';
import 'package:examdril/screens/best_next_step/bns_option_card.dart';
import 'package:examdril/screens/best_next_step/bns_pregame_screen.dart';
import 'package:examdril/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BnsStatsScreen extends StatelessWidget {
  final int score;
  final int perfectRounds;
  final int totalQuestions;
  final List<BnsQuestionResult> results;
  final BnsTheme theme;

  const BnsStatsScreen({
    super.key,
    required this.score,
    required this.perfectRounds,
    required this.totalQuestions,
    required this.results,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    const kLightBg = Color(0xFFE8EDF2);
    const kCardColor = Color(0xFF2C3947);
    const kButtonColor = Color(0xFF547A95);

    return Scaffold(
      backgroundColor: kLightBg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3947)),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 140.h),
                    child: Column(
                      children: [
                        _buildTopCard(kCardColor),
                        SizedBox(height: 12.h),
                        _buildProficiencyCard(kCardColor),
                        SizedBox(height: 12.h),
                        _buildDifficultyCard(kCardColor),
                        SizedBox(height: 12.h),
                        _buildAccuracyCard(kCardColor),
                        SizedBox(height: 12.h),
                        _buildContentReportCard(kCardColor, context),
                        SizedBox(height: 12.h),
                        _buildFeedbackCard(kCardColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Sticky Action Buttons (Truly transparent area)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 24.h),
                color: Colors.transparent,
                child: _buildActionButtons(context, kButtonColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get _labelStyle => TextStyle(
        fontSize: 10.sp,
        color: Colors.white.withOpacity(0.6),
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      );

  Widget _buildCard({
    required Widget child,
    required Color color,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: child,
    );
  }

  Widget _buildTopCard(Color color) {
    return _buildCard(
      color: color,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    color: Colors.white,
                    child: Center(
                      child: Icon(Icons.directions_run_rounded, color: color),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Best Next Step',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'HIGH SCORE: $score',
                      style: _labelStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 60.h,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(score: score),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProficiencyCard(Color color) {
    return _buildCard(
      color: color,
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('PROFICIENCY QUOTIENT', style: _labelStyle),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.help, color: Colors.white, size: 16),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text('S',
                      style: TextStyle(color: Colors.white, fontSize: 20.sp)),
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best Next Step EPQ earned',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'PROFICIENCY LEVEL INTERMEDIATE',
                    style: _labelStyle,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyCard(Color color) {
    return _buildCard(
      color: color,
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('BEST NEXT STEP DIFFICULTY', style: _labelStyle),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.help, size: 16, color: Colors.white),
              )
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildNumberedStat('Current', '10'),
              Expanded(
                child: SizedBox(
                  height: 60.h,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CustomPaint(
                        size: Size(120.w, 60.h),
                        painter: _GaugePainter(),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '+1',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              _buildNumberedStat('Next Up', '11'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: _labelStyle),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 36.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildAccuracyCard(Color color) {
    final accuracyPercent =
        (perfectRounds / math.max(1, totalQuestions) * 100).round();
    return _buildCard(
      color: color,
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('ACCURACY', style: _labelStyle),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.help, size: 16, color: Colors.white),
              )
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            '$accuracyPercent% of answers correct',
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalQuestions, (i) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < perfectRounds
                      ? const Color(0xFF54CA6E)
                      : const Color(0xFFCF594A),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildContentReportCard(Color color, BuildContext context) {
    return _buildCard(
      color: color,
      child: Column(
        children: [
          Text('CONTENT REPORT', style: _labelStyle),
          SizedBox(height: 20.h),
          ...results.take(2).map((res) => _buildReportItem(res)),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BnsFeedbackScreen(results: results),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r)),
              ),
              child: const Text('See More',
                  style: TextStyle(color: Colors.white70)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportItem(BnsQuestionResult res) {
    final isCorrect = res.isPerfect;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              isCorrect ? Icons.check : Icons.close,
              color: isCorrect ? const Color(0xFF54CA6E) : const Color(0xFFCF594A),
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              isCorrect ? 'Correct' : 'Incorrect',
              style: TextStyle(
                color: isCorrect ? const Color(0xFF54CA6E) : const Color(0xFFCF594A),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          res.question.scenario,
          style: TextStyle(color: Colors.white, fontSize: 13.sp, height: 1.4),
        ),
        SizedBox(height: 16.h),
        // Visualization row
        SizedBox(
          height: 100.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final optIdx = res.slotAssignment[i];
              final state = res.finalStates[i];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: BnsOptionCard(
                    text: res.question.options[optIdx],
                    state: state,
                    themeCardColor: const Color(0xFF2C3947),
                  ),
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Divider(color: Colors.white.withOpacity(0.1)),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(Color color) {
    return _buildCard(
      color: color,
      child: Column(
        children: [
          Text('FEEDBACK', style: _labelStyle),
          SizedBox(height: 16.h),
          Text(
            'Did you find this game helpful ?',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildOutlineButton('No'),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildOutlineButton('Yes'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Color buttonColor) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const BnsPreGameScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              minimumSize: Size(0, 56.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
            child: const Text('Play Again',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              minimumSize: Size(0, 56.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r)),
            ),
            child:
                const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final int score;
  _LineChartPainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.3, size.height * 0.8),
      Offset(size.width * 0.45, size.height * 0.4),
      Offset(size.width * 0.65, size.height * 0.2),
      Offset(size.width * 0.85, size.height * 0.2),
    ];

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    for (int i = 1; i < points.length; i++) {
      canvas.drawCircle(points[i], 3.5.r, dotPaint);
      canvas.drawCircle(points[i], 2.r, Paint()..color = Colors.black26);
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: '$score\n',
        style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            height: 1.2,
            fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: 'HIGH SCORE',
              style: TextStyle(
                  color: Colors.white54,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold))
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(canvas,
        Offset(size.width - textPainter.width - 10.w, size.height * 0.5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 24.w;
    final rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height),
        radius: size.width / 2 - strokeWidth / 2);

    final paintLightBlue = Paint()
      ..color = const Color(0xFF00A2FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final paintDarkBlue = Paint()
      ..color = const Color(0xFF3B4870)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final paintRed = Paint()
      ..color = const Color(0xFFE45555)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, math.pi, math.pi * 0.35, false, paintLightBlue);
    canvas.drawArc(rect, math.pi * 1.35, math.pi * 0.45, false, paintDarkBlue);
    canvas.drawArc(rect, math.pi * 1.80, math.pi * 0.20, false, paintRed);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
