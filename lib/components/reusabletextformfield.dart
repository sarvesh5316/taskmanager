// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ReusableTextFormField extends StatelessWidget {
  final double? height;
  final String? labelText;
  final String? hintText;
  final InputBorder? border;
  final TextEditingController controller;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool obscureText;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final Color? hintTextColor;
  final Color? labelTextColor;
  final VoidCallback? ontap;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool readOnly;

  const ReusableTextFormField({
    super.key,
    this.labelText,
    this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.hintTextColor = Colors.black,
    this.border,
    this.floatingLabelBehavior,
    this.labelTextColor,
    this.ontap,
    this.maxLines,
    this.prefix,
    this.contentPadding = const EdgeInsets.only(left: 10),
    this.maxLength,
    this.suffix,
    this.suffixIcon,
    this.height = 60,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        style: TextStyle(fontWeight: FontWeight.w500),
        onTap: ontap,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        readOnly: readOnly,
        decoration: InputDecoration(
            floatingLabelBehavior: floatingLabelBehavior,
            labelText: labelText,
            hintText: hintText,
            prefixIcon: prefix,
            suffix: suffix,
            suffixIcon: suffixIcon,
            labelStyle: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
              color: labelTextColor,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: TextStyle(
              fontFamily: 'Times New Roman',
              fontSize: 14,
              color: hintTextColor,
              fontWeight: FontWeight.w500,
            ),
            border: border,
            focusedBorder: border,
            disabledBorder: border,
            contentPadding: contentPadding
            // Use padding property instead of contentPadding
            ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}
