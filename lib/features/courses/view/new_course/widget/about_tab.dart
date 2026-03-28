// ignore_for_file: unused_import
import 'package:ready_lms/components/instructor_card.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/features/courses/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../controller/course.dart';

class AboutTab extends ConsumerWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final courseDetails = ref.read(courseController).courseDetails!;
    final list = courseDetails.description;
    final chapters = courseDetails.chapters;
    final allContents = [for (final ch in chapters) ...ch.contents];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(
                list.length, (index) => DescriptionCard(model: list[index])),
            // InstructorCard hidden — uncomment to restore
            // InstructorCard(
            //   model: courseDetails.course.instructor,
            // ),
            if (allContents.isNotEmpty) ...[
              16.ph,
              // Section header
              Row(
                children: [
                  Icon(Icons.video_library_rounded,
                      size: 18.h, color: colors(context).primaryColor),
                  8.pw,
                  Text(
                    'Course Videos',
                    style: AppTextStyle(context)
                        .bodyText
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color:
                          colors(context).primaryColor!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${allContents.length} Lessons',
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            fontSize: 10.sp,
                            color: colors(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              12.ph,
              // Flat locked lesson list
              ...List.generate(allContents.length, (index) {
                final item = allContents[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: context.color.surface,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: colors(context).borderColor ??
                            Colors.transparent,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Numbered badge
                        Container(
                          width: 34.h,
                          height: 34.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors(context)
                                .hintTextColor!
                                .withOpacity(.12),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: colors(context).hintTextColor,
                              ),
                            ),
                          ),
                        ),
                        10.pw,
                        // Title + type + duration
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: AppTextStyle(context)
                                    .bodyTextSmall
                                    .copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              4.ph,
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    ApGlobalFunctions.getFileIcon(
                                        item.type),
                                    height: 11.h,
                                    width: 11.h,
                                    color: colors(context).hintTextColor,
                                  ),
                                  4.pw,
                                  Text(
                                    item.type == FileSystem.video.name
                                        ? 'Video'
                                        : item.type ==
                                                FileSystem.audio.name
                                            ? 'Audio'
                                            : item.type ==
                                                    FileSystem.document.name
                                                ? 'Document'
                                                : 'Content',
                                    style: AppTextStyle(context)
                                        .bodyTextSmall
                                        .copyWith(
                                          fontSize: 10.sp,
                                          color:
                                              colors(context).hintTextColor,
                                        ),
                                  ),
                                  if (item.duration != null) ...[
                                    6.pw,
                                    Icon(Icons.access_time_rounded,
                                        size: 11.h,
                                        color:
                                            colors(context).hintTextColor),
                                    3.pw,
                                    Text(
                                      '${item.duration} min',
                                      style: AppTextStyle(context)
                                          .bodyTextSmall
                                          .copyWith(
                                            fontSize: 10.sp,
                                            color: colors(context)
                                                .hintTextColor,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        8.pw,
                        // Lock icon
                        Icon(
                          Icons.lock_rounded,
                          size: 18.h,
                          color:
                              colors(context).hintTextColor!.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              12.ph,
            ],
          ],
        ),
      ),
    );
  }
}

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({
    super.key,
    required this.model,
  });
  final Description model;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: AppComponents.defaultBorderRadiusSmall),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            12.ph,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.h),
              child: Text(
                // S.of(context).description,
                model.heading,
                style: AppTextStyle(context)
                    .bodyTextSmall
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            10.ph,
            Html(data: model.body)
          ],
        ),
      ),
    );
  }
}
