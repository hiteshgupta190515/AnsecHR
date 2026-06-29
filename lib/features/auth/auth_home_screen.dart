import 'package:ready_lms/components/app_logo_widget.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/auth/widget/login_bottom_widget.dart';
import 'package:ready_lms/features/auth/widget/registration_bottom_widget.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AuthHomeScreen extends ConsumerStatefulWidget {
  const AuthHomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthHomeScreenScreenState();
}

class _AuthHomeScreenScreenState extends ConsumerState<AuthHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.read(hiveStorageProvider).getTheme();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: context.color.surface,
      appBar: AppBar(
        title: AppLogoWidget(compact: true, isDark: isDark),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Illustration — max 35% of screen height ──────────────
                Center(
                  child: Image.asset(
                    'assets/images/auth_welcome_avt.png',
                    height: screenHeight * 0.32,
                    fit: BoxFit.contain,
                  ),
                ),

                12.ph,

                // ── Description text ─────────────────────────────────────
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${S.of(context).authHomeDes} ',
                        style: AppTextStyle(context).title.copyWith(
                              fontSize: 18.sp,
                            ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2.w),
                              child: Container(
                                color: colors(context)
                                    .primaryColor!
                                    .withOpacity(.3),
                                width: AppConstants.appName.length < 7
                                    ? (AppConstants.appName.length + 1) * 14.w
                                    : (AppConstants.appName.length + 1) * 12.w,
                                height: 10.h,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Text(
                                '${AppConstants.appName}.',
                                style: AppTextStyle(context).title.copyWith(
                                      fontSize: 18.sp,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                24.ph,

                // ── Login button ─────────────────────────────────────────
                AppButton(
                  title: 'Login with Phone',
                  titleColor: context.color.surface,
                  textPaddingVertical: 14.h,
                  onTap: () {
                    ApGlobalFunctions.showBottomSheet(
                        context: context,
                        widget: const LoginBottomWidget());
                  },
                  icon: SvgPicture.asset(
                    'assets/svg/ic_right_arrow.svg',
                    color: context.color.surface,
                    width: 20.h,
                    height: 20.h,
                  ),
                ),

                12.ph,

                // ── Sign up button ───────────────────────────────────────
                AppOutlineButton(
                  title: 'Create an Account',
                  borderRadius: 12.r,
                  onTap: () {
                    ApGlobalFunctions.showBottomSheet(
                        context: context,
                        widget: const RegistrationBottomWidget());
                  },
                ),

                // 16.ph,
                //
                // // ── Guest link ───────────────────────────────────────────
                // GestureDetector(
                //   onTap: () {
                //     context.nav.pushNamedAndRemoveUntil(
                //         Routes.dashboard, (route) => false);
                //   },
                //   child: Center(
                //     child: Text(
                //       'Continue as Guest',
                //       style: AppTextStyle(context).bodyTextSmall.copyWith(
                //             color: context.color.primary,
                //             decoration: TextDecoration.underline,
                //             decorationColor: context.color.primary,
                //           ),
                //     ),
                //   ),
                // ),

                24.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
