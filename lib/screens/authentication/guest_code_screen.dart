import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'username_screen.dart';

class GuestCodeScreen extends StatefulWidget {
  const GuestCodeScreen({super.key});

  @override
  State<GuestCodeScreen> createState() => _GuestCodeScreenState();
}

class _GuestCodeScreenState extends State<GuestCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _codeController.addListener(_onCodeChanged);
    _codeFocusNode.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _codeFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  void _onCodeChanged() {
    setState(() {});
    if (_codeController.text.length == 6) {
      // Navigate to Username Screen when 6 digits are entered
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UsernameScreen()),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 48.w,
                    height: 37.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(9999.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6.9,
                          offset: const Offset(0, 0),
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
                SizedBox(height: 40.h),
                // Code Icon in a Circle
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
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
                  'Enter Invite Code',
                  style: GoogleFonts.roboto(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                // Subtitle
                Text(
                  'Private beta access is currently limited to invited users Enter your code to unlock the PEBC Readiness Pack',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: const Color(0xFF7D7D7D),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 48.h),
                
                // Code Input Field
                GestureDetector(
                  onTap: () {
                    _codeFocusNode.requestFocus();
                  },
                  child: Stack(
                    children: [
                      // Hidden TextField for input
                      SizedBox(
                        height: 64.h,
                        child: Opacity(
                          opacity: 0,
                          child: TextField(
                            controller: _codeController,
                            focusNode: _codeFocusNode,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // Visual Representation
                      IgnorePointer(
                        child: Container(
                          height: 64.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: _codeFocusNode.hasFocus
                                  ? const Color(0xFFFF5B40) 
                                  : Colors.transparent,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(6, (index) {
                              String char = '';
                              if (_codeController.text.length > index) {
                                char = _codeController.text[index];
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
                
                // Continue Button (Teal Gradient)
                Center(
                  child: Container(
                    width: 337.w,
                    height: 49.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _codeController.text.length == 6
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
                      onPressed: _codeController.text.length == 6
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const UsernameScreen()),
                              );
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
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 48.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
