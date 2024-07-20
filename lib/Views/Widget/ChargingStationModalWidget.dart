import 'package:ExiirEV/Controller/HomeController.dart';
import 'package:ExiirEV/Core/Constant/AppFonts.dart';
import 'package:ExiirEV/Core/Functions/calculateDistance.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:get/get.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class ChargingStationModalHelper {
  static void showChargingStationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ChargingStationModal();
      },
    );
  }
}

class ChargingStationModal extends StatefulWidget {
  @override
  _ChargingStationModalState createState() => _ChargingStationModalState();
}

class _ChargingStationModalState extends State<ChargingStationModal>
    with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  final translationController = Get.put(TranslationController());
  final HomeController homeController = Get.find<HomeController>();
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    textController.addListener(() {
      homeController.searchText.value = textController.text;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isKeyboardVisible
          ? MediaQuery.of(context).size.height * 0.9
          : MediaQuery.of(context).size.height * 0.5,
      constraints: const BoxConstraints(
        maxHeight: double.infinity,
      ),
      width: double.infinity,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: Stack(
          children: [
            Positioned(
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [Appcolors.logotwo, Appcolors.logoone],
                  ),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(5.w)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.ev_station,
                          color: Appcolors.white,
                          size: 15.f,
                        ),
                        Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            translationController.getLanguage(89),
                            style: Get.locale!.languageCode == 'ar'
                                ? fontAr.copyWith(
                                    fontSize: 10.f, color: Appcolors.white)
                                : fontEn.copyWith(
                                    fontSize: 10.f, color: Appcolors.white),
                          ),
                        ),
                      ],
                    ),
                    AnimSearchBar(
                      width: 380,
                      helpText: translationController.getLanguage(87),
                      textController: textController,
                      onSuffixTap: () {
                        textController.clear();
                      },
                      searchIconColor: Appcolors.Black,
                      autoFocus: true,
                      closeSearchOnSuffixTap: true,
                      animationDurationInMilli: 1500,
                      rtl: true,
                      onSubmitted: (String value) {
                        // Empty implementation
                      },
                    ),
                    Expanded(
                      child: Obx(() {
                        return homeController.filteredStations.isEmpty
                            ? Center(
                                child: Text(
                                  "${translationController.Translate('لا يوجد محطة بهذا الاسم', "There's no station that name.")} (${homeController.searchController.text})",
                                  style: TextStyle(
                                      color: Appcolors.white, fontSize: 3.5.h),
                                ),
                              )
                            : ListView(
                                children: homeController.filteredStations
                                    .map((station) {
                                  calculateDistance(
                                    homeController.center.value,
                                    LatLng(double.parse(station.x ?? '0'),
                                        double.parse(station.y ?? '0')),
                                  );
                                  return GestureDetector(
                                    onTap: () {
                                      homeController.showDetails(
                                        context,
                                        station,
                                        calculateDistance(
                                          homeController.center.value,
                                          LatLng(double.parse(station.x ?? '0'),
                                              double.parse(station.y ?? '0')),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Appcolors.white
                                                .withOpacity(.5)),
                                        borderRadius:
                                            BorderRadius.circular(2.5.w),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    station.stationsName ??
                                                        translationController
                                                            .getLanguage(62),
                                                    style: TextStyle(
                                                      color: Appcolors.white,
                                                      fontSize: 2.3.h,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${translationController.getLanguage(16)}: ${station.address}" ??
                                                        'No address available',
                                                    style: TextStyle(
                                                      color: Appcolors.white
                                                          .withOpacity(0.7),
                                                      fontSize: 2.0.h,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10.0),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 6),
                                                    decoration: BoxDecoration(
                                                      color: Appcolors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Text(
                                                      station.available!,
                                                      style: TextStyle(
                                                        color: station
                                                                    .available! ==
                                                                translationController
                                                                    .getLanguage(
                                                                        63)
                                                            ? Appcolors.green
                                                            : Appcolors.red,
                                                        fontSize: 1.8.h,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.directions,
                                                      color: Appcolors.white),
                                                  onPressed: () {
                                                    homeController
                                                        .launchDirections(
                                                      double.parse(
                                                          station.x ?? '0'),
                                                      double.parse(
                                                          station.y ?? '0'),
                                                    );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.phone,
                                                      color: Appcolors.white),
                                                  onPressed: () {
                                                    homeController.launchPhone(
                                                      station.stationsPhone ??
                                                          '',
                                                    );
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                      }),
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
