import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/busy_loader.dart';
import 'package:ready_lms/components/course_card.dart';
import 'package:ready_lms/components/drop_down_item.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/category/model/category.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../category/controller/category.dart';
import '../courses/controller/course.dart';

class CourseSearchScreen extends ConsumerStatefulWidget {
  const CourseSearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchScreenViewState();
}

final searchCourseControllerProvider = StateNotifierProvider.autoDispose<CourseController, Course>(
    (ref) => CourseController(Course(courseList: [], mostPopular: []), ref));

final isDropDownShowProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

class _SearchScreenViewState extends ConsumerState<CourseSearchScreen> {
  ScrollController scrollController = ScrollController();
  String searchText = '';

  bool hasMoreData = true;
  int currentPage = 1;
  bool _isPaginationLoading = false;
  final deBouncer = DeBouncer(milliseconds: 1000);
  final TextEditingController searchController = TextEditingController();

  List<CategoryModel> categoryList = [];
  CategoryModel? selectedCategory;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      categoryList.add(CategoryModel(title: 'All'));
      categoryList.addAll(ref.read(categoryController.notifier).allCategoryList);
      selectedCategory = categoryList[0];
      loadData(isRefresh: true);
      setState(() {});
    });

    scrollController.addListener(() {
      if (scrollController.hasClients &&
          scrollController.position.pixels > 0 &&
          scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) {
        if (hasMoreData) loadData();
      }
    });
  }

  Future<void> loadData({bool isRefresh = false}) async {
    if (_isPaginationLoading && !isRefresh) return;
    if (isRefresh) {
      currentPage = 1;
      hasMoreData = true;
    }
    _isPaginationLoading = true;
    ref.read(searchCourseControllerProvider.notifier).getAllCourse(
        isRefresh: isRefresh,
        currentPage: currentPage,
        makeSortOrFiler: false,
        query: {
          'search': searchText,
          if (selectedCategory?.title != 'All' && selectedCategory?.id != null) 'category_id': selectedCategory!.id
        }).then((value) {
      _isPaginationLoading = false;
      if (value.isSuccess) {
        if (ref.read(isDropDownShowProvider)) {
          ref.read(isDropDownShowProvider.notifier).state = false;
        }
        if (value.response) {
          currentPage++;
        }
        hasMoreData = value.response;
        if (!hasMoreData) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var courseList = ref.watch(searchCourseControllerProvider).courseList;
    bool isLoading = ref.watch(searchCourseControllerProvider).isListLoading;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // Set the height to zero
        child: AppBar(
          elevation:
              0, // Optional: Set elevation to zero for a completely flat look
          automaticallyImplyLeading: false, // Optional: Hide the back button
        ),
      ),
      body: Column(
        children: [

          Container(
            color: context.color.surface,
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            context.nav.pop();
                          },
                          icon: SvgPicture.asset(
                            'assets/svg/ic_arrow_left.svg',
                            width: 24.h,
                            height: 24.h,
                            color: context.color.onSurface,
                          )),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(right: 20.h),
                  constraints: BoxConstraints(maxHeight: 44.h),
                  child: CustomFormWidget(
                    hint: "Search Training Sessions...",
                    controller: searchController,
                    onChanged: (value) {
                      deBouncer.run(() {
                        searchText = value;
                       /* if (value == '') {
                           ref.read(searchCourseControllerProvider.notifier).removeAllCourse();
                           return;
                         }*/

                        loadData(
                          isRefresh: true,
                        );
                      });
                    },
                    maxLines: 1,
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(13.h),
                      child: SvgPicture.asset(
                        'assets/svg/ic_search.svg',
                        height: 19.h,
                        width: 19.h,
                        color: colors(context).titleTextColor,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (ref.read(isDropDownShowProvider)) {
                  ref.read(isDropDownShowProvider.notifier).state = false;
                }
              },
              child: Stack(
                children: [
                  Positioned.fill(
                      top: 50.h,
                      child: isLoading && currentPage == 1
                          ? const ShimmerWidget()
                          : searchText != '' && courseList.isEmpty
                              ? ApGlobalFunctions.noItemFound(context: context)
                              : SingleChildScrollView(
                                  controller: scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      16.ph,
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.h),
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 12.h,
                                            mainAxisSpacing: 12.h,
                                            childAspectRatio: 0.52,
                                          ),
                                          itemCount: courseList.length,
                                          itemBuilder: (context, index) =>
                                              CourseCard(
                                            width: double.infinity,
                                            model: courseList[index],
                                            onTap: () {
                                              if (courseList[index]
                                                  .isEnrolled) {
                                                context.nav.pushNamed(
                                                    Routes.myCourseDetails,
                                                    arguments:
                                                        courseList[index].id);
                                              } else {
                                                context.nav.pushNamed(
                                                    Routes.courseNew,
                                                    arguments: {
                                                      'courseId':
                                                          courseList[index].id
                                                    });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      if (hasMoreData &&
                                          courseList.length >= 5) ...[
                                        12.ph,
                                        SizedBox(
                                            height: 80.h,
                                            child: const Center(
                                                child: BusyLoader())),
                                      ],
                                      32.ph
                                    ],
                                  ),
                                )),
                  if (selectedCategory != null)
                    Container(
                      margin: EdgeInsets.only(top: 1.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.h, vertical: 16.h),
                      color: context.color.surface,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedCategory!.title!,
                              style: AppTextStyle(context).bodyTextSmall,
                            ),
                          ),
                          4.pw,
                          GestureDetector(
                            onTap: () {
                              ref.read(isDropDownShowProvider.notifier).state =
                                  !ref.read(isDropDownShowProvider);
                            },
                            child: Icon(
                              ref.watch(isDropDownShowProvider)
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: context.color.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (ref.watch(isDropDownShowProvider))
                    Positioned(
                      top: 58.h,
                      left: 0,
                      right: 0,
                      child: Container(
                          constraints: const BoxConstraints(maxHeight: 400),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r)),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              itemCount: categoryList.length,
                              itemBuilder: (context, index) => Container(
                                    color:
                                        colors(context).scaffoldBackgroundColor,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.h),
                                    child: DropDownItem(
                                      isTopItem: index == 0,
                                      isBottomItem:
                                          index == categoryList.length - 1,
                                      onTap: () {
                                        selectedCategory = categoryList[index];
                                        ref
                                            .read(isDropDownShowProvider.notifier)
                                            .state = false;
                                        if (searchText != '') {
                                          loadData(
                                            isRefresh: true,
                                          );
                                        }
                                        setState(() {});
                                      },
                                      title:
                                          "${categoryList[index].title ?? ""} ${index == 0 ? "" : "(${categoryList[index].courseCount ?? 0})"}",
                                      isSelected: categoryList[index] ==
                                          selectedCategory,
                                    ),
                                  ))),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeBouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  DeBouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}
