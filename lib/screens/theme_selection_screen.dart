import 'package:examdril/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:math';

class ThemeSelectionScreen extends StatefulWidget {
  const ThemeSelectionScreen({super.key});

  @override
  State<ThemeSelectionScreen> createState() => _ThemeSelectionScreenState();
}

class _ThemeSelectionScreenState extends State<ThemeSelectionScreen> {
  int _selectedTheme = 0;
  bool _isSoundEnabled = true;
  final List<String?> _themes = [
    null,
    'assets/images/theme_2.png',
    'assets/images/theme_3.png',
    'assets/images/theme_4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: SafeArea(
        // I kept SafeArea here because this screen has its own top bar
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _buildHeader(),
                    SizedBox(height: 20.h),
                    _buildStatsRow(),
                    SizedBox(height: 24.h),
                    _buildThemePicker(),
                    SizedBox(height: 100.h),
                    _buildPacksSection(),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            _buildStartButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.close, color: Colors.white, size: 24.sp),
          ),
          Row(
            children: [
              Icon(
                Icons.help_outline_rounded,
                color: Colors.white70,
                size: 22.sp,
              ),
              SizedBox(width: 16.w),
              Icon(
                Icons.favorite_border_rounded,
                color: Colors.white70,
                size: 22.sp,
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: () => setState(() => _isSoundEnabled = !_isSoundEnabled),
                child: Icon(
                  _isSoundEnabled
                      ? Icons.volume_up_outlined
                      : Icons.volume_off_outlined,
                  color: Colors.white70,
                  size: 22.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19.r),
              child: Image.asset('assets/images/mascot.png', fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Exam Drill',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white),
      ),
      height: 88.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('Best Score', '5,738'),
          _statItem('Difficulty', '18/400'),
          _statItem('Played', '20'),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w100,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildThemePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pick a Theme',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          children: List.generate(_themes.length, (index) {
            final isSelected = _selectedTheme == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTheme = index),
                child: Container(
                  margin: EdgeInsets.only(
                    right: (index < _themes.length - 1) ? 24.w : 24.w,
                  ),
                  height: 130.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.5.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF454A87)
                          : Colors.transparent,
                      width: 2.5.w,
                    ),
                    color: _themes[index] == null
                        ? Colors.white
                        : const Color(
                            0xFF25254B,
                          ), // Slightly lighter than background for definition
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6.5.r),
                    child: _themes[index] == null
                        ? Center(
                            child: Text(
                              '?',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Image.asset(
                            _themes[index]!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.white30,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPacksSection() {
    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Packs',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All inclusive',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
              Text(
                '100%',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      child: SizedBox(
        width: double.infinity,
        height: 54.h,
        child: ElevatedButton(
          onPressed: () {
            String? themeToPass = _themes[_selectedTheme];
            if (themeToPass == null) {
              final random = Random();
              // Pick a random index between 1 and _themes.length - 1
              final randomIndex = 1 + random.nextInt(_themes.length - 1);
              themeToPass = _themes[randomIndex];
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuizScreen(
                  selectedTheme: themeToPass,
                  isSoundEnabled: _isSoundEnabled,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF454A87),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Start Game',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(Icons.play_arrow_outlined, color: Colors.white, size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }
}
