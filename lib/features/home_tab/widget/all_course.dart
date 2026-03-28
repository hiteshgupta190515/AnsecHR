import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/course_card.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../../courses/model/course_list.dart';

class AllCourses extends StatelessWidget {
  const AllCourses({
    super.key,
    required this.courseList,
  });

  final List<CourseListModel> courseList;

  @override
  Widget build(BuildContext context) {
    if (courseList.isEmpty) return const SizedBox.shrink();

    final rowCount = (courseList.length / 2).ceil();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gapPx = 8.w;
          // CourseCard applies .w internally, so convert back to design units.
          final cardWidth =
              (constraints.maxWidth - gapPx) / 2 / ScreenUtil().scaleWidth;

          return Column(
            children: List.generate(rowCount, (rowIndex) {
              final firstIndex = rowIndex * 2;
              final secondIndex = firstIndex + 1;
              final first = courseList[firstIndex];
              final second = secondIndex < courseList.length
                  ? courseList[secondIndex]
                  : null;

              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard(context, first, cardWidth),
                    if (second != null) ...[
                      SizedBox(width: gapPx),
                      _buildCard(context, second, cardWidth),
                    ],
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, CourseListModel course, double cardWidth) {
    return CourseCard(
      width: cardWidth,
      marginRight: 0,
      marginBottom: 0,
      maxLineOfTitle: 2,
      showMeta: false,
      showRating: true,
      model: course,
      onTap: () {
        if (course.isEnrolled) {
          context.nav.pushNamed(
            Routes.myCourseDetails,
            arguments: course.id,
          );
        } else {
          context.nav.pushNamed(
            Routes.courseNew,
            arguments: {'courseId': course.id},
          );
        }
      },
    );
  }
}
