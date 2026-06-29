import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/course_shorts_info.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../config/app_constants.dart';
import '../config/theme.dart';
import '../features/courses/model/course_list.dart';
import '../utils/global_function.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.onTap,
    this.height = 80,
    this.width = 240,
    this.marginRight = 0,
    this.marginBottom = 0,
    required this.model,
    this.maxLineOfTitle = 2,
    /// Set to false on the home page to hide price, enrolled count & ratings.
    this.showMeta = true,
    /// Show star rating even when showMeta is false.
    this.showRating = false,
  });

  final double height, width, marginRight, marginBottom;
  final VoidCallback onTap;
  final CourseListModel model;
  final int? maxLineOfTitle;
  final bool showMeta;
  final bool showRating;
  @override
  Widget build(BuildContext context) {
    final bool isNarrow = width.isInfinite || width < 200;
    return Container(
      width: width.isInfinite ? double.infinity : width.w,
      margin: EdgeInsets.only(right: marginRight.h, bottom: marginBottom.h),
      decoration: BoxDecoration(
          borderRadius: AppComponents.defaultBorderRadiusSmall,
          color: context.color.surface),
      child: ClipRRect(
        borderRadius: AppComponents.defaultBorderRadiusSmall,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.6,
              child: FadeInImage.assetNetwork(
                placeholderFit: BoxFit.contain,
                placeholder: 'assets/images/spinner.gif',
                image: model.thumbnail,
                width: double.infinity,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: context.color.primary);
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.category,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                        fontSize: 10.sp, color: context.color.primary),
                  ),
                  4.ph,
                  Text(
                    model.title,
                    maxLines: maxLineOfTitle,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                      fontSize: 13.sp,
                    ),
                  ),
                  if (showMeta) ...[
                    8.ph,
                    CourseShortsInfo(
                      showEnrolled: !isNarrow,
                      totalTime: ApGlobalFunctions.convertMinutesToHours(
                          model.totalDuration, context),
                      totalEnrolled: '${model.studentCount}',
                      rating: double.tryParse('${model.averageRating}')!
                          .toStringAsFixed(1)
                          .toString(),
                      totalRating: '(${model.reviewCount})',
                    ),
                    12.ph,
                    isNarrow
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.isFree == true
                                    ? S.of(context).free
                                    : model.price != null
                                        ? "${AppConstants.currencySymbol}${model.price}"
                                        : "${AppConstants.currencySymbol}${model.price ?? model.regularPrice}",
                                style: AppTextStyle(context).subTitle,
                              ),
                              if (model.price != null || model.isFree == true)
                                if (model.regularPrice != null) ...[
                                  4.ph,
                                  Text(
                                    '${AppConstants.currencySymbol}${model.regularPrice}',
                                    style: AppTextStyle(context)
                                        .buttonText
                                        .copyWith(
                                          color: colors(context).hintTextColor,
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: colors(context).hintTextColor,
                                        ),
                                  ),
                                ],
                              8.ph,
                              SizedBox(
                                width: double.infinity,
                                child: AppButton(
                                  title: S.of(context).details,
                                  titleColor: context.color.surface,
                                  onTap: onTap,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.isFree == true
                                        ? S.of(context).free
                                        : model.price != null
                                            ? "${AppConstants.currencySymbol}${model.price}"
                                            : "${AppConstants.currencySymbol}${model.price ?? model.regularPrice}",
                                    style: AppTextStyle(context).subTitle,
                                  ),
                                  4.pw,
                                  model.price != null || model.isFree == true
                                      ? model.regularPrice != null
                                          ? Text(
                                              '${AppConstants.currencySymbol}${model.regularPrice}',
                                              style: AppTextStyle(context)
                                                  .buttonText
                                                  .copyWith(
                                                    color:
                                                        colors(context).hintTextColor,
                                                    decoration:
                                                        TextDecoration.lineThrough,
                                                    decorationColor:
                                                        colors(context).hintTextColor,
                                                  ),
                                            )
                                          : const SizedBox()
                                      : const SizedBox(),
                                ],
                              ),
                              const Spacer(),
                              AppButton(
                                title: S.of(context).details,
                                titleColor: context.color.surface,
                                onTap: onTap,
                              ),
                            ],
                          ),
                  ] else ...[
                    8.ph,
                    // Show duration — hide enrolled count & price
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 14.h,
                            color: context.color.inverseSurface),
                        4.pw,
                        Text(
                          ApGlobalFunctions.convertMinutesToHours(
                              model.totalDuration, context),
                          style: AppTextStyle(context).bodyTextSmall.copyWith(
                              fontSize: 10.sp,
                              color: context.color.inverseSurface),
                        ),
                      ],
                    ),
                    if (showRating) ...[
                      4.ph,
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/ic_star.svg',
                            height: 12.h,
                            width: 12.h,
                          ),
                          4.pw,
                          Text(
                            double.tryParse('${model.averageRating}')!
                                .toStringAsFixed(1),
                            style: AppTextStyle(context)
                                .bodyTextSmall
                                .copyWith(
                                    fontSize: 10.sp,
                                    color: context.color.inverseSurface,
                                    fontWeight: FontWeight.w700),
                          ),
                          4.pw,
                          Text(
                            '(${model.reviewCount})',
                            style: AppTextStyle(context)
                                .bodyTextSmall
                                .copyWith(
                                    fontSize: 10.sp,
                                    color: context.color.inverseSurface),
                          ),
                        ],
                      ),
                    ],
                    12.ph,
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        title: S.of(context).details,
                        titleColor: context.color.surface,
                        onTap: onTap,
                      ),
                    ),
                  ]
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
