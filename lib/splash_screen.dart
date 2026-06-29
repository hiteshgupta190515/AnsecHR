import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_lms/components/app_logo_widget.dart';
import 'package:ready_lms/components/offline.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/api_client.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

import 'features/other/controller/others.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ConnectivityWrapper.instance.onStatusChange.listen((event) {
        if (event == ConnectivityStatus.CONNECTED) {
          ref.read(othersController.notifier).getMasterData().then((value) {
            if (!mounted) return;
            final appSettingsBox = Hive.box(AppHSC.appSettingsBox);
            appSettingsBox.put(AppHSC.path, "dashboard");
            if (!ref.read(othersController)) {
              if (ref.read(othersController.notifier).masterModel != null) {
                final isLoggedIn = !ref.read(hiveStorageProvider).isGuest() &&
                    ref.read(hiveStorageProvider).getAuthToken() != null;

                if (isLoggedIn) {
                  ref.read(apiClientProvider).updateToken(
                      token: ref.read(hiveStorageProvider).getAuthToken()!);
                }

                context.nav.pushNamedAndRemoveUntil(
                    isLoggedIn ? Routes.dashboard : Routes.authHomeScreen,
                    (route) => false);
              }
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWidgetWrapper(
      offlineWidget: const OfflineScreen(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: AppLogoWidget(
            isDark: ref.read(hiveStorageProvider).getTheme(),
          ),
        ),
      ),
    );
  }
}
