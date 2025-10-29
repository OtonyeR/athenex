import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOutlineButton extends StatelessWidget {
  final String buttonText;
  final bool showIcon;
  final void Function() action;
  final IconData? icon;

  const CustomOutlineButton({
    super.key,
    required this.buttonText,
    required this.action,
    required this.showIcon,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white,
          border: Border.all(width: 0.7, color: Colors.black),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: showIcon,
                child: Icon(icon, color: Colors.black, size: 17.w),
              ),
              SizedBox(width: 12.w),
              Text(
                buttonText.toUpperCase(),
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
