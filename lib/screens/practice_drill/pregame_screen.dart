
import 'package:examdril/screens/practice_drill/practice_drill_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreGameScreen extends StatefulWidget {
  const PreGameScreen({super.key});

  @override
  State<PreGameScreen> createState() => _PreGameScreenState();
}

class _PreGameScreenState extends State<PreGameScreen> {
  bool _isSoundOn = true;

  @override
  void initState() {
    super.initState();
    // Enable immersive mode when entering pre-game/game flow
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Reset to edge-to-edge when leaving the game flow (popping back to dashboard)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable content
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  _buildTopBar(context),
                  SizedBox(height: 20.h),
                  _buildHeader(),
                  SizedBox(height: 24.h),
                  _buildStatsRow(),
                  SizedBox(height: 30.h),
                  _buildBenefitsSection(),
                  SizedBox(height: 30.h),
                  _buildPacksSection(),
                  SizedBox(
                    height: 100.h,
                  ), // space so content doesn't hide behind button
                ],
              ),
            ),
            // Floating button pinned to bottom
            Positioned(
              bottom: 24.h,
              left: 16.w,
              right: 16.w,
              child: _buildStartButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
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
              GestureDetector(
                onTap: () => setState(() => _isSoundOn = !_isSoundOn),
                child: Icon(
                  _isSoundOn ? Icons.volume_up_outlined : Icons.volume_off_outlined,
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
    return Column(
      children: [
        Container(
          width: 90.w,
          height: 90.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/lightbulb.png',
              height: 55.h,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.lightbulb_outline, size: 50.sp, color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Practice Drill',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      width: 342.w,
      height: 87.h,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: _statItem('Best Score', '5,738')),
          Expanded(child: _statItem('Difficulty', '01/06')),
          Expanded(child: _statItem('Played', '20')),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection() {
    return Center(
      child: Container(
        width: 342.w,
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Benefits',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30.h),
            _benefitItem(
              'Improve your reading comprehension.',
              isImage: true,
            ),
            SizedBox(height: 30.h),
            _benefitItem(
              'Improve your time management',
              isImage: false,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _benefitItem(String text, {required bool isImage}) {
    return Row(
      children: [
        isImage
            ? Image.asset('assets/images/benefit.png', height: 25.h, width: 21.3.w)
            : Icon(Icons.access_time_outlined, color: Colors.white, size: 24.sp),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildPacksSection() {
    return Center(
      child: Container(
        width: 342.w,
        padding: EdgeInsets.symmetric(vertical: 25.h),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(width: 1, color: Colors.white),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
              child: Text(
                'Packs',
                style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: _packItem('All inclusive', '100%'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _packItem(String name, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PracticeDrillScreen(isSoundEnabled: _isSoundOn)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Start Game',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.play_arrow_outlined, color: Colors.black, size: 22.sp),
          ],
        ),
      ),
    );
  }
}
