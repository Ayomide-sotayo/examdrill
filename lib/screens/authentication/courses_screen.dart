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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44.w,
                            height: 38.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(17.r),
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(Icons.chevron_left, color: Colors.black, size: 28.sp),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      // Title
                      Text(
                        'Select a course to\nenroll in on Exam Dash',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 21.37.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Subtitle
                      Text(
                        'Choose a course that fits your goals to\nunlock your potential.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 14.65.sp,
                          color: const Color(0xFF7D7D7D),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      
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
            // Proceed Button pinned to bottom
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: SizedBox(
                width: double.infinity,
                height: 56.h,
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
                    backgroundColor: _selectedCourse != null 
                        ? const Color(0xFF469EFF) 
                        : const Color(0xFF469EFF).withOpacity(0.3),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF469EFF).withOpacity(0.3),
                    disabledForegroundColor: Colors.white.withOpacity(0.7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'Proceed',
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
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
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        width: 337.w,
        height: 70.h,
        padding: EdgeInsets.only(top: 8.h, bottom: 8.h, left: 12.w, right: 12.w),
        decoration: BoxDecoration(
          color: isLocked ? const Color(0xFFEEEEEE) : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF469EFF) : (isLocked ? Colors.transparent : const Color(0xFFE5E5E5)),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Logo inside a circle (white background)
            Container(
              width: 50.w,
              height: 50.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
            SizedBox(width: 16.w),
            // Title
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: isLocked ? const Color(0xFF8C8C8C) : const Color(0xFF5A5A5A),
                ),
              ),
            ),
            // Icon on the right
            if (isLocked)
              Container(
                width: 24.w,
                height: 24.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.lock, color: const Color(0xFFDCDCDC), size: 14.sp),
                ),
              )
            else
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFF469EFF) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF469EFF) : const Color(0xFFDCDCDC),
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
