import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../dashboard_screen.dart';
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

  void _onOtpChanged() async {
    setState(() {}); // Ensure the UI updates to show typed characters
    if (_otpController.text.length == 6) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final success = await authService.verifyOTP(widget.email, _otpController.text);
      
      if (!mounted) return;
      
      if (success) {
        final profile = authService.userProfile;
        if (profile != null && profile['display_name'] != null && profile['display_name'].toString().isNotEmpty) {
          // Existing user - Go to Dashboard
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(name: profile['display_name']),
            ),
            (route) => false,
          );
        } else {
          // New user - Go to Courses
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CoursesScreen()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid verification code.')),
        );
      }
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                GestureDetector(
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
                            color: Colors.black,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                // Mail Icon in a Circle (matching SignInScreen)
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Center(
                    // Faded icon as seen in the image
                    child: Image.asset(
                      'assets/images/code.png',
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.qr_code_2_rounded,
                        size: 50.sp,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),
                // Title
                Text(
                  'Enter Code',
                  style: GoogleFonts.roboto(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                // Subtitle
                Text(
                  'Enter the verification code sent to your email\n${widget.email}',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: const Color(0xFF7D7D7D),
                    height: 1.4,
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
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
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
                            borderRadius: BorderRadius.circular(
                              16.r,
                            ), // Less rounded as requested
                            border: Border.all(
                              color: _otpFocusNode.hasFocus
                                  ? const Color(0xFFFF5B40)
                                  : Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              String char = '';
                              if (_otpController.text.length > index) {
                                char = _otpController.text[index];
                              }
                              return Text(
                                char.isEmpty ? '—' : char,
                                style: GoogleFonts.roboto(
                                  fontSize: 24.sp,
                                  color: char.isEmpty
                                      ? const Color(0xFFC4C4C4)
                                      : const Color(0xFFFF5B40),
                                  fontWeight: char.isEmpty
                                      ? FontWeight.normal
                                      : FontWeight.w600,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 80.h),

                // Continue Button (Matching SignInScreen)
                Center(
                  child: Container(
                    width: 337.w,
                    height: 49.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _otpController.text.length == 6
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
                      onPressed: _otpController.text.length == 6 ? () => _onOtpChanged() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999.r),
                        ),
                      ),
                      child: Consumer<AuthService>(
                        builder: (context, auth, child) {
                          if (auth.isLoading) {
                            return SizedBox(
                              height: 20.w,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            );
                          }
                          return Text(
                            'Continue',
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
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
                            }
                          : null,
                      child: Text(
                        _resendTimerSeconds > 0
                            ? 'Resend in ${_resendTimerSeconds}s'
                            : 'Resend',
                        style: GoogleFonts.roboto(
                          color: _resendTimerSeconds > 0
                              ? const Color(0xFFC4C4C4)
                              : const Color(0xFFFF5B40),
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
