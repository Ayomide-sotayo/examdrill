import 'package:examdril/screens/patient_chart_info_screen.dart';
import 'package:examdril/screens/theme_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            SizedBox(height: 24.h),
            _buildPersonalizedGames(),
            SizedBox(height: 16.h),
            Divider(color: const Color(0x1A24292F), thickness: 1.h),
            SizedBox(height: 10.h),
            _buildRecommendedSection(),
            SizedBox(height: 16.h),
            Divider(color: const Color(0x1A24292F), thickness: 1.h),
            SizedBox(height: 10.h),
            _buildGamesSection(),
            SizedBox(height: 16.h),
            Divider(color: const Color(0x1A24292F), thickness: 1.h),
            SizedBox(height: 10.h),
            _buildPatientChartSection(),
            SizedBox(height: 60.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 32.r,
              backgroundColor: const Color(0xFF68727D),
              backgroundImage: const AssetImage('assets/images/avatar.png'),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello',
                  style: TextStyle(
                    color: const Color.fromARGB(226, 82, 81, 81),
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  'Divine',
                  style: TextStyle(
                    color: const Color(0xFF4270B0),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 40.r,
              width: 40.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '10',
                style: GoogleFonts.luckiestGuy(
                  color: Colors.white,
                  fontSize: 20.sp,
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'Daily streak',
              style: TextStyle(color: const Color(0xFF68727D), fontSize: 12.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalizedGames() {
    return Container(
      width: double.infinity,
      height: 90.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: const Color(0xFF4270B0),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/pill_icon.png', height: 32.h),
          SizedBox(width: 12.w),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Personalized games',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended study plan',
          style: TextStyle(
            color: const Color(0xFF25292F),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 13.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ThemeSelectionScreen(),
                  ),
                ),
                child: Container(
                  height: 170.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: const Color.fromARGB(225, 166, 184, 255),
                      width: 1.w,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/rabbit.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Positioned(
                          top: 10.h,
                          left: 10.w,
                          child: Text(
                            'Exam Drill',
                            style: TextStyle(
                              color: const Color(0xFF4A6CF7),
                              fontWeight: FontWeight.bold,
                              fontSize: 17.6.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                height: 170.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/lightbulb.png',
                        height: 60.h,
                      ),
                    ),
                    Positioned(
                      bottom: 12.h,
                      left: 37.w,
                      child: Text(
                        'Practice Drill',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.6.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGamesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Games',
              style: TextStyle(
                color: const Color(0xFF25292F),
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'view all',
              style: TextStyle(color: Colors.blue[300], fontSize: 13.sp),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 170.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF454A87),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/recall_dash.png',
                        height: 80.h,
                      ),
                    ),
                    Positioned(
                      bottom: 12.h,
                      left: 37.w,
                      child: Text(
                        'Recall Dash',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.6.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                height: 170.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0A2E),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      "assets/images/calculation.png",
                      fit: BoxFit.cover,
                    ),
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFFF4EFC), Color(0xFF24015F)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      child: Text(
                        'Calculation\nGym',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                          height: 1.0,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPatientChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clinical Tools',
          style: TextStyle(
            color: const Color(0xFF25292F),
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PatientChartInfoScreen(),
              ),
            );
          },
          child: Container(
            height: 120.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F9B8E), Color(0xFF0A635B)], 
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F9B8E).withValues(alpha: 0.3),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  right: -10.w,
                  bottom: -15.h,
                  child: Icon(
                    Icons.medical_information,
                    size: 90.sp,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.monitor_heart_outlined, 
                              color: Colors.white, 
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Patient Chart',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Review case files & clinical data',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: const Color(0xFFE5E7EB), width: 1.5.w),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4270B0),
        unselectedItemColor: const Color(0xFF68727D),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Mode'),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports_outlined),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            label: 'Leagues',
          ),
        ],
      ),
    );
  }
}
