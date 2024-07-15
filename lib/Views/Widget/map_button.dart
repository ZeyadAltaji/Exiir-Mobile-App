import 'package:ExiirEV/Core/Functions/helper.dart';
import 'package:flutter/material.dart';
import 'package:sizer_pro/sizer.dart';

class MapButton extends StatelessWidget {
  final double currentSearchPercent;
  final double currentExplorePercent;

  final double bottom;
  final double offsetX;
  final double width;
  final double height;

  final IconData icon;
  final Color? iconColor;
  final bool isRight;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const MapButton({
    Key? key,
    required this.currentSearchPercent,
    required this.currentExplorePercent,
    required this.bottom,
    required this.offsetX,
    required this.width,
    required this.height,
    required this.icon,
    this.iconColor,
    this.isRight = true,
    this.gradient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: realH(bottom),
      left: !isRight
          ? realW(offsetX * (currentExplorePercent + currentSearchPercent))
          : null,
      right: isRight
          ? realW(offsetX * (currentExplorePercent + currentSearchPercent))
          : null,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.centerLeft,
          padding: isRight ? EdgeInsets.only(left:  6.0.w) :  EdgeInsets.only(left:  3.0.w) ,
          child: Icon(
            icon,
            size: 10.0.w,
            color: iconColor ?? Colors.black,
          ),
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
        ),
      ),
    );
  }
}
