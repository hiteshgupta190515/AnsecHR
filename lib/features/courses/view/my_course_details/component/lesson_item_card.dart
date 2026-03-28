// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/custom_dot.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/courses/model/course_detail.dart';
import 'package:ready_lms/features/courses/model/current_class.dart';
import 'package:ready_lms/features/check_out/model/hive_cart_model.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../controller/my_course_details.dart';
import 'content_details_bottom_widget.dart';

// TODO: We need to implement this to the
class LessonItemCard extends ConsumerStatefulWidget {
  const LessonItemCard({
    super.key,
    this.isBottom = false,
    required this.model,
    required this.isActive,
    this.lessonNumber = 0,
  });
  final bool? isBottom;
  final Contents model;
  final bool isActive;
  final int lessonNumber;
  @override
  ConsumerState<LessonItemCard> createState() => _LessonItemCardState();
}

class _LessonItemCardState extends ConsumerState<LessonItemCard> {
  final isViewContent = StateProvider<bool>((ref) {
    return false;
  });
  final downloadPercentage = StateProvider<String>((ref) {
    return '';
  });
  bool isListening = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(isViewContent.notifier).state = widget.model.isViewed;
    });
  }

  void checkForViewRequest() {
    if (!ref.watch(isViewContent) && widget.isActive) {
      if (widget.model.type == FileSystem.video.name ||
          widget.model.type == FileSystem.audio.name) {
        var videoPlayerController =
            ref.watch(myCourseDetailsController).videoPlayerController;
        if (videoPlayerController != null) {
          ref
              .read(myCourseDetailsController)
              .videoPlayerController!
              .addListener(() {
            isListening = true;
            if (videoPlayerController.value.position >=
                videoPlayerController.value.duration) {
              makeContentView();
            }
          });
        }
      } else if (widget.model.type == FileSystem.document.name) {
      } else {
        makeContentView();
      }
    }
  }

  makeContentView() {
    ref
        .read(myCourseDetailsController.notifier)
        .makeContentView(widget.model.id)
        .then((value) {
      if (value.isSuccess) {
        if (mounted) ref.read(isViewContent.notifier).state = value.response;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isViewContent = ref.watch(this.isViewContent);
    if (!isListening) {
      checkForViewRequest();
    }

    return GestureDetector(
      onTap: () async {
        if (ref.read(myCourseDetailsController).videoPlayerController !=
            null) {
          if (ref
              .read(myCourseDetailsController)
              .videoPlayerController!
              .value
              .isPlaying) {
            ref
                .read(myCourseDetailsController)
                .videoPlayerController!
                .pause();
          }
        }
        if (widget.model.type == FileSystem.document.name) {
          ref
              .read(myCourseDetailsController.notifier)
              .setCurrentPlay(CurrentPlay(
                fileName: widget.model.fileExtension == 'pdf'
                    ? ref
                        .read(myCourseDetailsController)
                        .courseDetails
                        ?.course
                        .title
                    : widget.model.title,
                fileSystem: widget.model.type,
                id: widget.model.id,
                fileLink: ref
                    .read(myCourseDetailsController)
                    .courseDetails
                    ?.course
                    .thumbnail,
              ));

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
                    context.nav.pushNamed(Routes.pdfScreen, arguments: {
                      'id': widget.model.id,
                      'title': widget.model.fileNameWithExtension
                    });
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
            ref.read(myCourseDetailsController.notifier).setCurrentPlay(
                  CurrentPlay(
                    fileName: widget.model.title,
                    fileSystem: FileSystem.iframe.name,
                    id: widget.model.id,
                    fileLink: widget.model.mediaLink,
                    contents: widget.model,
                    isViewContent: this.isViewContent,
                  ),
                );
          } else {
            ref.read(myCourseDetailsController.notifier).setCurrentPlay(
                  CurrentPlay(
                    fileName: widget.model.title,
                    fileSystem: widget.model.type,
                    id: widget.model.id,
                    fileLink: widget.model.media,
                  ),
                );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: widget.isActive
              ? context.color.primary.withOpacity(.07)
              : context.color.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: widget.isActive
                ? context.color.primary.withOpacity(0.35)
                : colors(context).borderColor ?? Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            // Lesson number badge
            Container(
              width: 34.h,
              height: 34.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isActive
                    ? context.color.primary
                    : colors(context).hintTextColor!.withOpacity(.12),
              ),
              child: Center(
                child: widget.lessonNumber > 0
                    ? Text(
                        '${widget.lessonNumber}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: widget.isActive
                              ? Colors.white
                              : colors(context).hintTextColor,
                        ),
                      )
                    : SvgPicture.asset(
                        ApGlobalFunctions.getFileIcon(widget.model.type),
                        height: 14.h,
                        width: 14.h,
                        color: widget.isActive
                            ? Colors.white
                            : colors(context).hintTextColor,
                      ),
              ),
            ),
            10.pw,
            // Title + type row
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model.title,
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: widget.isActive
                              ? context.color.primary
                              : null,
                        ),
                  ),
                  4.ph,
                  Row(
                    children: [
                      SvgPicture.asset(
                        ApGlobalFunctions.getFileIcon(widget.model.type),
                        height: 11.h,
                        width: 11.h,
                        color: colors(context).hintTextColor,
                      ),
                      4.pw,
                      Text(
                        widget.model.type == FileSystem.video.name
                            ? 'Video'
                            : widget.model.type == FileSystem.audio.name
                                ? 'Audio'
                                : widget.model.type == FileSystem.document.name
                                    ? 'Document'
                                    : 'Content',
                        style: AppTextStyle(context).bodyTextSmall.copyWith(
                              fontSize: 10.sp,
                              color: colors(context).hintTextColor,
                            ),
                      ),
                      if (widget.model.duration != null) ...[
                        6.pw,
                        Icon(Icons.access_time_rounded,
                            size: 11.h,
                            color: colors(context).hintTextColor),
                        3.pw,
                        Text(
                          '${widget.model.duration} min',
                          style: AppTextStyle(context).bodyTextSmall.copyWith(
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
            // Viewed / playing / unplayed indicator
            if (isViewContent)
              Container(
                padding: EdgeInsets.all(4.h),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.12),
                ),
                child: Icon(Icons.check_rounded,
                    size: 14.h, color: Colors.green),
              )
            else if (widget.isActive)
              Container(
                padding: EdgeInsets.all(6.h),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.color.primary.withOpacity(0.12),
                ),
                child: Icon(Icons.play_arrow_rounded,
                    size: 16.h, color: context.color.primary),
              )
            else
              Icon(
                Icons.play_circle_outline_rounded,
                size: 22.h,
                color: colors(context).hintTextColor!.withOpacity(0.4),
              ),
          ],
        ),
      ),
    );
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
      if (!ref.watch(isViewContent)) {
        makeContentView();
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

  void showDownloadProgress(received, total) {
    if (total != -1) {
      if (mounted) {
        ref.read(downloadPercentage.notifier).state =
            (received / total * 100).toStringAsFixed(0) + "%";
      }
    }
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
}
