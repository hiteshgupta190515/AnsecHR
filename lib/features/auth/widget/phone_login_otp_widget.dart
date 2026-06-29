import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/features/auth/widget/pin_put.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../controller/auth.dart';
import 'login_bottom_widget.dart';

class PhoneLoginOtpWidget extends ConsumerStatefulWidget {
  const PhoneLoginOtpWidget({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<PhoneLoginOtpWidget> createState() =>
      _PhoneLoginOtpWidgetState();
}

class _PhoneLoginOtpWidgetState extends ConsumerState<PhoneLoginOtpWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController pinController = TextEditingController();

  // Resend becomes available after 60 s
  static const int _resendSeconds = 60;
  final _countdown = StateProvider<int>((ref) => _resendSeconds);
  final _resending = StateProvider<bool>((ref) => false);

  Timer? _timer;
  bool _isPinComplete = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Rebuild when pin changes so the Verify button enables/disables reactively
    pinController.addListener(() {
      final complete = pinController.text.length == 6;
      if (complete != _isPinComplete) {
        setState(() => _isPinComplete = complete);
      }
      // Clear error when user starts typing again
      if (_errorMessage != null && pinController.text.isNotEmpty) {
        setState(() => _errorMessage = null);
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      final current = ref.read(_countdown);
      if (current <= 0) {
        t.cancel();
      } else {
        ref.read(_countdown.notifier).state = current - 1;
      }
    });
  }

  Future<void> _verifyOtp(
      BuildContext context, String path, dynamic appSettingBox) async {
    if (pinController.text.length != 6) return;

    final res = await ref.read(authController.notifier).verifyLoginOtp(
          phone: widget.phone,
          otp: pinController.text,
        );

    // Guard against using context after the widget has been disposed
    if (!mounted) return;

    if (res.isSuccess) {
      EasyLoading.showSuccess('Login successful!');
      ref.read(hiveStorageProvider).setFirstOpenValue(value: false);
      if (path == 'checkout') {
        appSettingBox.put(AppHSC.path, 'dashboard');
        Navigator.pop(context, true);
      } else {
        context.nav.pushNamedAndRemoveUntil(Routes.dashboard, (r) => false);
      }
    } else {
      // Clear the pin so user can re-enter
      pinController.clear();
      setState(() => _errorMessage = res.message);
    }
  }

  Future<void> _resendOtp() async {
    ref.read(_resending.notifier).state = true;
    final res = await ref
        .read(authController.notifier)
        .sendLoginOtp(phone: widget.phone);
    ref.read(_resending.notifier).state = false;

    if (res.isSuccess) {
      pinController.clear();
      ref.read(_countdown.notifier).state = _resendSeconds;
      _startTimer();
      EasyLoading.showSuccess('OTP resent successfully.');
    } else {
      EasyLoading.showError(res.message);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appSettingBox = Hive.box(AppHSC.appSettingsBox);
    final path = appSettingBox.get(AppHSC.path, defaultValue: 'dashboard');

    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      width: double.infinity,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with edit (go back to phone entry)
                BottomBarHeader(
                  onTap: () => context.nav.pop(),
                  onTapEdit: () {
                    context.nav.pop();
                    ApGlobalFunctions.showBottomSheet(
                      context: context,
                      widget: const LoginBottomWidget(),
                    );
                  },
                  title: 'Enter OTP',
                  body:
                      'We sent a 6-digit OTP to ${widget.phone}. It expires in 3 minutes.',
                ),

                32.ph,

                // 6-digit pin input
                FractionallySizedBox(
                  widthFactor: 1,
                  child: PinPutWidget(
                    length: 6,
                    pinCodeController: pinController,
                    onCompleted: (_) => _verifyOtp(context, path, appSettingBox),
                    validator: (_) => null,
                  ),
                ),

                // Inline error message
                if (_errorMessage != null) ...[
                  8.ph,
                  Center(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                24.ph,

                // Verify OTP button
                Consumer(builder: (context, ref, _) {
                  final isLoading = ref.watch(authController) &&
                      !ref.watch(_resending);

                  return AppButton(
                    title: 'Verify OTP',
                    textPaddingVertical: 16.h,
                    titleColor: context.color.surface,
                    showLoading: isLoading,
                    onTap: _isPinComplete
                        ? () => _verifyOtp(context, path, appSettingBox)
                        : null,
                  );
                }),

                24.ph,

                // Countdown / Resend
                Consumer(builder: (context, ref, _) {
                  final seconds = ref.watch(_countdown);
                  final resending = ref.watch(_resending);

                  if (resending) {
                    return Center(
                      child: SizedBox(
                        width: 18.h,
                        height: 18.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              context.color.primary),
                        ),
                      ),
                    );
                  }

                  if (seconds > 0) {
                    return Center(
                      child: Text(
                        'Resend OTP in 00:${seconds.toString().padLeft(2, '0')} sec',
                        style: AppTextStyle(context)
                            .bodyTextSmall
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return Center(
                    child: GestureDetector(
                      onTap: _resendOtp,
                      child: Text(
                        'Resend OTP',
                        style: AppTextStyle(context).bodyTextSmall.copyWith(
                              color: context.color.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: context.color.primary,
                            ),
                      ),
                    ),
                  );
                }),

                16.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
