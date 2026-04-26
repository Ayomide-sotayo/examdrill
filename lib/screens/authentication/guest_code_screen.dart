import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dashboard_screen.dart';

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
      // Navigate to Dashboard when 6 digits are entered
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
        (route) => false,
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
                // Guest Mascots Image
                Center(
                  child: Image.asset(
                    'assets/images/guestmascots.png',
                    width: 140.w,
                    height: 140.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 32.h),
                // Title
                Text(
                  'Enter Guest Code',
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
                    'Only invited users can access the product.\nEnter your code to continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      color: const Color(0xFF7D7D7D),
                    ),
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
                            borderRadius: BorderRadius.circular(32.r),
                            border: Border.all(
                              color: _codeFocusNode.hasFocus
                                  ? const Color(0xFF469EFF) 
                                  : Colors.white,
                              width: 1.5,
                            ),
                            boxShadow: _codeController.text.isNotEmpty
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
                              if (_codeController.text.length > index) {
                                char = _codeController.text[index];
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
