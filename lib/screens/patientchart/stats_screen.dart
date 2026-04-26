import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/patients_data.dart';

class StatsScreen extends StatelessWidget {
  final int score;
  final int correctAnswers;
  final int totalQuestions;

  const StatsScreen({
    super.key,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B7E9F),
              Color(0xFF7A6B8E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 30.h),
                  child: Column(
                    children: [
                      _buildTopCard(),
                      SizedBox(height: 12.h),
                      _buildProficiencyCard(),
                      SizedBox(height: 12.h),
                      _buildDifficultyCard(),
                      SizedBox(height: 12.h),
                      _buildAccuracyCard(),
                      SizedBox(height: 12.h),
                      _buildContentReportCard(),
                      SizedBox(height: 12.h),
                      _buildFeedbackCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _labelStyle => TextStyle(
        fontSize: 10.sp,
        color: const Color(0xFFA59AB2),
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      );

  Widget _buildCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF554A62),
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTopCard() {
    return _buildCard(
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
                      child: Image.asset(
                        'assets/images/sam.png',
                        height: 40.h,
                        errorBuilder: (_, __, ___) => const Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient Chart',
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
              painter: LineChartPainter(score: score),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProficiencyCard() {
    return _buildCard(
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('PROFICIENCY QUOTIENT', style: _labelStyle),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.help, color: Colors.white, size: 16.sp),
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
                    'Patient Chart EPQ earned',
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

  Widget _buildDifficultyCard() {
    return _buildCard(
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('PATIENT CHART DIFFICULTY', style: _labelStyle),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.help, size: 16.sp, color: Colors.white),
              )
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Text('Current', style: _labelStyle),
                  Text(
                    '10',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SizedBox(
                  height: 60.h,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CustomPaint(
                        size: Size(120.w, 60.h),
                        painter: GaugePainter(),
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
                              color: const Color(0xFF554A62),
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
              Column(
                children: [
                  Text('Next Up', style: _labelStyle),
                  Text(
                    '11',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyCard() {
    final accuracyPercent =
        (correctAnswers / math.max(1, totalQuestions) * 100).round();
    return _buildCard(
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text('ACCURACY', style: _labelStyle),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.help, size: 16.sp, color: Colors.white),
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
                  color: i < correctAnswers
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

  Widget _buildContentReportCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('CONTENT REPORT', style: _labelStyle),
          ),
          SizedBox(height: 20.h),
          // We map over patientQuestions. 
          ...List.generate(patientQuestions.length, (index) {
            final isCorrect = index < correctAnswers;
            final q = patientQuestions[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCorrect ? Icons.check : Icons.close,
                      color: isCorrect
                          ? const Color(0xFF54CA6E)
                          : const Color(0xFFCF594A),
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isCorrect ? 'Correct' : 'Incorrect',
                      style: TextStyle(
                        color: isCorrect
                            ? const Color(0xFF54CA6E)
                            : const Color(0xFFCF594A),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  q.explanation.split('.').first + '.', // First sentence
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
                if (index < patientQuestions.length - 1)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Divider(color: Colors.white.withOpacity(0.2)),
                  ),
              ],
            );
          }),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'See More',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return _buildCard(
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
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final int score;

  LineChartPainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Approximating the points based on Figma
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

    // Draw little circles at the points
    for (int i = 0; i < points.length; i++) {
      if (i > 0) { // Don't draw circle on extreme edge
        canvas.drawCircle(points[i], 3.5.r, dotPaint);
        // inner hole
        canvas.drawCircle(
            points[i], 2.r, Paint()..color = const Color(0xFF554A62));
      }
    }

    // "1500 HIGH SCORE" Text at right bottom
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$score\n',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          height: 1.2,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'HIGH SCORE',
            style: TextStyle(
              color: const Color(0xFFA59AB2),
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
        canvas, Offset(size.width - textPainter.width - 10.w, size.height * 0.5));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GaugePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 24.w;
    
    // Create rect for arc (Note: arc is drawn around the center)
    // To make it fit within size and start from bottom edge:
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height), 
      radius: size.width / 2 - strokeWidth / 2,
    );

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
