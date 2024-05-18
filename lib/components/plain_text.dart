import 'package:flutter/material.dart';

class PlainText extends StatelessWidget {
  final String name;
  final TextAlign textAlign;
  final double fontsize;
  final FontWeight fontWeight;
  final Color? color;
  final int? maxLines;
  final TextDecoration? decoration;
  final String? fontFamily;

  const PlainText({
    super.key,
    required this.name,
    required this.fontsize,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.black,
    this.textAlign = TextAlign.start,
    this.maxLines = 3,
    this.decoration,
    this.fontFamily = 'Times New Roman',
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontsize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
