import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'guest_code_screen.dart';
import '../dashboard_screen.dart';

class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

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
              Color(0xFF003395),
              Color(0xFF003395), // Stay blue longer
              Colors.white,
            ],
            stops: [0.0, 0.6, 1.0], // Blue until 60%, then transition to white
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Button (Matching Verification Screen)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 44.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2), // Glassy back button
                          borderRadius: BorderRadius.circular(17.r),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Icon(Icons.chevron_left, color: Colors.white, size: 28.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),
                  
                  // Title
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.roboto(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      children: [
                        const TextSpan(text: 'Unlock to access full features\nfor '),
                        TextSpan(
                          text: '\$299.99',
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const TextSpan(text: ' \$179.39'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  
                  // Subtitle
                  Text(
                    'The PEBC exam pack is currently\nin BETA. Only invited guests can unlock.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  
                  // Glassmorphism Features Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Column(
                          children: [
                            _buildFeatureItem('4+ Engaging Cognitive Games'),
                            _buildFeatureDivider(),
                            _buildFeatureItem('1000+ Question Bank & Drills'),
                            _buildFeatureDivider(),
                            _buildFeatureItem('Stay Sharp With Puzzles'),
                            _buildFeatureDivider(),
                            _buildFeatureItem('Understand your strengths'),
                            _buildFeatureDivider(),
                            _buildFeatureItem('Learn All Exam Tricks & Strategies'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 60.h),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GuestCodeScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF469EFF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Enter Guest Code',
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Footer Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don’t have one? ',
                        style: GoogleFonts.roboto(
                          color: const Color(0xFF7D7D7D),
                          fontSize: 14.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Learn more about our beta test',
                          style: GoogleFonts.roboto(
                            color: const Color(0xFF469EFF),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.check_rounded, color: const Color(0xFF00FF00), size: 24.sp),
        ],
      ),
    );
  }

  Widget _buildFeatureDivider() {
    return Divider(
      color: Colors.white.withOpacity(0.1),
      height: 1,
    );
  }
}
