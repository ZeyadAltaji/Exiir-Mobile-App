import 'package:flutter/material.dart';
import 'package:ExiirEV/Core/Functions/helper.dart';
import 'package:sizer_pro/sizer.dart';

class SearchWidget extends StatelessWidget {
  final double? currentExplorePercent;

  final double? currentSearchPercent;

  final Function(bool)? animateSearch;

  final bool? isSearchOpen;

  final Function(DragUpdateDetails)? onHorizontalDragUpdate;

  final Function()? onPanDown;
  final double offsetX;

  const SearchWidget(
      {Key? key,
      this.currentExplorePercent,
      this.currentSearchPercent,
      this.animateSearch,
      this.isSearchOpen,
      required this.offsetX,
      this.onHorizontalDragUpdate,
      this.onPanDown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 26.0.h,
      right: realW((68.0 - offsetX) -
          (offsetX * currentExplorePercent!) +
          (347 - offsetX-500) * currentSearchPercent!),
      child: GestureDetector(
        onTap: () {
          animateSearch!(!isSearchOpen!);
        },
        onPanDown: (_) => onPanDown,
        onHorizontalDragUpdate: onHorizontalDragUpdate,
        onHorizontalDragEnd: (_) {
          _dispatchSearchOffset();
        },
        child: Container(
          width: 21.0.w,
          height: 10.0.h,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 3.0.w),
          child: Opacity(
            opacity: 1.0 - currentSearchPercent!,
            child: Icon(
              Icons.search,
              size: 10.0.w,
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36.0.w),
                topLeft: Radius.circular(36.0.w),
              ),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: realW(36)),
              ]),
        ),
      ),
    );
  }

  /// dispatch Search state
  ///
  /// handle it by [isSearchOpen] and [currentSearchPercent]
  void _dispatchSearchOffset() {
    if (!isSearchOpen!) {
      if (currentSearchPercent! < 0.3) {
        animateSearch!(false);
      } else {
        animateSearch!(true);
      }
    } else {
      if (currentSearchPercent! > 0.6) {
        animateSearch!(true);
      } else {
        animateSearch!(false);
      }
    }
  }
}
