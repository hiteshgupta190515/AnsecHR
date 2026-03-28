import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/courses/view/my_course_details/component/lesson_item_card.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/features/courses/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../../../controller/my_course_details.dart';

class Lessons extends ConsumerWidget {
  const Lessons({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final chapters =
        ref.read(myCourseDetailsController).courseDetails!.chapters;

    // Flatten all contents across all chapters and list them directly.
    // Chapter headers (Class N, title, duration) are hidden.
    // To restore chapter grouping, uncomment LessonCard usage below.
    final allContents = [
      for (final chapter in chapters) ...chapter.contents,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.ph,
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Row(
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
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: colors(context).primaryColor!.withOpacity(0.1),
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
        ),
        12.ph,
        // Flat video list
        ...List.generate(allContents.length, (index) {
          return Padding(
            padding:
                EdgeInsets.only(left: 20.h, right: 20.h, bottom: 8.h),
            child: LessonItemCard(
              isBottom: true,
              lessonNumber: index + 1,
              model: allContents[index],
              isActive:
                  ref.watch(myCourseDetailsController).currentPlay!.id ==
                      allContents[index].id,
            ),
          );
        }),
        12.ph,
      ],
    );
  }
}

// LessonCard kept for potential future use (chapter grouping with headers).
class LessonCard extends ConsumerStatefulWidget {
  const LessonCard({
    super.key,
    required this.index,
    required this.model,
  });
  final int index;
  final Chapters model;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LessonCardState();
}

class _LessonCardState extends ConsumerState<LessonCard> {
  final isExpand = StateProvider<bool>((ref) => true);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 12.h),
      decoration: BoxDecoration(
        color: context.color.surface,
        borderRadius: AppComponents.defaultBorderRadiusSmall,
        border: Border.all(
          color: colors(context).primaryColor!.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          12.ph,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Row(
              children: [
                Text(
                  '${S.of(context).cClass} ${widget.index + 1}',
                  style: AppTextStyle(context)
                      .bodyTextSmall
                      .copyWith(fontSize: 10.sp),
                ),
                const Spacer(),
                Text(
                  ApGlobalFunctions.convertMinutesToHours(
                      widget.model.totalDuration, context),
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                      fontSize: 10.sp, color: colors(context).hintTextColor),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.h, right: 12.h, bottom: 4.h),
            child: Text(
              widget.model.title,
              style: AppTextStyle(context)
                  .bodyTextSmall
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          ...List.generate(
            widget.model.contents.length,
            (index) => LessonItemCard(
              isBottom: index == widget.model.contents.length - 1,
              model: widget.model.contents[index],
              isActive:
                  ref.watch(myCourseDetailsController).currentPlay!.id ==
                      widget.model.contents[index].id,
            ),
          ),
          12.ph,
        ],
      ),
    );
  }
}
