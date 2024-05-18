import 'package:flutter/material.dart';

import 'consts.dart';
import 'plain_text.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Widget? widget;
  final double fontsize;
  final double radius;
  final double? leftWidth;
  final double? rightWidth;
  final VoidCallback onTap;
  final Color buttonColor;
  final Color textColor;
  final Color borderColor;
  final Color iconColor;
  final IconData? iconsDataLeft;
  final IconData? iconsDataRight;
  final double borderWidth;
  final double? buttonHeight;
  final double? buttonWidth;

  const RoundedButton({
    super.key,
    required this.title,
    required this.onTap,
    this.buttonColor = const Color(0xFF2c2e58),
    this.textColor = Colors.white,
    this.iconColor = Colors.black,
    this.borderColor = Colors.white,
    this.iconsDataLeft,
    this.iconsDataRight,
    this.radius = 10,
    this.fontsize = 16,
    this.leftWidth,
    this.widget,
    this.rightWidth,
    this.borderWidth = 0,
    this.buttonHeight = 50,
    this.buttonWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        height: buttonHeight,
        width: buttonWidth,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: [
            BoxShadow(
              color: greyColor,
              blurRadius: 7,
              spreadRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconsDataLeft != null) Icon(iconsDataLeft, color: iconColor),
              if (leftWidth != null) SizedBox(width: leftWidth),
              PlainText(
                name: title,
                fontsize: fontsize,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              if (rightWidth != null) SizedBox(width: rightWidth),
              if (iconsDataRight != null)
                Icon(iconsDataRight, color: iconColor),
              if (widget != null) widget!,
            ],
          ),
        ),
      ),
    );
  }
}
