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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Category icon
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/spinner.gif',
                image: image,
                height: 40.h,
                width: 40.h,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.category, color: AppStaticColor.whiteColor, size: 32.h),
              ),
            ),
            10.pw,
            // Title + course count
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                          fontSize: 12.sp,
                          color: AppStaticColor.whiteColor,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                  ),
                  4.ph,
                  Text(
                    '$totalCourse ${S.of(context).course}',
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                          color: AppStaticColor.whiteColor.withOpacity(.85),
                          fontSize: 10.sp,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
