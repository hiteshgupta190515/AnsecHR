import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/app_logo_widget.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/features/home_tab/widget/all_course.dart';
import 'package:ready_lms/features/home_tab/widget/category.dart';
import 'package:ready_lms/features/home_tab/widget/slider_section.dart';
import 'package:ready_lms/features/home_tab/widget/viewall_card.dart';
import 'package:ready_lms/features/home_tab/widget/welcome_card.dart';
import 'package:ready_lms/features/notification/controller/notification.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/features/category/model/category.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/service/notification.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../category/controller/category.dart';
import '../courses/controller/course.dart';
import '../other/controller/others.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<HomeTab> {
  final courseController = StateNotifierProvider<CourseController, Course>(
      (ref) => CourseController(Course(courseList: [], mostPopular: []), ref));
  List<CategoryModel> categoryList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  init() {
    ref
        .read(categoryController.notifier)
        .getCategories(query: {'is_featured': true}).then(
      (value) {
        if (value.isSuccess) {
          categoryList.addAll(value.response);
        }
      },
    );
    ref.read(notificationProvider.notifier).getNotification(itemPerPage: 10, pageNumber: 1);
    ref.read(courseController.notifier).getHomeTabInit();
    ref.read(othersController.notifier).getBanner();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApGlobalFunctions.cAppBar(
          header: AppLogoWidget(
        compact: true,
        isDark: ref.read(hiveStorageProvider).getTheme(),
      )),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(courseController.notifier).removeListData();
          init();
          categoryList.clear();
        },
        child: SafeArea(
          child: ref.watch(categoryController) ||
                  ref.watch(courseController).isListLoading ||
                  ref.watch(courseController).courseList.isEmpty
              ? const ShimmerWidget()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Top surface section ─────────────────────────────
                      Container(
                        color: context.color.surface,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            10.ph,
                            WelcomeCard(
                              totalCourse:
                                  ref.watch(courseController).totalCourse,
                            ),
                            16.ph,
                            ViewAllCard(
                              title: S.of(context).categories,
                              onTap: () {
                                context.nav
                                    .pushNamed(Routes.allCategoryScreen);
                              },
                            ),
                            14.ph,
                            Category(categoryList: categoryList),
                            20.ph,
                            // SliderSection(), // hidden
                            // 16.ph,
                          ],
                        ),
                      ),

                      // ── All Courses ─────────────────────────────────────
                      16.ph,
                      ViewAllCard(
                        title: S.of(context).allCourse,
                        onTap: () {
                          context.nav.pushNamed(Routes.allCourseScreen);
                        },
                      ),
                      16.ph,
                      AllCourses(
                        courseList: ref.watch(courseController).courseList,
                      ),
                      20.ph,
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
