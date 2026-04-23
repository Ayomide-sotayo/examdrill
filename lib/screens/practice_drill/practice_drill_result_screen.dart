import 'package:examdril/data/practice_drill_question_data.dart';
import 'package:examdril/screens/practice_drill/pregame_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


const _kBlack = Color(0xFF0A0A0A);
const _kGreen = Color(0xFF1DB974);
const _kRed = Color(0xFFE53935);
const _kCardBg = Color(0xFF141414);
const _kCardBorder = Color(0xFF2A2A2A);
const _kWhite = Colors.white;

class PracticeDrillResultScreen extends StatelessWidget {
  final List<bool> results;
  final int score;

  const PracticeDrillResultScreen({
    super.key,
    required this.results,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final int total = practiceDrillQuestions.length;
    final int correct = results.where((r) => r).length;
    final int wrong = results.where((r) => !r).length;
    final double accuracy = total > 0 ? correct / total : 0.0;
    final double difficulty = total > 0 ? wrong / total : 0.0;

    // personal best mock — in a real app read from local storage
    final bool isNewBest = score > 0;

    return Scaffold(
      backgroundColor: _kBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              SizedBox(height: 35.h),

              // ── medal ─────────────────────────
              _MedalWidget(isNewBest: isNewBest),
              SizedBox(height: 12.h),

              // ── new best label ─────────────────
              if (isNewBest)
                Text(
                  'New Best',
                  style: TextStyle(
                    color: _kWhite.withOpacity(0.7),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              SizedBox(height: 4.h),

              // ── score ──────────────────────────
              Text(
                '$score',
                style: TextStyle(
                  color: _kWhite,
                  fontSize: 52.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              SizedBox(height: 28.h),

              // ── stat cards ─────────────────────
              Row(
                children: [
                  _StatCard(
                    label: 'Total\nQuestions',
                    value: '$total',
                    icon: null,
                  ),
                  SizedBox(width: 10.w),
                  _StatCard(
                    label: 'Correct',
                    value: '$correct',
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: _kWhite,
                  ),
                  SizedBox(width: 10.w),
                  _StatCard(
                    label: 'Wrong',
                    value: '$wrong',
                    icon: Icons.cancel_outlined,
                    iconColor: _kWhite,
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ── score accuracy bar ─────────────
              _ProgressCard(
                label: 'Score accuracy',
                value: '${(accuracy * 100).toStringAsFixed(0)}%',
                progress: accuracy,
              ),
              SizedBox(height: 12.h),

              // ── difficulty bar ─────────────────
              _ProgressCard(
                label: 'Difficulty Level',
                value:
                    '${wrong.toString().padLeft(2, '0')}/${total.toString().padLeft(2, '0')}',
                progress: difficulty,
              ),
              SizedBox(height: 36.h),

              // ── buttons ────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Play Again',
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PreGameScreen(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: _ActionButton(
                      label: 'Done',
                      onTap: () => Navigator.of(context).popUntil(
                        (route) => route.isFirst,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  MEDAL
// ─────────────────────────────────────────────
class _MedalWidget extends StatelessWidget {
  final bool isNewBest;
  const _MedalWidget({required this.isNewBest});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.r,
      height: 110.r,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.military_tech_rounded,
          size: 64.sp,
          color: _kBlack,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  STAT CARD
// ─────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: _kCardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: _kWhite),
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _kWhite.withOpacity(0.6),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            SizedBox(height: 10.h),
            if (icon != null)
              Icon(icon, color: iconColor, size: 22.sp),
            if (icon != null) SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                color: _kWhite,
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  PROGRESS CARD
// ─────────────────────────────────────────────
class _ProgressCard extends StatelessWidget {
  final String label;
  final String value;
  final double progress;

  const _ProgressCard({
    required this.label,
    required this.value,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _kWhite),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: _kWhite,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                width: 18.r,
                height: 18.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white12,
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: TextStyle(
                        color: _kWhite, fontSize: 10.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: _kWhite,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: progress.clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOut,
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                minHeight: 8.h,
                backgroundColor: Colors.white12,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  ACTION BUTTON
// ─────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: _kBlack,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

