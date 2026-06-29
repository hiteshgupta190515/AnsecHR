// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../../../generated/l10n.dart';

class SubmitButton extends StatefulWidget {
  final Function(bool) isComplete;
  final Color color;

  const SubmitButton({
    super.key,
    required this.isComplete,
    required this.color,
  });

  @override
  SubmitButtonState createState() => SubmitButtonState();
}

class SubmitButtonState extends State<SubmitButton> {
  final ValueNotifier<double> progressNotifier = ValueNotifier(0.0);
  Timer? _timer;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    progressNotifier.addListener(() {
      setState(() {});
    });
  }

  void _startProgress() {
    _isCompleted = false;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (progressNotifier.value < 1.0) {
        progressNotifier.value += 0.01;
        if (progressNotifier.value >= 1.0) {
          progressNotifier.value = 1.0;
          _stopProgress();
          if (!_isCompleted) {
            _isCompleted = true;
            widget.isComplete(true);
          }
        }
      } else {
        progressNotifier.value = 1.0; // Ensure the final value is 100%
        _stopProgress();
        if (!_isCompleted) {
          _isCompleted = true;
          widget.isComplete(true);
        }
      }
    });
  }

  void _stopProgress() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void deactivate() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) progressNotifier.value = 0.0;
      });
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _stopProgress();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: progressNotifier.value),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return SizedBox(
              width: 110.w,
              height: 110.h,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 7.0,
                color: widget.color,
                backgroundColor: widget.color.withOpacity(0.3),
              ),
            );
          },
        ),
        GestureDetector(
          onTap: () {
            ApGlobalFunctions.showCustomSnackbar(
              message: S.of(context).onceconfidenttapandoldSubmitbuttonbellow,
              isSuccess: false,
            );
          },
          onLongPressStart: (details) => _startProgress(),
          onLongPressEnd: (details) {
            if (progressNotifier.value < 1.0) {
              progressNotifier.value = 0.0;
            }
            _stopProgress();
          },
          onLongPressCancel: () {
            if (progressNotifier.value < 1.0) {
              progressNotifier.value = 0.0;
            }
            _stopProgress();
          },
          child: Container(
            height: 90.h,
            width: 90.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors(context).primaryColor,
            ),
            child: Center(
              child: Text(
                S.of(context).submit,
                style: AppTextStyle(context).bodyText.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppStaticColor.whiteColor,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
