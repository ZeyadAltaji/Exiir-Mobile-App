import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Core/Functions/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreWidget extends StatelessWidget {
  final double? currentSearchPercent;
  final double? currentExplorePercent;
  final Function(bool)? animateExplore;
  final Function(DragUpdateDetails)? onVerticalDragUpdate;
  final Function()? onPanDown;
  final bool? isExploreOpen;

  const ExploreWidget(
      {Key? key,
      this.currentSearchPercent,
      this.currentExplorePercent,
      this.animateExplore,
      this.isExploreOpen,
      this.onVerticalDragUpdate,
      this.onPanDown})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TranslationController translationController =
        Get.put(TranslationController());

    return Positioned(
      
      bottom: realH(-122 * currentSearchPercent!),
      left: Get.locale!.languageCode == 'ar'
          ? null
          : (screenWidth -
                  realW(380 + (standardWidth - 159) * currentExplorePercent!)) /
              2,
      right: Get.locale!.languageCode == 'ar'
          ? (screenWidth -
                  realW(380 + (standardWidth - 159) * currentExplorePercent!)) /
              2
          : null,
      child: GestureDetector(
        onTap: () {
          animateExplore!(!isExploreOpen!);
        },
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: (_) {
          _dispatchExploreOffset();
        },
        onPanDown: (_) => onPanDown!(),
        child: Opacity(
          opacity: 1 - currentSearchPercent!,
          child: Container(
            constraints: BoxConstraints(maxHeight: 980),
              alignment: Alignment.bottomCenter,
              width: Get.locale!.languageCode == 'ar'
                  ? realW(380 + (standardWidth - 159) * currentExplorePercent!)
                  : realW(380 + (standardWidth - 159) * currentExplorePercent!),
              height: realH(122 + (500 - 122) * currentExplorePercent!),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Appcolors.logotwo,
                    Appcolors.logoone,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(realW(70 + (50 - 80))),
                  topRight: Radius.circular(realW(70 + (50 - 80))),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                        realW(80 + (50 - 80) * currentExplorePercent!)),
                    topRight: Radius.circular(
                        realW(80 + (50 - 80) * currentExplorePercent!)),
                  ),
                  color: Colors.transparent,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: realH(65 + (-5 * currentExplorePercent!)),
                      left: Get.locale!.languageCode == 'ar'
                          ? null
                          : realW(120 + (91 - 49) * currentExplorePercent!),
                      right: Get.locale!.languageCode == 'ar'
                          ? realW(145 + (91 - 49) * currentExplorePercent!)
                          : null,
                      child: Text(
                        translationController.getLanguage(89),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              realW(18 + (32 - 18) * currentExplorePercent!),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      top: realH(20 + (60 - 20) * currentExplorePercent!),
                      left: Get.locale!.languageCode == 'ar'
                          ? null
                          : realW(170 + (44 - 63) * currentExplorePercent!),
                      right: Get.locale!.languageCode == 'ar'
                          ? realW(170 + (44 - 63) * currentExplorePercent!)
                          : null,
                      child: Icon(
                        Icons.location_on,
                        size: realW(34),
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      top: realH(currentExplorePercent! < 0.9
                          ? realH(-35)
                          : realH(-35 +
                              (6 + 35) * (currentExplorePercent! - 0.9) * 8)),
                      left: Get.locale!.languageCode == 'ar'
                          ? null
                          : realW(170 + (170 - 63) * currentExplorePercent!),
                      right: Get.locale!.languageCode == 'ar'
                          ? realW(170 + (170 - 63) * currentExplorePercent!)
                          : null,
                      child: GestureDetector(
                        onTap: () {
                          animateExplore!(false);
                        },
                        child: Image.asset(
                          AppimageUrlAsset.arrow,
                          width: realH(35),
                          height: realH(35),
                        ),
                      ),
                    ),
                     
                  ],
                ),
                
              ),
              
              ),
        ),
      ),
      

    );
  }

  /// dispatch Explore state
  ///
  /// handle it by [isExploreOpen] and [currentExplorePercent!]
  void _dispatchExploreOffset() {
    if (!isExploreOpen!) {
      if (currentExplorePercent! < 0.3) {
        animateExplore!(false);
      } else {
        animateExplore!(true);
      }
    } else {
      if (currentExplorePercent! > 0.6) {
        animateExplore!(true);
      } else {
        animateExplore!(false);
      }
    }
  }
}
