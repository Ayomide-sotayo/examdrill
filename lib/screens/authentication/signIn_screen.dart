import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import 'verification_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  bool _isButtonEnabled = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _emailFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                // Mail Icon in a Circle
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/mail.png',
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.mail_outline,
                        size: 50.sp,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                // Title
                Text(
                  'Continue With Email',
                  style: GoogleFonts.roboto(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                // Subtitle
                Text(
                  'Sign in or Sign up with your email to continue.',
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
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: _errorText != null
                          ? Colors.red
                          : (_emailFocusNode.hasFocus
                              ? const Color(0xFFFF5B40)
                              : Colors.transparent),
                      width: 1.0,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
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
                      contentPadding: EdgeInsets.symmetric(vertical: 20.h),
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
                SizedBox(height: 80.h),
                // Continue Button
                Center(
                  child: Container(
                    width: 337.w,
                    height: 49.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _isButtonEnabled
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
                      onPressed: _isButtonEnabled
                          ? () async {
                              final authService = Provider.of<AuthService>(context, listen: false);
                              final success = await authService.requestOTP(_emailController.text);
                              
                              if (!mounted) return;
                              
                              if (success) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerificationScreen(
                                        email: _emailController.text),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to request OTP. Please try again.')),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9999.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 0),
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
