import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:ExiirEV/Controller/HomeController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/Appcolors.dart';
import 'package:ExiirEV/Model/StationsModels.dart';
import 'package:ExiirEV/Core/Constant/AppFonts.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';

class DetailsContentWidget extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final TranslationController translationController =
      Get.put(TranslationController());
  final StationsModels station;
  final double distance;
  final String currentAddress;

  DetailsContentWidget({
    super.key,
    required this.station,
    required this.distance,
    this.currentAddress = 'Байкове кладовище, Kyiv, Kyiv City, Kyiv 02000',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          // Fixed header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [Appcolors.logotwo, Appcolors.logoone],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.ev_station,
                        color: Appcolors.white,
                        size: 9.f,
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: Text(
                          station.stationsName ?? '',
                          style: Get.locale!.languageCode == 'ar'
                              ? fontAr.copyWith(
                                  fontSize: 10.f, color: Appcolors.white)
                              : fontEn.copyWith(
                                  fontSize: 10.f, color: Appcolors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      SizedBox(width: 3.w, height: 16.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${distance.toStringAsFixed(2)} ${translationController.getLanguage(60)}',
                            style: Get.locale!.languageCode == 'ar'
                                ? fontAr.copyWith(
                                    fontSize: 8.f, color: Appcolors.white)
                                : fontEn.copyWith(
                                    fontSize: 8.f, color: Appcolors.white),
                          ),
                          Text(
                            translationController.getLanguage(66),
                            style: Get.locale!.languageCode == 'ar'
                                ? fontAr.copyWith(
                                    fontSize: 7.f, color: Appcolors.white)
                                : fontEn.copyWith(
                                    fontSize: 7.f, color: Appcolors.white),
                          ),
                        ],
                      ),
                      SizedBox(width: 5.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '25 Mins',
                            style: Get.locale!.languageCode == 'ar'
                                ? fontAr.copyWith(
                                    fontSize: 8.f, color: Appcolors.white)
                                : fontEn.copyWith(
                                    fontSize: 8.f, color: Appcolors.white),
                          ),
                          Text(
                            'Avg Time',
                            style: Get.locale!.languageCode == 'ar'
                                ? fontAr.copyWith(
                                    fontSize: 6.f, color: Appcolors.white)
                                : fontEn.copyWith(
                                    fontSize: 6.f, color: Appcolors.white),
                          ),
                                                SizedBox(width: 10.w),

                        ],
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
          // Scrollable body
          Positioned.fill(
            top: 26.h,
            child: Container(
              decoration: BoxDecoration(
                color: Appcolors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
              ),
              child: SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(7.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translationController.getLanguage(65),
                            style: Get.locale!.languageCode == 'ar'
                                ? fontAr.copyWith(
                                    fontSize: 10.f, fontWeight: FontWeight.bold)
                                : fontEn.copyWith(
                                    fontSize: 10.f,
                                    fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.w, horizontal: 2.5.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Appcolors.Black.withOpacity(.5)),
                              borderRadius: BorderRadius.circular(2.5.w),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Appcolors.Black,
                                  size: 7.f,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    station.address!,
                                    style: Get.locale!.languageCode == 'ar'
                                        ? fontAr.copyWith(
                                            height: 2,
                                            fontSize: 7.5.f,
                                            fontWeight: FontWeight.bold)
                                        : fontEn.copyWith(
                                            height: 2,
                                            fontSize: 7.5.f,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.w, horizontal: 2.5.w),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Appcolors.Black.withOpacity(.5)),
                              borderRadius: BorderRadius.circular(2.5.w),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_available,
                                  color: Appcolors.Black,
                                  size: 7.f,
                                ),
                                SizedBox(width: 3.w),
                                Expanded(
                                  child: Text(
                                    translationController.Translate(
                                        'مفتوح من الساعة 6:00 صباحًا حتى 7:00 مساءً.',
                                        'Open from 6:00 AM to 7:00 PM.'),
                                    style: Get.locale!.languageCode == 'ar'
                                        ? fontAr.copyWith(
                                            height: 2,
                                            fontSize: 7.5.f,
                                            fontWeight: FontWeight.bold)
                                        : fontEn.copyWith(
                                            height: 2,
                                            fontSize: 7.5.f,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3.h),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 30.h,
                              viewportFraction: 1.0,
                              enlargeCenterPage: false,
                              autoPlay: true,
                            ),
                            items: [
                              '${AppimageUrlAsset.rootImages}/ev1.jpeg',
                              '${AppimageUrlAsset.rootImages}/ev2.jpeg',
                              '${AppimageUrlAsset.rootImages}/ev3.jpeg',
                            ].map((imagePath) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(2.5.w),
                                      image: DecorationImage(
                                        image: AssetImage(imagePath),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),

                          SizedBox(height: 6.h),
                          // SingleChildScrollView(
                          //   clipBehavior: Clip.none,
                          //   scrollDirection: Axis.horizontal,
                          //   child: Row(
                          //     children: List.generate(
                          //       overviews.length,
                          //       (index) => Padding(
                          //         padding: EdgeInsets.only(
                          //           left: index == 0 ? 0 : index == 2 ? 5.w : 2.5.w,
                          //           right: index == overviews.length - 1 ? 5.w : 2.5.w,
                          //         ),
                          //         child: OverviewItem(
                          //           icon: overviews[index]['icon'],
                          //           text1: overviews[index]['text1'],
                          //           text2: overviews[index]['text2'],
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.5.w),
        decoration: const BoxDecoration(color: Appcolors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    homeController.launchDirections(
                        double.parse(station.x ?? '0'),
                        double.parse(station.y ?? '0'));
                  },
                  child: Container(
                    padding:const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      color: Appcolors.blue,
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                    child: const Icon(
                      Icons.directions,
                      color: Appcolors.white,
                      size: 20,
                    ),
                  ),
                ),
              const  SizedBox(width: 10), // Adjust spacing between buttons
                GestureDetector(
                  onTap: () {
                    homeController.launchPhone(station.stationsPhone ?? '');
                  },
                  child: Container(
                    padding:const  EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      color: Appcolors.blue,
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                    child:const Icon(
                      Icons.phone,
                      color: Appcolors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
             onTap: station.available != translationController.getLanguage(64) ? () {
                    homeController.goToLoginPage(station.stationId);
                  } : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  color: Appcolors.blue,
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Row(
                  children: [
                   const Icon(
                      Icons.book,
                      color: Appcolors.white,
                      size: 20,
                    ),
                const    SizedBox(width: 5), // Adjust spacing between icon and text
                    Text(
                      translationController.getLanguage(85),
                      style:const TextStyle(
                        fontSize: 12,
                        color: Appcolors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OverviewItem extends StatelessWidget {
  final IconData icon;
  final String text1, text2;

  const OverviewItem({
    super.key,
    required this.icon,
    required this.text1,
    required this.text2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35.w,
      padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 2.5.w),
      decoration: BoxDecoration(
        border: Border.all(color: Appcolors.Black.withOpacity(.5)),
        borderRadius: BorderRadius.circular(2.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 8.f,
          ),
          SizedBox(height: 1.h),
          Text(
            text1,
            style: Get.locale!.languageCode == 'ar'
                ? fontAr.copyWith(fontSize: 7.f, fontWeight: FontWeight.bold)
                : fontEn.copyWith(fontSize: 7.f, fontWeight: FontWeight.bold),
          ),
          Text(
            text2,
            style: Get.locale!.languageCode == 'ar'
                ? fontAr.copyWith(
                    color: Appcolors.Black.withOpacity(.5), fontSize: 6.f)
                : fontEn.copyWith(
                    color: Appcolors.Black.withOpacity(.5), fontSize: 6.f),
          ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> overviews = [
  {'icon': Icons.electric_bolt, 'text1': 'Super Charge', 'text2': '250kw'},
  {
    'icon': Icons.settings_input_svideo_sharp,
    'text1': '8/10 plug',
    'text2': 'Available plugs'
  },
  {'icon': Icons.local_parking, 'text1': 'Free park', 'text2': 'Parking rated'},
];
