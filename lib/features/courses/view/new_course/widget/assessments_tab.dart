import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/courses/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class AssessmentsTab extends StatelessWidget {
  const AssessmentsTab({super.key, required this.model});

  final CourseDetailModel model;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: (model.quizzes.isEmpty && model.exams.isEmpty)
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50.h),
                child: Text(
                  'No Assessments Available',
                  style: AppTextStyle(context).bodyTextSmall,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (model.quizzes.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 20.h, top: 24.h, bottom: 8.h),
                    child: Text(
                      'Quizzes',
                      style: AppTextStyle(context).title.copyWith(fontSize: 16.sp),
                    ),
                  ),
                  ...List.generate(
                      model.quizzes.length,
                      (index) => QuizCard(
                            quiz: model.quizzes[index],
                          )),
                ],
                if (model.exams.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 20.h, top: 24.h, bottom: 8.h),
                    child: Text(
                      'Exams',
                      style: AppTextStyle(context).title.copyWith(fontSize: 16.sp),
                    ),
                  ),
                  ...List.generate(
                      model.exams.length,
                      (index) => ExamCard(
                            exam: model.exams[index],
                          )),
                ],
                20.ph,
              ],
            ),
    );
  }
}

class QuizCard extends StatelessWidget {
  const QuizCard({super.key, required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 12.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: AppComponents.defaultBorderRadiusSmall,
        boxShadow: [
          BoxShadow(
            color: colors(context).hintTextColor!.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: AppStaticColor.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.quiz, color: AppStaticColor.primaryColor, size: 24.h),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: AppTextStyle(context).bodyText.copyWith(fontWeight: FontWeight.w600),
                ),
                4.ph,
                Text(
                  '${quiz.questionsCount} Questions • ${quiz.durationPerQuestion} min/q',
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                        color: colors(context).hintTextColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  const ExamCard({super.key, required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 12.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: AppComponents.defaultBorderRadiusSmall,
        boxShadow: [
          BoxShadow(
            color: colors(context).hintTextColor!.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: AppStaticColor.orangeColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.assignment, color: AppStaticColor.orangeColor, size: 24.h),
          ),
          16.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.title,
                  style: AppTextStyle(context).bodyText.copyWith(fontWeight: FontWeight.w600),
                ),
                4.ph,
                Text(
                  '${exam.questionCount} Questions • ${exam.duration} mins',
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                        color: colors(context).hintTextColor,
                      ),
                ),
                2.ph,
                Text(
                  'Pass Mark: ${exam.passMarks}',
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                        color: AppStaticColor.greenColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
