import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.image,
    required this.title,
    required this.totalCourse,
    required this.color,
    required this.onTap,
    // width/height are optional — when used inside a GridView the grid
    // controls the size automatically.
    this.width,
    this.height,
  });

  final String image, title;
  final int totalCourse;
  final Color color;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,   // null → fills the grid cell
        height: height, // null → fills the grid cell
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: AppComponents.defaultBorderRadiusLarge,
          color: color.withOpacity(.6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Category icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppStaticColor.whiteColor.withOpacity(0.2),
              ),
              padding: EdgeInsets.all(6.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/spinner.gif',
                  image: image,
                  height: 44.h,
                  width: 44.h,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.category, color: AppStaticColor.whiteColor, size: 36.h),
                ),
              ),
            ),
            12.ph,
            // Title + course count
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                      fontSize: 14.sp,
                      color: AppStaticColor.whiteColor,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
              ),
            ),
            4.ph,
            Flexible(
              child: Text(
                '$totalCourse ${S.of(context).course}',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                      color: AppStaticColor.whiteColor.withOpacity(.9),
                      fontSize: 11.sp,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
