import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'stats_screen.dart';
import 'feedback_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int correctAnswers;
  final int speedyAnswers;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.score,
    required this.correctAnswers,
    required this.speedyAnswers,
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
              // Top Bar with Heart
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const _FavoriteButton(),
                  ],
                ),
              ),
              
              SizedBox(height: 20.h),

              // Score Card
              Container(
                width: 232.w,
                padding: EdgeInsets.symmetric(vertical: 35.h),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/score.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(40.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
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
                          color: const Color(0xFF6B5B7B).withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '$score',
                        style: TextStyle(
                          fontSize: 72.sp,
                          color: const Color(0xFF6B5B7B),
                          fontWeight: FontWeight.bold,
                          letterSpacing: -2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Patient Chart',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: const Color(0xFF6B5B7B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 60.h),

              // Stats
              Column(
                children: [
                  Text(
                    'Speedy Answers: $speedyAnswers',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Correct Answers: $correctAnswers',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Divider
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Divider(
                  color: Colors.white.withOpacity(0.2),
                  thickness: 1,
                ),
              ),

              SizedBox(height: 30.h),

              // XP Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/xp.png',
                      height: 24.h,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'XP Earned: ${correctAnswers.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Buttons
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
                            builder: (_) => const FeedbackScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 56.h),
                        side: const BorderSide(color: Colors.white, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'Feedback',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // Continue Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StatsScreen(
                              score: score,
                              correctAnswers: correctAnswers,
                              totalQuestions: totalQuestions,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF261D2C),
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
      ),
    );
  }
}

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
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: Icon(
          _isFavorited ? Icons.favorite : Icons.favorite_border,
          key: ValueKey<bool>(_isFavorited),
          color: _isFavorited ? const Color.fromARGB(255, 255, 255, 255) : Colors.white,
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
