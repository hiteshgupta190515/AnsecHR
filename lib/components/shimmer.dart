import 'package:flutter/material.dart';
import 'package:ready_lms/config/app_color.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppStaticColor.primaryColor,
      ),
    );
  }
}
