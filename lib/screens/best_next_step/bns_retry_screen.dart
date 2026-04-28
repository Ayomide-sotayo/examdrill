import 'package:examdril/models/bns_question_model.dart';
import 'package:examdril/screens/best_next_step/bns_option_card.dart';
import 'package:examdril/screens/best_next_step/bns_pregame_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BnsRetryScreen extends StatelessWidget {
  final List<BnsQuestionResult> results;
  final BnsTheme theme;

  const BnsRetryScreen({
    super.key,
    required this.results,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    const kBgColor = Color(0xFFE8EDF2);
    const kContentBg = Color(0xFF547A95);

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            // Header
            Text(
              'Nice Try',
              style: GoogleFonts.roboto(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C3947),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You lost all your lives',
              style: GoogleFonts.roboto(
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2C3947),
              ),
            ),
            SizedBox(height: 30.h),

            // Content Report Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: kContentBg,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'CONTENT REPORT',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final res = results[index];
                          // Only show the cards if they failed it, or maybe show all?
                          // The user said "see the option the user failed before coming there"
                          return _RetryQuestionCard(result: res);
                        },
                      ),
                    ),
                    
                    // Bottom Buttons
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                      decoration: BoxDecoration(
                        color: kContentBg,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildButton(
                              context,
                              'Play Again',
                              onPressed: () => Navigator.pop(context, 'retry'),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: _buildButton(
                              context,
                              'Done',
                              onPressed: () => Navigator.pop(context, 'quit'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, {required VoidCallback onPressed}) {
    return SizedBox(
      height: 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2C3947),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _RetryQuestionCard extends StatelessWidget {
  final BnsQuestionResult result;

  const _RetryQuestionCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2C3947),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.question.scenario,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          
          // Mini Cards Row (Simplified visualization like in feedback)
          Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: List.generate(5, (i) {
                final optionIdx = result.slotAssignment[i];
                final optionText = result.question.options[optionIdx];
                final state = result.finalStates[i];

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90.h,
                          child: BnsOptionCard(
                            text: optionText,
                            state: state,
                            themeCardColor: const Color(0xFF2C3947),
                            colorIndex: optionIdx,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          kSlotLabels[i].split(' ').join('\n'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            color: Colors.white70,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          
          if (result.question.explanation != null) ...[
            SizedBox(height: 24.h),
            Text(
              result.question.explanation!,
              style: GoogleFonts.roboto(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
