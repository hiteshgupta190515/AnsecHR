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
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          borderRadius: AppComponents.defaultBorderRadiusLarge,
          color: color.withOpacity(.6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category icon — wrapped in Flexible + FittedBox so it shrinks
            // gracefully when the grid cell is short.
            Flexible(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppStaticColor.whiteColor.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/spinner.gif',
                      image: image,
                      height: 44,
                      width: 44,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.category, color: AppStaticColor.whiteColor, size: 36),
                    ),
                  ),
                ),
              ),
            ),
            6.ph,
            // Title + course count
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                      fontSize: 13.sp,
                      color: AppStaticColor.whiteColor,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
              ),
            ),
            2.ph,
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
