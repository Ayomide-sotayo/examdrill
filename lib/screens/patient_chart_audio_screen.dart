import 'package:examdril/screens/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PatientChartAudioScreen extends StatefulWidget {
  const PatientChartAudioScreen({super.key});

  @override
  State<PatientChartAudioScreen> createState() =>
      _PatientChartAudioScreenState();
}

class _PatientChartAudioScreenState extends State<PatientChartAudioScreen> {
  @override
  void initState() {
    super.initState();
    // Hide status bar and bottom navigation bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore system UI when exiting the game completely
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 135.h),
              Text(
                'THIS GAME REQUIRES AUDIO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF766784),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 40.h),
              Container(
                width: 217.w,
                height: 217.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8E4F0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.volume_up_outlined,
                  size: 115.sp,
                  color: const Color(0xFF766784),
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                'TAKE NOTE OF THE FOLLOWING MEDICAL PROFILES AND ANSWER ACCORDINGLY',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF766784),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 60.h),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuestionScreen(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2033),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Begin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 54.h,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFD5D2D8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Exit',
                    style: TextStyle(
                      color: const Color(0xFF2A2033),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
