import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../dashboard_screen.dart';

class UsernameScreen extends StatefulWidget {
  final String resourceId;
  final String inviteCode;
  const UsernameScreen({
    super.key,
    required this.resourceId,
    required this.inviteCode,
  });

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
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
                // Smile Icon in a Circle
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(
                        Icons.sentiment_satisfied_alt_rounded,
                        size: 24.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                // Title
                Text(
                  'Tell us your name',
                  style: GoogleFonts.roboto(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8.h),
                // Subtitle
                Text(
                  'Welcome to ExamDash',
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    color: const Color(0xFF7D7D7D),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 48.h),
                
                // Name Input Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: _nameFocusNode.hasFocus
                          ? const Color(0xFFFF5B40)
                          : Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TextField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter Name',
                      hintStyle: GoogleFonts.roboto(
                        color: const Color(0xFFC4C4C4),
                        fontSize: 16.sp,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 20.h),
                    ),
                    onChanged: (value) => setState(() {}),
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
                        colors: _nameController.text.isNotEmpty
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
                      onPressed: _nameController.text.isNotEmpty
                          ? () async {
                              final authService = Provider.of<AuthService>(context, listen: false);
                              final success = await authService.enroll(
                                displayName: _nameController.text,
                                accessCode: widget.inviteCode,
                                resourceId: widget.resourceId,
                              );
                              
                              if (!mounted) return;
                              
                              if (success) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DashboardScreen(name: _nameController.text),
                                  ),
                                  (route) => false,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to enroll. Please check your invite code.')),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
