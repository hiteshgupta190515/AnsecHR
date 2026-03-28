import 'package:ready_lms/components/category_card.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/features/category/model/category.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Category extends StatelessWidget {
  const Category({super.key, required this.categoryList});

  final List<CategoryModel> categoryList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 2.2,
        ),
        itemCount: categoryList.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            image: categoryList[index].image ??
                AppConstants.defaultAvatarImageUrl,
            title: categoryList[index].title ?? 'Category',
            totalCourse: categoryList[index].courseCount ?? 0,
            color: categoryList[index].color!.toColor(),
            onTap: () {
              context.nav.pushNamed(
                Routes.allCourseScreen,
                arguments: {'model': categoryList[index]},
              );
            },
          );
        },
      ),
    );
  }
}
