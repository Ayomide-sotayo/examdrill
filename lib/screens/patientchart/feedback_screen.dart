import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/patients_data.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B7E9F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Feedbacks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        itemCount: patientQuestions.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          final question = patientQuestions[index];
          final correctPatient = question.patients[question.correctPatientIndex];

          return Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFF51445E),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Answer: ${correctPatient.name}',
                      style: TextStyle(
                        color: const Color(0xFF33CF6C),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.thumb_down_alt_outlined,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                if (question.explanation != null)
                  Text(
                    question.explanation!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                  ),
                if (question.explanation1 != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    question.explanation1!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                  ),
                ],
                if (question.explanation2 != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    question.explanation2!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
