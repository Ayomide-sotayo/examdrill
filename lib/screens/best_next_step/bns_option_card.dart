import 'package:examdril/models/bns_question_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────
//  CARD WIDGET
// ─────────────────────────────────────────────
class BnsOptionCard extends StatelessWidget {
  final String text;
  final BnsCardState state;
  final Color themeCardColor;
  final int colorIndex;

  static const _correctBg = Color(0xFF4DB89A);
  static const _wrongBg = Color(0xFF4A2B29);
  static const _correctionFg = Color(0xFF0A2A22);

  static const List<Color> _normalBarColors = [
    Color(0xFFEFA59C), // Salmon
    Color(0xFF89B3E6), // Soft Blue
    Color(0xFFF1D483), // Soft Yellow
    Color(0xFF98D1A3), // Soft Green
    Color(0xFFD6A3D4), // Soft Purple
  ];

  const BnsOptionCard({
    super.key,
    required this.text,
    required this.state,
    required this.themeCardColor,
    required this.colorIndex,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color faceColor;
    final Color textColor;
    final Color barColor;

    switch (state) {
      case BnsCardState.normal:
        bgColor = themeCardColor;
        faceColor = Colors.white;
        textColor = Colors.white;
        barColor = _normalBarColors[colorIndex % _normalBarColors.length];
      case BnsCardState.correct:
        bgColor = _correctBg;
        faceColor = Colors.white;
        textColor = Colors.white;
        barColor = Colors.white;
      case BnsCardState.wrong:
        bgColor = _wrongBg;
        faceColor = Colors.white;
        textColor = Colors.white;
        barColor = Colors.white; // White on correct and wrong
      case BnsCardState.correction:
        bgColor = Colors.white;
        faceColor = _correctionFg;
        textColor = _correctionFg;
        barColor = _correctionFg; // Green on correction
    }

    // FIX: replaced Column with Spacer() (which caused RenderFlex overflow
    // on long option text) with a Column that uses:
    //   - fixed face area at top
    //   - Expanded + scrollable text in the middle (so long text never overflows)
    //   - fixed bottom bar
    // The card itself is sized by its parent slot (Expanded), so it always fills
    // the available height without needing a Spacer.
    return AnimatedContainer(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      width: 105.w,
      height: 170.h,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          // ── Face ──────────────────────────────
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                key: ValueKey(state),
                width: 70.w,
                height: 40.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Eyes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 5.w,
                          height: 5.w,
                          decoration: BoxDecoration(
                            color: faceColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 18.w),
                        Container(
                          width: 5.w,
                          height: 5.w,
                          decoration: BoxDecoration(
                            color: faceColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    // Mouth
                    state == BnsCardState.wrong
                        ? Transform.rotate(
                            angle: 3.14159, // 180 degrees
                            child: Image.asset(
                              'assets/images/mouth_curve.png',
                              color: faceColor,
                              width: 38.w,
                              fit: BoxFit.contain,
                            ),
                          )
                        : state == BnsCardState.correct ||
                              state == BnsCardState.correction
                        ? Image.asset(
                            'assets/images/mouth_curve.png',
                            color: faceColor,
                            width: 38.w,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            'assets/images/mouth_straight.png',
                            color: faceColor,
                            width: 38.w,
                            fit: BoxFit.contain,
                          ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 7.h),

          // ── Option text — Expanded so it fills remaining space ────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 450),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: textColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  letterSpacing: 0,
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                ),
              ),
            ),
          ),

          SizedBox(height: 6.h),

          // ── Bottom bar ────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            margin: EdgeInsets.symmetric(
              horizontal: 10.w,
            ).copyWith(bottom: 8.h),
            height: 2.5.h,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ],
      ),
    );
  }
}
