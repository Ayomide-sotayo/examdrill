import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'patient_chart_audio_screen.dart';

class PatientChartInfoScreen extends StatefulWidget {
  const PatientChartInfoScreen({super.key});

  @override
  State<PatientChartInfoScreen> createState() => _PatientChartInfoScreenState();
}

class _PatientChartInfoScreenState extends State<PatientChartInfoScreen> {
  @override
  void initState() {
    super.initState();
    // Enable immersive mode when entering pre-game/game flow
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Reset to edge-to-edge when leaving the game flow
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF766784),
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
                  SizedBox(height: 16.h),
                  _buildBenefitsSection(),
                  SizedBox(height: 16.h),
                  _buildPacksSection(),
                  SizedBox(height: 100.h), // space so content doesn't hide behind button
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
              Icon(Icons.help_outline_rounded, color: Colors.white70, size: 22.sp),
              SizedBox(width: 16.w),
              Icon(
                Icons.favorite_border_rounded,
                color: Colors.white70,
                size: 22.sp,
              ),
              SizedBox(width: 16.w),
              Icon(Icons.volume_up_outlined, color: Colors.white70, size: 22.sp),
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
          width: 100.w,
          height: 100.w,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.r),
            child: Image.asset(
              'assets/images/patient_chart_avatar.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.person, size: 60.sp, color: Colors.grey),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Patient chart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w100,
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
        color: const Color(0xFF675B73),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _statItem('Best Score', '5,738')),
            _verticalDivider(),
            Expanded(child: _statItem('Difficulty', '18/400')),
            _verticalDivider(),
            Expanded(child: _statItem('Played', '20')),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
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
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(width: 1, height: double.infinity, color: Colors.white);
  }

  Widget _buildBenefitsSection() {
    return Center(
      child: Container(
        width: 342.w,
        height: 206.h,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.w),
        decoration: BoxDecoration(
          color: const Color(0xFF675B73),
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
                fontWeight: FontWeight.w100,
              ),
            ),
            SizedBox(height: 25.h),
            _benefitItem('Improve your reading comprehension.'),
            SizedBox(height: 25.h),
            _benefitItem('Improve your reading comprehension.'),
          ],
        ),
      ),
    );
  }

  Widget _benefitItem(String text) {
    return Row(
      children: [
        Image.asset('assets/images/benefit.png', height: 25.h, width: 21.3.w),
        SizedBox(width: 12.w),
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
        height: 290.h,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF675B73),
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
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: _packItem('Therapeutics', '100%'),
            ),
            _divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: _packItem('Safety', '0%'),
            ),
            _divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: _packItem('Monitoring', '0%'),
            ),
            _divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: _packItem('Pharmacokinetics', '0%'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _packItem(String name, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
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

  Widget _divider() {
    return Divider(color: Colors.white, height: 1.h, thickness: 1);
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PatientChartAudioScreen()),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A2033),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
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
            Icon(Icons.play_arrow_outlined, color: Colors.white, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
