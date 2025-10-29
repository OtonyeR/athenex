import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputField extends StatelessWidget {
  final String inputLabel;
  final String errorText;
  final TextInputType inputType;
  final bool isRequired;
  final String? Function(String?)? isRight;

  const CustomInputField({
    super.key,
    required this.nameController,
    required this.inputLabel,
    required this.errorText,
    required this.inputType,
    required this.isRequired,
    this.isRight,
  });

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 28.h),
        Text(inputLabel.toUpperCase()),
        SizedBox(height: 8.h),
        TextFormField(
          controller: nameController,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: inputLabel,
            hintStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black26, width: 1.4),
              borderRadius: BorderRadius.circular(10.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black26, width: 1.4),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          validator: isRight ?? (isRequired
              ? (val) => val == null || val.isEmpty ? errorText : null
              : null),
        ),
      ],
    );
  }
}
