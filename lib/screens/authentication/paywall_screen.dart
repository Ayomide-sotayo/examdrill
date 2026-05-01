import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'guest_code_screen.dart';
import '../dashboard_screen.dart';

class PaywallScreen extends StatelessWidget {
  final String resourceId;
  const PaywallScreen({super.key, required this.resourceId});

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
            colors: [Color(0xFFFF4A62), Color(0xFFF5F5F5)],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9999.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 48.w,
                            height: 37.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(9999.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.8),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.chevron_left_rounded,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),

                  // Title
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.roboto(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Unlock to access PEBC Readiness Pack\nfor ',
                        ),
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
                  SizedBox(height: 18.h),

                  // Subtitle
                  Text(
                    'Get private beta access to PEBC-style practice, readiness games and weak area insights built to help you prepare with more confidence',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 15.sp,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Glassmorphism Features Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 24.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildFeatureItem(
                              '10+ readiness games for recall speed and exam thinking',
                            ),

                            _buildFeatureItem(
                              '20,000+ PEBC style questions and Drills',
                            ),

                            _buildFeatureItem(
                              'Blueprint -aligned practice across PEBC domains',
                            ),

                            _buildFeatureItem(
                              'Weak-area insights by skill and topic',
                            ),

                            _buildFeatureItem(
                              'Explanations, hints, and wrong answer rationales',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Action Button (Teal Gradient Button)
                  Center(
                    child: Container(
                      width: 337.w,
                      height: 49.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFF5B40), Color(0xFFFF4172)],
                        ),
                        borderRadius: BorderRadius.circular(9999.r),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.1),
                          width: 0.7,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GuestCodeScreen(resourceId: resourceId),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999.r),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'Enter Guest Code',
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
                            color: const Color(0xFFFF5B40),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFFFF5B40),
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
          Icon(Icons.check_rounded, color: Colors.white, size: 24.sp),
        ],
      ),
    );
  }

  Widget _buildFeatureDivider() {
    return Divider(color: Colors.white.withOpacity(0.1), height: 1);
  }
}
