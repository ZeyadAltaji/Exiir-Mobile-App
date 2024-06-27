
import 'package:exiir3/Core/Functions/calculateDistance.dart';
import 'package:exiir3/Core/Functions/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exiir3/Controller/HomeController.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ExploreContentWidget extends StatelessWidget {
  final double currentExplorePercent;
  final HomeController homeController = Get.find<HomeController>();

  ExploreContentWidget({Key? key, required this.currentExplorePercent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentExplorePercent != 0) {
      return Positioned(
        top: realH(standardHeight + (1 - 380) * currentExplorePercent),
        width: screenWidth,
        child: Obx(() {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 380,  
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: homeController.stations.map((station) {
                  final distance = calculateDistance(
                    homeController.center.value,
                    LatLng(double.parse(station.x ?? '0'), double.parse(station.y ?? '0')),
                  );

                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Opacity(
                      opacity: currentExplorePercent,
                      child: Transform.translate(
                        offset: Offset(0, homeController.stations.indexOf(station) * realH(1) * (1 - currentExplorePercent)),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      station.stationsName ?? 'Unknown Station',
                                      style: TextStyle(color: Colors.white, fontSize: realH(18)),
                                    ),
                                    SizedBox(height: 8.0),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${distance.toStringAsFixed(1)} km away",
                                          style: TextStyle(color: Colors.white54, fontSize: realH(14)),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          "Phone: ${station.stationsPhone ?? 'N/A'}",
                                          style: TextStyle(color: Colors.white54, fontSize: realH(14)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                    bottom: 8.0,
                                    right: 8.0,
                                    child: Column(
                                      children: [
                                      IconButton(
                                        icon: Icon(Icons.phone, color: Colors.white),
                                        onPressed: () {
                                          _launchPhone(station.stationsPhone ?? '');
                                        },
                                      ),
                                      SizedBox(height: 8.0),
                                      IconButton(
                                        icon: Icon(Icons.directions, color: Colors.white),
                                        onPressed: () {
                                          _launchDirections(double.parse(station.x ?? '0'), double.parse(station.y ?? '0'));
                                        },
                                      ),
                                    ],
                                ),
                              )


                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
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
    void _launchPhone(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchDirections(double lat, double lng) async {
    String googleUrl =
          'https://www.google.com/maps/search/?api=1&query=${lat},${lng}';
      if (await canLaunchUrl(Uri.parse(googleUrl))) {
        await launchUrl(Uri.parse(googleUrl));
      } else {
        throw 'Could not open the map.';
      }
  }
}

