import 'package:flutter/material.dart';
import 'package:ExiirEV/Core/Functions/helper.dart';
import 'package:sizer_pro/sizer.dart';

class DropDownbutton extends StatelessWidget {
  final double currentSearchPercent;
  final double currentExplorePercent;
  final double bottom;
  final double width;
  final double height;
  final IconData icon;
  final Color? iconColor;
  final bool isRight;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double offsetX;

  const DropDownbutton({
    Key? key,
    required this.currentSearchPercent,
    required this.currentExplorePercent,
    required this.bottom,
    required this.width,
        required this.offsetX,

    required this.height,
    required this.icon,
    this.iconColor,
    this.isRight = true,
    this.gradient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.only(
        bottom: realH(bottom),
            left: !isRight
          ? realW(offsetX * (currentExplorePercent + currentSearchPercent))
          :  0.0,
      right: isRight
          ? realW(offsetX * (currentExplorePercent + currentSearchPercent))
          :  0.0,
      ),
      
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: gradient == null ? Colors.white : null,
        gradient: gradient,
        borderRadius: isRight
            ? BorderRadius.only(
                bottomLeft: Radius.circular(36.0.w),
                topLeft: Radius.circular(36.0.w),
              )
            : BorderRadius.only(
                bottomRight: Radius.circular(36.0.w),
                topRight: Radius.circular(36.0.w),
              ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.3),
            blurRadius: 36.0.w,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 3.0.w),
          child: Icon(
            icon,
            size: 8.0.w,
            color: iconColor ?? Colors.black,
          ),
        ),
      ),
    );
  }
}
