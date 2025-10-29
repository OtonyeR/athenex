import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final bool showIcon;
  final void Function() action;

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.showIcon,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,

      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.black,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: showIcon,
                child: Icon(
                  Icons.filter_list_rounded,
                  color: Colors.white,
                  size: 17.w,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                buttonText.toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
