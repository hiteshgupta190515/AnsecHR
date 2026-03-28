import 'package:ready_lms/features/check_out/widget/payment_scection.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'coupon.dart';
import 'course_Info.dart';
import 'order_summary_card.dart';

class Body extends ConsumerStatefulWidget {
  const Body({super.key});

  @override
  ConsumerState<Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          12.ph,
          const CourseInfo(),
          8.ph,
          const OrderSummaryCard(),
          8.ph,
          const CouponCard(),
          8.ph,
          const PaymentSection(),
          8.ph,
        ],
      ),
    );
  }
}
