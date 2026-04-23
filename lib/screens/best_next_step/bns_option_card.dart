import 'package:examdril/models/bns_question_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─────────────────────────────────────────────
//  FACE PAINTER
// ─────────────────────────────────────────────
class _FacePainter extends CustomPainter {
  final BnsCardState state;
  final Color color;

  _FacePainter({required this.state, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    const eyeRadius = 3.0;
    final eyeY = size.height * 0.22;
    final eyeOffset = size.width * 0.19;

    canvas.drawCircle(Offset(cx - eyeOffset, eyeY), eyeRadius, fillPaint);
    canvas.drawCircle(Offset(cx + eyeOffset, eyeY), eyeRadius, fillPaint);

    final mL = cx - eyeOffset * 1.5;
    final mR = cx + eyeOffset * 1.5;
    final mY = size.height * 0.65;
    final path = Path();

    if (state == BnsCardState.correct || state == BnsCardState.correction) {
      path.moveTo(mL, mY - size.height * 0.05);
      path.quadraticBezierTo(cx, mY + size.height * 0.18, mR, mY - size.height * 0.05);
    } else if (state == BnsCardState.wrong) {
      path.moveTo(mL, mY + size.height * 0.05);
      path.quadraticBezierTo(cx, mY - size.height * 0.18, mR, mY + size.height * 0.05);
    } else {
      path.moveTo(mL, mY);
      path.lineTo(mR, mY);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(_FacePainter old) =>
      old.state != state || old.color != color;
}

// ─────────────────────────────────────────────
//  CARD WIDGET
// ─────────────────────────────────────────────
class BnsOptionCard extends StatelessWidget {
  final String text;
  final BnsCardState state;
  final Color themeCardColor;

  static const _correctBg = Color(0xFF4DB89A);
  static const _wrongBg = Color(0xFF5C2020);
  static const _correctionFg = Color(0xFF1A3D2B);
  static const _redBar = Color(0xFFE53935);

  const BnsOptionCard({
    super.key,
    required this.text,
    required this.state,
    required this.themeCardColor,
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
        barColor = Colors.white;
      case BnsCardState.correct:
        bgColor = _correctBg;
        faceColor = Colors.white;
        textColor = Colors.white;
        barColor = Colors.white;
      case BnsCardState.wrong:
        bgColor = _wrongBg;
        faceColor = Colors.white;
        textColor = Colors.white;
        barColor = _redBar;
      case BnsCardState.correction:
        bgColor = Colors.white;
        faceColor = _correctionFg;
        textColor = _correctionFg;
        barColor = _correctionFg;
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
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),

          // ── Face ──────────────────────────────
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                key: ValueKey(state),
                width: 60.w,
                height: 36.h,
                child: CustomPaint(
                  painter: _FacePainter(state: state, color: faceColor),
                ),
              ),
            ),
          ),

          SizedBox(height: 10.h),

          // ── Option text — Expanded so it fills remaining space ────────
          // FIX: Expanded here replaces the old Spacer at the bottom.
          // Text can grow to fill the card height; it will never overflow
          // because it's clipped by the parent's bounded height.
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 450),
                style: TextStyle(
                  color: textColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
                child: Text(
                  text,
                  // overflow ellipsis as a last resort safety net
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ),
            ),
          ),

          SizedBox(height: 6.h),

          // ── Bottom bar ────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            margin: EdgeInsets.symmetric(horizontal: 10.w).copyWith(bottom: 8.h),
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