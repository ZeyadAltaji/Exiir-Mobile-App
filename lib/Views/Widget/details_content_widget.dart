import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Functions/calculateDistance.dart';
import 'package:ExiirEV/Core/Functions/helper.dart';
import 'package:ExiirEV/Model/StationsModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ExiirEV/Controller/HomeController.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsContentWidget extends StatelessWidget {
   final HomeController homeController = Get.find<HomeController>();
  final TranslationController translationController = Get.put(TranslationController());
  final StationsModels station;
  final double distance;

  DetailsContentWidget({Key? key,required this.station, required this.distance}): super(key: key);
 
  @override
  Widget build(BuildContext context) {
   return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 165,
        leading: Row(
          children: [
            SizedBox(width: 5.w),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: Appcolors.white, borderRadius: BorderRadius.circular(5.w)),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 8.f,
                    ),
                    Text(
                      'Nearest location',
                      // style: roboto.copyWith(fontSize: 5.5.f),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Appcolors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Appcolors.white)),
                child: Icon(
                  CupertinoIcons.slider_horizontal_3,
                  color: Appcolors.black,
                  size: 8.f,
                ),
              ),
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: Appcolors.white, shape: BoxShape.circle),
                    child: Text(
                      '2',
                      // style: roboto.copyWith(color: white),
                    )),
              )
            ],
          ),
          SizedBox(width: SizeExtension(5).w)
        ],
      ),
    );
  }
}