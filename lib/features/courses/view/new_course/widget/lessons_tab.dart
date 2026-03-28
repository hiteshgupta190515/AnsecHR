import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/features/courses/model/course_detail.dart';
import 'package:ready_lms/features/courses/model/current_class.dart';
import 'package:ready_lms/features/check_out/model/hive_cart_model.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../controller/course.dart';
import '../../../controller/my_course_details.dart';
import '../../my_course_details/component/content_details_bottom_widget.dart';

class LessonsTab extends ConsumerWidget {
  const LessonsTab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final chapters = ref.read(courseController).courseDetails!.chapters;
    if (chapters.isEmpty) {
      return const Center(child: Text('No Content Available!'));
    }
    final allContents = [for (final ch in chapters) ...ch.contents];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.ph,
            // Section header
            Row(
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
            12.ph,
            // Flat locked lesson list
            ...List.generate(allContents.length, (index) {
              final item = allContents[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: GestureDetector(
                  onTap: () {
                    if (!item.isContentFree) {
                      _enrolNowDialog(context, ref);
                      return;
                    }
                    // Free content — play it
                    if (item.type == FileSystem.video.name &&
                        (item.mediaLink != null &&
                            item.mediaLink!.isNotEmpty)) {
                      ref.read(courseController.notifier).setCurrentPlay(
                            CurrentPlay(
                              fileName: item.title,
                              fileSystem: FileSystem.iframe.name,
                              id: item.id,
                              fileLink: item.mediaLink,
                            ),
                          );
                    } else {
                      ref.read(courseController.notifier).setCurrentPlay(
                            CurrentPlay(
                              fileName: item.title,
                              fileSystem: item.type,
                              id: item.id,
                              fileLink: item.media,
                            ),
                          );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: context.color.surface,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: colors(context).borderColor ??
                            Colors.transparent,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Numbered badge
                        Container(
                          width: 34.h,
                          height: 34.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors(context)
                                .hintTextColor!
                                .withOpacity(.12),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: colors(context).hintTextColor,
                              ),
                            ),
                          ),
                        ),
                        10.pw,
                        // Title + type + duration
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: AppTextStyle(context)
                                    .bodyTextSmall
                                    .copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              4.ph,
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    ApGlobalFunctions.getFileIcon(item.type),
                                    height: 11.h,
                                    width: 11.h,
                                    color: colors(context).hintTextColor,
                                  ),
                                  4.pw,
                                  Text(
                                    item.type == FileSystem.video.name
                                        ? 'Video'
                                        : item.type == FileSystem.audio.name
                                            ? 'Audio'
                                            : item.type ==
                                                    FileSystem.document.name
                                                ? 'Document'
                                                : 'Content',
                                    style: AppTextStyle(context)
                                        .bodyTextSmall
                                        .copyWith(
                                          fontSize: 10.sp,
                                          color: colors(context).hintTextColor,
                                        ),
                                  ),
                                  if (item.duration != null) ...[
                                    6.pw,
                                    Icon(Icons.access_time_rounded,
                                        size: 11.h,
                                        color: colors(context).hintTextColor),
                                    3.pw,
                                    Text(
                                      '${item.duration} min',
                                      style: AppTextStyle(context)
                                          .bodyTextSmall
                                          .copyWith(
                                            fontSize: 10.sp,
                                            color: colors(context).hintTextColor,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        8.pw,
                        // Lock icon (or free play hint)
                        Icon(
                          item.isContentFree
                              ? Icons.play_circle_outline_rounded
                              : Icons.lock_rounded,
                          size: 20.h,
                          color: item.isContentFree
                              ? colors(context).primaryColor
                              : colors(context)
                                  .hintTextColor!
                                  .withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            20.ph,
          ],
        ),
      ),
    );
  }

  void _enrolNowDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: context.color.surface,
        shadowColor: context.color.surface,
        backgroundColor: context.color.surface,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.w))),
        content: Container(
          width: MediaQuery.of(context).size.width - 30.h,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).enrolDes,
                textAlign: TextAlign.center,
                style: AppTextStyle(context).bodyText.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              20.ph,
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        child: AppOutlineButton(
                      title: S.of(context).cancel,
                      width: double.infinity,
                      buttonColor: context.color.surface,
                      titleColor: AppStaticColor.redColor,
                      textPaddingVertical: 16.h,
                      borderRadius: 12.r,
                      onTap: () => context.nav.pop(),
                    )),
                    12.pw,
                    Expanded(
                      child: AppButton(
                        title: S.of(context).enrolNow,
                        width: double.infinity,
                        titleColor: context.color.surface,
                        textPaddingVertical: 16.h,
                        onTap: () async {
                          context.nav.pop();
                          context.nav.pushNamed(Routes.checkOutScreen,
                              arguments: ref
                                  .read(courseController)
                                  .courseDetails!
                                  .course
                                  .id);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// LessonCard kept for potential future use (chapter accordion grouping).
class LessonCard extends ConsumerStatefulWidget {
  const LessonCard({super.key, required this.model, required this.index});

  final Chapters model;
  final int index;

  @override
  ConsumerState<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends ConsumerState<LessonCard> {
  final isExpand = StateProvider<bool>((ref) {
    return false;
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 12.h),
      decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: AppComponents.defaultBorderRadiusSmall,
          border: Border.all(
              color: ref.watch(isExpand)
                  ? colors(context).primaryColor!.withOpacity(0.4)
                  : Colors.transparent)),
      child: Column(
        children: [
          12.ph,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/ic_lock.svg',
                  width: 12.h,
                  height: 12.h,
                  color: context.color.onSurface,
                ),
                8.pw,
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
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
                onExpansionChanged: (value) =>
                    ref.watch(isExpand.notifier).state = value,
                iconColor: colors(context).hintTextColor,
                collapsedIconColor: colors(context).hintTextColor,
                title: Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.model.title,
                              style: AppTextStyle(context)
                                  .bodyText
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                tilePadding: EdgeInsets.only(right: 12.h),
                children: [
                  ...List.generate(
                      widget.model.contents.length,
                      (index) => LessonItemCard(
                            isBottom: index == widget.model.contents.length - 1
                                ? true
                                : false,
                            model: widget.model.contents[index],
                          )),
                  12.ph
                ]),
          ),
        ],
      ),
    );
  }
}

class LessonItemCard extends ConsumerStatefulWidget {
  const LessonItemCard({
    super.key,
    this.isBottom = false,
    required this.model,
  });

  final bool? isBottom;
  final Contents model;

  @override
  ConsumerState<LessonItemCard> createState() => _LessonItemCardState();
}

class _LessonItemCardState extends ConsumerState<LessonItemCard> {
  final downloadPercentage = StateProvider<String>((ref) {
    return '';
  });
  bool isListening = false;

  @override
  Widget build(BuildContext context) {
    final currentPlayingId =
        ref.watch(courseController.select((value) => value.currentPlay?.id));
    final bool isSelected = currentPlayingId == widget.model.id;
    return GestureDetector(
      onTap: () async {
        if (!widget.model.isContentFree) {
          enrolNowDialog(context: context);
          return;
        }

        if (ref.read(courseController).videoPlayerController != null) {
          if (ref
              .read(courseController)
              .videoPlayerController!
              .value
              .isPlaying) {
            ref.read(courseController).videoPlayerController!.pause();
          }
        }
        if (widget.model.type == FileSystem.document.name) {
          ref.read(courseController.notifier).setCurrentPlay(
                CurrentPlay(
                  fileName: widget.model.fileExtension == 'pdf'
                      ? ref.read(courseController).courseDetails?.course.title
                      : widget.model.title,
                  fileSystem: widget.model.type,
                  id: widget.model.id,
                  fileLink: ref
                      .read(courseController)
                      .courseDetails
                      ?.course
                      .thumbnail,
                ),
              );

          if (widget.model.fileExtension == 'pdf') {
            bool isContentDownloaded = await ref
                .read(myCourseDetailsController.notifier)
                .isContentDownloaded(id: widget.model.id);
            if (isContentDownloaded) {
              await ref
                  .read(myCourseDetailsController.notifier)
                  .getHiveContent(id: widget.model.id)
                  .then((value) {
                if (value != null) {
                  if (widget.model.mediaUpdatedAt == value.uniqueNumber) {
                    if (context.mounted) {
                      context.nav.pushNamed(Routes.pdfScreen, arguments: {
                        'id': widget.model.id,
                        'title': widget.model.fileNameWithExtension
                      });
                    }
                  } else {
                    showBottomWidget(makeUpdate: true);
                  }
                }
              });
            } else {
              showBottomWidget();
            }
          } else {
            loadWebByUrl(widget.model.media);
          }
        } else {
          if (widget.model.type == FileSystem.video.name &&
              (widget.model.mediaLink != null &&
                  widget.model.mediaLink!.isNotEmpty)) {
            ref.read(courseController.notifier).setCurrentPlay(
                  CurrentPlay(
                    fileName: widget.model.title,
                    fileSystem: FileSystem.iframe.name,
                    id: widget.model.id,
                    fileLink: widget.model.mediaLink,
                  ),
                );
          } else {
            ref.read(courseController.notifier).setCurrentPlay(
                  CurrentPlay(
                    fileName: widget.model.title,
                    fileSystem: widget.model.type,
                    id: widget.model.id,
                    fileLink: widget.model.media,
                  ),
                );
          }
          // if (widget.model.type == FileSystem.video.name &&
          //     (widget.model.mediaLink == null ||
          //         widget.model.mediaLink!.isEmpty)) {

          // } else {
          //   ref.read(courseController.notifier).setCurrentPlay(CurrentPlay(
          //         fileName: widget.model.title,
          //         fileSystem: FileSystem.iframe.name,
          //         id: widget.model.id,
          //         fileLink: widget.model.mediaLink,
          //       ));
          // }
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: widget.isBottom! ? 0 : 8.h),
        child: Container(
          decoration: BoxDecoration(
              color: isSelected ? context.color.primary.withOpacity(.2) : null,
              border: Border(
                  bottom: widget.isBottom!
                      ? BorderSide.none
                      : BorderSide(
                          color: colors(context).hintTextColor!.withOpacity(.2),
                        ))),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: widget.isBottom! ? 0 : 8.h, left: 12.h, right: 12.h),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.h),
                    color: colors(context).hintTextColor!.withOpacity(.1),
                  ),
                  padding: EdgeInsets.all(6.h),
                  child: SvgPicture.asset(
                    ApGlobalFunctions.getFileIcon(widget.model.type),
                    height: 16.h,
                    width: 16.h,
                    color: context.color.inverseSurface,
                  ),
                ),
                12.pw,
                Expanded(
                  child: Text(
                    widget.model.title,
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(fontSize: 12.sp),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  enrolNowDialog({
    required BuildContext context,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        surfaceTintColor: context.color.surface,
        shadowColor: context.color.surface,
        backgroundColor: context.color.surface,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.w))),
        content: Container(
          width: MediaQuery.of(context).size.width - 30.h,
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).enrolDes,
                textAlign: TextAlign.center,
                style: AppTextStyle(context).bodyText.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              20.ph,
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        child: AppOutlineButton(
                      title: S.of(context).cancel,
                      width: double.infinity,
                      buttonColor: context.color.surface,
                      titleColor: AppStaticColor.redColor,
                      textPaddingVertical: 16.h,
                      borderRadius: 12.r,
                      onTap: () => context.nav.pop(),
                    )),
                    12.pw,
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, _) {
                          return AppButton(
                            title: S.of(context).enrolNow,
                            width: double.infinity,
                            titleColor: context.color.surface,
                            textPaddingVertical: 16.h,
                            onTap: () async {
                              context.nav.pop();
                              context.nav.pushNamed(Routes.checkOutScreen,
                                  arguments: ref
                                      .read(courseController)
                                      .courseDetails!
                                      .course
                                      .id);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showBottomWidget({bool makeUpdate = false}) {
    ApGlobalFunctions.showBottomSheet(
        context: context,
        widget: ContentDetailBottomWidget(
          model: widget.model,
          closeSheet: () {
            context.nav.pop();
          },
          onTap: () {
            downloadFile(model: widget.model, makeUpdate: makeUpdate);
          },
          downloadPercentage: downloadPercentage,
        ));
  }

  Future<void> downloadFile(
      {required Contents model, bool makeUpdate = false}) async {
    Dio dio = Dio();
    if (mounted) {
      ref.read(myCourseDetailsController.notifier).downloadLoading(true);
    }
    try {
      Response response = await dio.get(
        model.media,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      Uint8List pdfBytes = response.data;
      if (makeUpdate) {
        await ref.read(myCourseDetailsController.notifier).updateHiveContent(
            HiveCartModel(
                id: model.id,
                fileExtension: model.fileExtension,
                data: pdfBytes,
                uniqueNumber: model.mediaUpdatedAt,
                fileName: model.title));
      } else {
        await ref.read(myCourseDetailsController.notifier).addContentToHive(
            HiveCartModel(
                id: model.id,
                fileExtension: model.fileExtension,
                data: pdfBytes,
                uniqueNumber: model.mediaUpdatedAt,
                fileName: model.title));
      }

      if (mounted) {
        ref.read(myCourseDetailsController.notifier).downloadLoading(false);
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        context.nav.pushNamed(Routes.pdfScreen,
            arguments: {'id': model.id, 'title': model.title});
      });
    } catch (e) {
      EasyLoading.showError('File download fail');
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      if (mounted) {
        ref.read(downloadPercentage.notifier).state =
            (received / total * 100).toStringAsFixed(0) + "%";
      }
    }
  }

  Future loadWebByUrl(String url) async {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).colorScheme.surface)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    await showDialog(
      context: context,
      builder: (context) => WebViewWidget(controller: controller),
    );
  }
}
