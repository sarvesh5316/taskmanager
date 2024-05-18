import 'package:flutter/material.dart';

class BoldText extends StatelessWidget {
  final String name;
  final double fontsize;
  final TextAlign textAlign;
  final TextDecoration? decoration;
  final String fontFamily;
  const BoldText({
    super.key,
    required this.name,
    required this.fontsize,
    this.fontWeight = FontWeight.w700,
    this.color,
    this.textAlign = TextAlign.start,
    this.decoration,
    this.fontFamily = 'Times New Roman',
  });

  final FontWeight? fontWeight;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontsize,
        fontWeight: fontWeight,
        decoration: decoration,
        color: color,
      ),
    );
  }
}
