import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/features/auth/widget/phone_login_otp_widget.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../controller/auth.dart';

class LoginBottomWidget extends StatefulWidget {
  const LoginBottomWidget({super.key});

  @override
  State<LoginBottomWidget> createState() => _LoginBottomWidgetState();
}

class _LoginBottomWidgetState extends State<LoginBottomWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                BottomBarHeader(
                  onTap: () => context.nav.pop(),
                  title: 'Login with Phone',
                  body:
                      'Enter your registered mobile number to receive an OTP.',
                ),
                32.ph,

                // Mobile number field
                CustomFormWidget(
                  label: 'Mobile Number',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Mobile number is required';
                    }
                    if (val.trim().length < 10) {
                      return 'Enter a valid mobile number';
                    }
                    return null;
                  },
                ),

                32.ph,

                // Send OTP button
                Consumer(builder: (context, ref, _) {
                  return AppButton(
                    title: 'Send OTP',
                    textPaddingVertical: 16.h,
                    titleColor: context.color.surface,
                    showLoading: ref.watch(authController),
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        final phone = phoneController.text.trim();
                        final res = await ref
                            .read(authController.notifier)
                            .sendLoginOtp(phone: phone);

                        if (res.isSuccess) {
                          context.nav.pop();
                          ApGlobalFunctions.showBottomSheet(
                            context: context,
                            widget: PhoneLoginOtpWidget(phone: phone),
                          );
                        } else {
                          EasyLoading.showError(res.message);
                        }
                      }
                    },
                  );
                }),

                24.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
