import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientChartInstructionsScreen extends StatefulWidget {
  const PatientChartInstructionsScreen({super.key});

  @override
  State<PatientChartInstructionsScreen> createState() =>
      _PatientChartInstructionsScreenState();
}

class _PatientChartInstructionsScreenState
    extends State<PatientChartInstructionsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF766784),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Text(
              'Instructions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 40.h),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildPageOne(),
                  _buildPageTwo(),
                ],
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageOne() {
    return Column(
      children: [
        Container(
          width: 280.w,
          padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: const Color(0xFF8C7D99), // slightly lighter purple
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Container(
                width: 140.w,
                height: 140.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8E8E8),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/patient_chart_avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.person,
                      size: 80.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Raymond',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.h),
              _prescriptionText('Rampril 10mg daily'),
              SizedBox(height: 8.h),
              _prescriptionText('Spironolactone 25mg daily'),
              SizedBox(height: 8.h),
              _prescriptionText('Potassium chloride 20 mEq daily'),
            ],
          ),
        ),
        const Spacer(),
        Text(
          'Read through the profiles.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _prescriptionText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildPageTwo() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildAvatarWithRing('Charles', 'assets/images/charles.png'),
                      _buildSimpleAvatar('Sam', 'assets/images/sam.png'),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSimpleAvatar('William', 'assets/images/william.png'),
                      _buildSimpleAvatar('Zack', 'assets/images/zack.png'),
                    ],
                  ),
                ],
              ),
              // Hand Pointer Overlay
              Positioned(
                left: 100.w, // Positioned at the bottom-right edge of Charles's ring
                top: 105.h,
                child: Image.asset(
                  'assets/images/hand.png',
                  width: 65.w,
                  height: 65.w,
                  color: Colors.white,
                  errorBuilder: (_, __, ___) => const SizedBox(),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          'Tap on the profile that best answers the question',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildSimpleAvatar(String name, String imagePath) {
    return Column(
      children: [
        Opacity(
          opacity: 0.5, // Dulls the avatar by letting the background blend through
          child: CircleAvatar(
            radius: 65.r,
            backgroundColor: const Color(0xFFE8E8E8),
            backgroundImage: AssetImage(imagePath),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          name,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarWithRing(String name, String imagePath) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3.w,
            ),
          ),
          child: CircleAvatar(
            radius: 65.r,
            backgroundColor: const Color(0xFFE8E8E8),
            backgroundImage: AssetImage(imagePath),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 30.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(0),
              SizedBox(width: 8.w),
              _buildDot(1),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A2033),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                elevation: 0,
              ),
              onPressed: _nextPage,
              child: Text(
                _currentPage == 0 ? 'Next' : 'Done',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    bool isActive = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}
