import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NairaText extends StatelessWidget {
  final double amount;
  final TextStyle? style;
  final bool showKobo;

  const NairaText({
    super.key,
    required this.amount,
    this.style,
    this.showKobo = true,
  });

  @override
  Widget build(BuildContext context) {
    final format = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: showKobo ? 2 : 0,
    );

    return Text(
      format.format(amount),
      overflow: TextOverflow.ellipsis,
      style: style ??
           TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
    );
  }
}
