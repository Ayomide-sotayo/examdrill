import 'package:examdril/models/bns_question_model.dart';
import 'package:examdril/screens/best_next_step/bns_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BnsFeedbackScreen extends StatelessWidget {
  final List<BnsQuestionResult> results;

  const BnsFeedbackScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    const kBgColor = Color(0xFFE8EDF2);
    const kDarkBlue = Color(0xFF2C3947);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Feedbacks',
          style: TextStyle(
            color: kDarkBlue,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final res = results[index];
          return _FeedbackCard(result: res);
        },
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final BnsQuestionResult result;

  const _FeedbackCard({required this.result});

  @override
  Widget build(BuildContext context) {
    const kCardBg = Color(0xFF34404E);

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: kCardBg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result.question.scenario,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20.h),

          // Visualization of the 5 slots using BnsOptionCard
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (i) {
                    final optionIdx = result.slotAssignment[i];
                    final optionText = result.question.options[optionIdx];
                    final state = result.finalStates[i];

                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 110.h,
                              child: BnsOptionCard(
                                text: optionText,
                                state: state,
                                themeCardColor: const Color(0xFF34404E),
                                colorIndex: optionIdx,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              kSlotLabels[i].split(' ').join('\n'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),
          Text(
            result.question.explanation ?? 'No explanation provided.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
