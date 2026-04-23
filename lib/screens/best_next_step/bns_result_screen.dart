import 'package:examdril/models/bns_question_model.dart';
import 'package:examdril/screens/best_next_step/bns_feedback_screen.dart';
import 'package:examdril/screens/best_next_step/bns_pregame_screen.dart';
import 'package:examdril/screens/best_next_step/bns_stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BnsResultScreen extends StatelessWidget {
  final int score;
  final int correctAnswers;
  final int speedyAnswers;
  final int totalQuestions;
  final List<BnsQuestionResult> results;
  final BnsTheme theme;

  const BnsResultScreen({
    super.key,
    required this.score,
    required this.correctAnswers,
    required this.speedyAnswers,
    required this.totalQuestions,
    required this.results,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    // ── CONSTANTS FROM NEW DESIGN ──────────────
    const _kBgColor = Color(0xFFE8EDF2);
    const _kDarkBlue = Color(0xFF2C3947);

    return Scaffold(
      backgroundColor: _kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Heart
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [const _FavoriteButton()],
              ),
            ),

            SizedBox(height: 20.h),

            // ── SCORE CARD ────────────────────────
            Container(
              width: 232.w,
              padding: EdgeInsets.symmetric(vertical: 35.h),
              decoration: BoxDecoration(
                color: _kDarkBlue,
                borderRadius: BorderRadius.circular(40.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Good Score',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '$score',
                      style: TextStyle(
                        fontSize: 72.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -2,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Best Next Step',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 50.h),

            // ── STATS TEXT ────────────────────────
            Column(
              children: [
                Text(
                  'Speedy Answers: $speedyAnswers',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: _kDarkBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Correct Answers: $correctAnswers',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: _kDarkBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // ── XP PILL ───────────────────────────
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: _kDarkBlue.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/xp.png',
                    height: 24.h,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.star_rounded,
                      color: Colors.blueAccent,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'XP Earned: ${correctAnswers.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: _kDarkBlue.withValues(alpha: 0.8),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            // ── BUTTONS ───────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  // Feedback Button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BnsFeedbackScreen(results: results),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 56.h),
                      side: const BorderSide(color: _kDarkBlue, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Feedback',
                      style: TextStyle(
                        color: _kDarkBlue,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Continue Button (Now goes to Stats/Continue screen)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BnsStatsScreen(
                            score: score,
                            perfectRounds: correctAnswers,
                            totalQuestions: totalQuestions,
                            results: results,
                            theme: theme,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kDarkBlue,
                      minimumSize: Size(double.infinity, 56.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FAVOURITE BUTTON
// ─────────────────────────────────────────────
class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton();

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          _isFavorited ? Icons.favorite : Icons.favorite_border,
          key: ValueKey<bool>(_isFavorited),
          color: _isFavorited ? Colors.redAccent : const Color(0xFF2C3947),
          size: 28.sp,
        ),
      ),
      onPressed: () {
        setState(() {
          _isFavorited = !_isFavorited;
        });
      },
    );
  }
}
