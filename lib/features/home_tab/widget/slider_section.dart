import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ready_lms/features/home_tab/model/banner.dart';

class SliderSection extends ConsumerStatefulWidget {
  const SliderSection({super.key, /*required this.sliderList*/});

  //final List<BannerModel> sliderList;

  @override
  ConsumerState<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends ConsumerState<SliderSection> {
  List<String> sliderList = [
    "assets/images/im_course_demo.png",
    "assets/images/im_course_demo.png",
    "assets/images/im_course_demo.png",
    "assets/images/im_course_demo.png",
    "assets/images/im_course_demo.png",
  ];
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16).r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 140.h,
              viewportFraction: 1,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: /*widget.sliderList*/sliderList
                .map(
                  (item) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5).r,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: /*CachedNetworkImage(
                  imageUrl: *//*item.data?.thumbnail*//* item ?? '',
                  fit: BoxFit.fill,
                ),*/
                    Image.asset(item, fit: BoxFit.fill,)
              ),
            )
                .toList(),
          ),
          Gap(12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: /*widget.*/sliderList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentIndex == entry.key ? 16.r : 6.r,
                  height: 6.r,
                  margin: const EdgeInsets.symmetric(horizontal: 4).r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: _currentIndex == entry.key
                        ? const Color(0xff007AC9)
                        : const Color(0xff007AC9).withOpacity(0.5),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
