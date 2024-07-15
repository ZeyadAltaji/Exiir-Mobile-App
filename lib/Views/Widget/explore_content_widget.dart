import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/AppColors.dart';
import 'package:ExiirEV/Core/Functions/calculateDistance.dart';
import 'package:ExiirEV/Core/Functions/helper.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ExiirEV/Controller/HomeController.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExploreContentWidget extends StatelessWidget {
  final double currentExplorePercent;
  final HomeController homeController = Get.find<HomeController>();
  final translationController = Get.put(TranslationController());
  TextEditingController textController = TextEditingController();

  ExploreContentWidget({Key? key, required this.currentExplorePercent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentExplorePercent != 0) {
      return Positioned(
        top: realH(standardHeight + (1 - 380) * currentExplorePercent),
        width: screenWidth,
        child: Obx(() {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 380,
            ),
            child: Column(
              children: [
                AnimSearchBar(
                  width: 400,
                  helpText: translationController.getLanguage(87),
                  textController: homeController.searchController,
                  onSuffixTap: () {
                    homeController.searchController.clear();
                    homeController.filterStations('');
                  },
                  onSubmitted: (text) {
                    homeController.filterStations(text);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: homeController.filteredStations.isEmpty
                        ? Center(
                            child: Text(
                              "${translationController.Translate('لا يوجد محطة بهذا الاسم', "There's no station that name.")} (${homeController.searchController.text})",
                              style: TextStyle(
                                  color: Appcolors.white, fontSize: realH(20)),
                            ),
                          )
                        : Column(
                            children:
                                homeController.filteredStations.map((station) {
                              calculateDistance(
                                homeController.center.value,
                                LatLng(double.parse(station.x ?? '0'),
                                    double.parse(station.y ?? '0')),
                              );

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Opacity(
                                  opacity: currentExplorePercent,
                                  child: Transform.translate(
                                    offset: Offset(
                                      0,
                                      homeController.stations.indexOf(station) *
                                          realH(1) *
                                          (1 - currentExplorePercent),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        homeController.showDetails(
                                          context,
                                          station,
                                          calculateDistance(
                                            homeController.center.value,
                                            LatLng(
                                                double.parse(station.x ?? '0'),
                                                double.parse(station.y ?? '0')),
                                          ),
                                        );

                                        // Optionally update your UI state here
                                        // For example, hide the details container after showing details
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Appcolors.white),
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                      fontSize: realH(20),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8.0),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${translationController.getLanguage(16)}: ${station.address}",
                                                        style: TextStyle(
                                                          color:
                                                              Appcolors.white,
                                                          fontSize: realH(15),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 4.0),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10,
                                                          vertical: 6,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Appcolors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Text(
                                                          station.available!
                                                              ? translationController
                                                                  .getLanguage(
                                                                      63)
                                                              : translationController
                                                                  .getLanguage(
                                                                      64),
                                                          style: TextStyle(
                                                            color: station
                                                                    .available!
                                                                ? Appcolors
                                                                    .green
                                                                : Appcolors.red,
                                                            fontSize: realH(15),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 8.0),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.phone,
                                                    color: Appcolors.white,
                                                  ),
                                                  onPressed: () {
                                                    homeController.launchPhone(
                                                      station.stationsPhone ??
                                                          '',
                                                    );
                                                  },
                                                ),
                                                const SizedBox(height: 8.0),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.directions,
                                                    color: Appcolors.white,
                                                  ),
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
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ),
              ],
            ),
          );
        }),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.all(0),
      );
    }
  }
}
