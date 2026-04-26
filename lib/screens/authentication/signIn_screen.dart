import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'verification_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    final bool isValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    
    setState(() {
      _isButtonEnabled = email.isNotEmpty && isValid;
      if (email.isNotEmpty && !isValid) {
        _errorText = 'Please enter a valid email address';
      } else {
        _errorText = null;
      }
    });
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
                SizedBox(height: 60.h),
                // Mascot Image in a Circle
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
                  'Sign In',
                  style: GoogleFonts.roboto(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                // Subtitle
                Text(
                  'Sign in with your email to continue.',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: const Color(0xFF7D7D7D),
                  ),
                ),
                SizedBox(height: 48.h),
                // Email Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: _errorText != null ? Colors.red : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter Email Address',
                      hintStyle: GoogleFonts.roboto(
                        color: const Color(0xFFC4C4C4),
                        fontSize: 16.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                  ),
                ),
                if (_errorText != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h, left: 16.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _errorText!,
                        style: GoogleFonts.roboto(
                          color: Colors.red,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 24.h),
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled 
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VerificationScreen(email: _emailController.text),
                            ),
                          );
                        }
                      : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonEnabled 
                          ? const Color(0xFF469EFF) 
                          : const Color(0xFF469EFF).withOpacity(0.3), // Dull color
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF469EFF).withOpacity(0.3),
                      disabledForegroundColor: Colors.white.withOpacity(0.7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h), // Extra space at bottom for scrolling
              ],
            ),
          ),
        ),
      ),
    );
  }
}
