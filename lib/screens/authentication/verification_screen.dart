import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'courses_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  int _resendTimerSeconds = 0;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_onOtpChanged);
    _otpFocusNode.addListener(() {
      setState(() {});
    });
    // Auto-focus the field when the screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimerSeconds = 20;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimerSeconds > 0) {
        setState(() {
          _resendTimerSeconds--;
        });
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  void _onOtpChanged() {
    setState(() {}); // Trigger rebuild to show the typed numbers
    if (_otpController.text.length == 6) {
      // Navigate to courses screen when 6 digits are entered
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CoursesScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
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
                SizedBox(height: 20.h),
                // Mascot Image
                Center(
                  child: Image.asset(
                    'assets/images/signinmascot.png',
                    width: 120.w,
                    height: 120.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 32.h),
                // Title
                Text(
                  'Check email for code',
                  style: GoogleFonts.roboto(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                // Subtitle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Enter the verification code sent to ${widget.email}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: const Color(0xFF7D7D7D),
                    ),
                  ),
                ),
                SizedBox(height: 48.h),
                
                // OTP Input Field
                GestureDetector(
                  onTap: () {
                    _otpFocusNode.requestFocus();
                  },
                  child: Stack(
                    children: [
                      // Hidden TextField for input
                      SizedBox(
                        height: 64.h,
                        child: Opacity(
                          opacity: 0,
                          child: TextField(
                            controller: _otpController,
                            focusNode: _otpFocusNode,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // Visual Representation of OTP
                      IgnorePointer(
                        child: Container(
                          height: 64.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32.r),
                            border: Border.all(
                              color: _otpFocusNode.hasFocus
                                  ? const Color(0xFF469EFF) 
                                  : Colors.white, // Only show blue ring when focused
                              width: 1.5,
                            ),
                            boxShadow: _otpController.text.isNotEmpty
                                ? [
                                    const BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              String char = '';
                              if (_otpController.text.length > index) {
                                char = _otpController.text[index];
                              }
                              return Text(
                                char.isEmpty ? '-' : char,
                                style: GoogleFonts.roboto(
                                  fontSize: 24.sp,
                                  color: char.isEmpty 
                                      ? const Color(0xFFC4C4C4) 
                                      : const Color(0xFF5A5A5A),
                                  fontWeight: char.isEmpty 
                                      ? FontWeight.normal 
                                      : FontWeight.w500,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 48.h),
                // Footer Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Didn’t receive code? ',
                      style: GoogleFonts.roboto(
                        color: const Color(0xFF7D7D7D),
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: _resendTimerSeconds == 0 
                          ? () {
                              _startResendTimer();
                              // Actual resend logic goes here
                            }
                          : null,
                      child: Text(
                        _resendTimerSeconds > 0 ? 'Resend in ${_resendTimerSeconds}s' : 'Resend',
                        style: GoogleFonts.roboto(
                          color: _resendTimerSeconds > 0 
                              ? const Color(0xFFC4C4C4) // Faded text when disabled
                              : const Color(0xFF469EFF),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Try another email? ',
                      style: GoogleFonts.roboto(
                        color: const Color(0xFF7D7D7D),
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Go back',
                        style: GoogleFonts.roboto(
                          color: const Color(0xFF469EFF),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
