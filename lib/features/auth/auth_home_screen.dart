import 'package:ready_lms/components/app_logo_widget.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/features/auth/widget/login_bottom_widget.dart';
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
  void initState() {
    // _scrollAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.read(hiveStorageProvider).getTheme();

    return Scaffold(
      backgroundColor: context.color.surface,
      // ── AppBar: compact logo fits inside standard 56 dp toolbar ──────────
      appBar: AppBar(
        title: AppLogoWidget(
          compact: true,
          isDark: isDark,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            // ── Welcome illustration ────────────────────────────────────────
            Expanded(
              flex: 6,
              child: Image.asset(
                'assets/images/auth_welcome_avt.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            ),

            // ── Bottom section: description + buttons ───────────────────────
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  // Space text at top, buttons at bottom — no overflow.
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description text + highlighted app name
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${S.of(context).authHomeDes} ',
                                style: AppTextStyle(context).title,
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
                                            ? (AppConstants.appName.length +
                                                    1) *
                                                16.w
                                            : (AppConstants.appName.length +
                                                    1) *
                                                14.w, // slightly tighter for longer names
                                        height: 11.h,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: Text(
                                        '${AppConstants.appName}.',
                                        style: AppTextStyle(context).title,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Buttons pinned to the bottom
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppButton(
                            title: S.of(context).getStarted,
                            titleColor: context.color.surface,
                            textPaddingVertical: 15.h,
                            onTap: () {
                              ref
                                  .read(hiveStorageProvider)
                                  .setFirstOpenValue(value: false);
                              context.nav.pushNamedAndRemoveUntil(
                                  Routes.dashboard, (route) => false);
                            },
                            icon: SvgPicture.asset(
                              'assets/svg/ic_right_arrow.svg',
                              color: context.color.surface,
                              width: 24.h,
                              height: 24.h,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          AppOutlineButton(
                            title: S.of(context).loginWithPassword,
                            borderRadius: 12.r,
                            onTap: () {
                              ApGlobalFunctions.showBottomSheet(
                                  context: context,
                                  widget: const LoginBottomWidget());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
