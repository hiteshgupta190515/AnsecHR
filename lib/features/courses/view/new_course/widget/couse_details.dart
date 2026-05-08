import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/course_shorts_info.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/courses/view/new_course/widget/video.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/features/courses/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../../../controller/course.dart';
import '../../my_course_details/component/image_card.dart';

import 'iframe_card.dart';

class CourseDetails extends StatefulWidget {
  const CourseDetails({super.key, required this.model});
  final CourseDetailModel model;

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.color.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Consumer(builder: (context, ref, _) {
                String? fileSystem =
                    ref.watch(courseController).currentPlay?.fileSystem;
                if (fileSystem == FileSystem.iframe.name) {
                  return Visibility(
                    visible: true,
                    child: IframeCard(
                      iframeUrl:
                          ref.read(courseController).currentPlay!.fileLink!,
                    ),
                  );
                }
                if (fileSystem == FileSystem.video.name) {
                  return const Visibility(
                    visible: true,
                    child: VideoCard(),
                  );
                }
                if (fileSystem == FileSystem.audio.name) {
                  return const Visibility(
                    visible: true,
                    child: VideoCard(),
                  );
                }
                if (fileSystem == FileSystem.document.name) {}
                if (fileSystem == FileSystem.image.name) {}
                return ImageCard(
                    image: ref.read(courseController).currentPlay!.fileLink!);
              }),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.model.course.title,
                  style: AppTextStyle(context)
                      .bodyText
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                16.ph,
                CourseShortsInfo(
                    totalTime: ApGlobalFunctions.convertMinutesToHours(
                        widget.model.course.totalDuration, context),
                    totalEnrolled: '${widget.model.course.studentCount}',
                    showEnrolled: false,
                    rating:
                        double.tryParse('${widget.model.course.averageRating}')!
                            .toStringAsFixed(1)
                            .toString(),
                    totalRating: '(${widget.model.course.reviewCount})'),
                16.ph,
                // Instructor Info
                Row(
                  children: [
                    Container(
                      width: 44.h,
                      height: 44.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors(context).hintTextColor!.withOpacity(.2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22.h),
                        child: widget.model.course.instructor.profilePicture.isNotEmpty
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/images/spinner.gif',
                                image: widget.model.course.instructor.profilePicture,
                                fit: BoxFit.cover,
                                imageErrorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.person, color: colors(context).hintTextColor),
                              )
                            : Icon(Icons.person, color: colors(context).hintTextColor),
                      ),
                    ),
                    12.pw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.model.course.instructor.name.isNotEmpty
                                ? widget.model.course.instructor.name
                                : 'Instructor',
                            style: AppTextStyle(context).bodyText.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                          ),
                          if (widget.model.course.instructor.title.isNotEmpty) ...[
                            2.ph,
                            Text(
                              widget.model.course.instructor.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle(context).bodyTextSmall.copyWith(
                                    fontSize: 12.sp,
                                    color: colors(context).hintTextColor,
                                  ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
                8.ph,
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CourseContaintInfoCard extends StatelessWidget {
  const CourseContaintInfoCard({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 4.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.h),
          color: colors(context).scaffoldBackgroundColor),
      child: Text(
        text,
        style: AppTextStyle(context).bodyTextSmall.copyWith(fontSize: 10.sp),
      ),
    );
  }
}
