import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'paywall_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String? _selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 48.w,
                          height: 37.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(9999.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6.9,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.black,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      // Course Icon in a Circle
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/course.png',
                            width: 50.w,
                            height: 50.w,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.book_rounded,
                              size: 50.sp,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      // Title
                      Text(
                        'Start your learning journey',
                        style: GoogleFonts.roboto(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Subtitle
                      Text(
                        'Choose a course that fits your goals and begin your first step today',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          color: const Color(0xFF7D7D7D),
                        ),
                      ),
                      SizedBox(height: 48.h),
                      
                      // PEBC Option
                      _buildCourseOption(
                        title: 'PEBC',
                        imagePath: 'assets/images/pebc.png',
                        isLocked: false,
                        isSelected: _selectedCourse == 'PEBC',
                        onTap: () {
                          setState(() {
                            _selectedCourse = 'PEBC';
                          });
                        },
                      ),
                      SizedBox(height: 16.h),
                      
                      // OSCE Option
                      _buildCourseOption(
                        title: 'OSCE',
                        imagePath: 'assets/images/osce.png',
                        isLocked: true,
                        isSelected: false,
                      ),
                      SizedBox(height: 16.h),
                      
                      // NAPLEX Option
                      _buildCourseOption(
                        title: 'NAPLEX',
                        imagePath: 'assets/images/naplex.png',
                        isLocked: true,
                        isSelected: false,
                      ),
                      
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ),
            // Proceed Button pinned to bottom (Matching SignInScreen style)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Center(
                child: Container(
                  width: 337.w,
                  height: 49.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _selectedCourse != null
                          ? [const Color(0xFFFF5B40), const Color(0xFFFF4172)]
                          : [
                                const Color(0xFFFF5B40).withOpacity(0.5),
                                const Color(0xFFFF4172).withOpacity(0.5)
                              ],
                    ),
                    borderRadius: BorderRadius.circular(9999.r),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.1),
                      width: 0.7,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _selectedCourse != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaywallScreen()),
                          );
                        }
                      : null,
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
                      'Proceed',
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseOption({
    required String title,
    required String imagePath,
    required bool isLocked,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return Center(
      child: GestureDetector(
        onTap: isLocked ? null : onTap,
        child: Container(
          width: 337.w,
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isLocked ? const Color(0xFFEEEEEE).withOpacity(0.6) : Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isSelected ? const Color(0xFFFF5B40) : const Color(0xFFE0E0E0),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Logo inside a circle
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF0F0F0)),
                    ),
                    child: Center(
                      child: Image.asset(imagePath, width: 24.w, fit: BoxFit.contain),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Title
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isLocked ? const Color(0xFF8C8C8C) : Colors.black,
                    ),
                  ),
                ],
              ),
              // Indicator
              if (isLocked)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Coming Soon',
                        style: GoogleFonts.roboto(
                          fontSize: 11.sp,
                          color: const Color(0xFFFF5B40),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.lock, color: const Color(0xFFFF5B40), size: 12.sp),
                    ],
                  ),
                )
              else
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFFFF5B40) : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFF5B40) : const Color(0xFFDCDCDC),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected 
                      ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                      : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
