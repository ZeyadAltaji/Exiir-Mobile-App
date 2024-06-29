import 'dart:math';

import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Constant/ImgaeAssets.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Core/Functions/calculateDistance.dart';
import 'package:ExiirEV/Model/ChargingStations.dart';
import 'package:ExiirEV/Model/StationsModels.dart';
import 'package:ExiirEV/Views/Widget/details_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer_pro/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Core/Class/StatusRequest.dart';

class HomeController extends BaseController {
  final translationController = Get.put(TranslationController());
  double offsetExplore = 0.0;

  double get currentExplorePercent =>
      max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxList<StationsModels> stations = <StationsModels>[].obs;
  late Rx<LatLng> center = LatLng(31.999360418399394, 35.88007842069041).obs;
  GoogleMapController? mapController;
  final Map<String, double> stationDistances = {};
  Request request = Get.find();

  List<ChargingStations> chargingStations = [];

  @override
  void onInit() async {
    super.onInit();
    creatMarkers();
    updateUserLocation();
  }

  Future<void> creatMarkers() async {
    await fetchChargingStations();

    stations.clear();
    stations.addAll(chargingStations.map((station) => StationsModels(
          stationsName: translationController.Translate(
              station.csNameAr!, station.csName!),
          stationsPhone: station.csPhone,
          x: station.csLatitude.toString(),
          y: station.csLangtitude.toString(),
          address: station.csAddress,
          available: Random().nextBool(),
        )));

    sortStationsByDistance();
    // findNearestStationAndMove();
    for (int i = 0; i < stations.length; i++) {
      final station = stations[i];
      final distance = calculateDistance(
        center.value,
        LatLng(double.parse(station.x!), double.parse(station.y!)),
      );
      markers.add(
        Marker(
          markerId: MarkerId(stations[i].stationsName.toString()),
          position: LatLng(double.parse(stations[i].x.toString()),
              double.parse(stations[i].y.toString())),
          icon: await getCustomerMarkerIcon(),
          infoWindow: InfoWindow(
              title: stations[i].stationsName.toString(),
              snippet:
                  '${distance.toStringAsFixed(2)} ${translationController.getLanguage(60)}',
              onTap: () {
                showDetail(Get.context!, stations[i], distance);
              }),
        ),
      );
    }
  }

  void showDetail(
      BuildContext context, StationsModels station, double distance) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Sizer(
          builder: (context, orientation, deviceType) {
            return ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child:
                    DetailsContentWidget(station: station, distance: distance),
              ),
            );
          },
        );
      },
    );
  }

  //  return ClipRRect(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
  //           child: Container(
  //             height: double.infinity, // Set the desired height here
  //             width: double.infinity,
  //             child: DetailsContentWidget(station: station, distance: distance),
  //           ),
  //         );
  Future<BitmapDescriptor> getCustomerMarkerIcon() async {
     String assetPath = AppimageUrlAsset.logoMap;
    const ImageConfiguration imageConfig =
        ImageConfiguration(size: Size(1, 1), devicePixelRatio: 0.2);
    return BitmapDescriptor.fromAssetImage(imageConfig, assetPath);
  }

  Future<void> findNearestStationAndMove() async {
    sortStationsByDistance();

    if (stations.isNotEmpty) {
      final nearestStation = stations.first;

      await mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
              double.parse(nearestStation.x!), double.parse(nearestStation.y!)),
        ),
      );
    }
  }

  Future<void> updateUserLocation() async {
    getUserCurrentLocation().then((value) async {
      center.value = LatLng(31.999360418399394, 35.88007842069041);
      markers.add(
        Marker(
          markerId: MarkerId('موقع المستخدم'),
          position: LatLng(31.999360418399394, 35.88007842069041),
          infoWindow: InfoWindow(
            title: 'موقع المستخدم',
            snippet: 'هنا أنا!',
          ),
        ),
      );
      sortStationsByDistance();

      // Move the camera to the user's current location
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(31.999360418399394, 35.88007842069041),
              zoom: 20.0,
            ),
          ),
        );
      }
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR: " + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  void zoomIn() {
    mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void findNearestStation() {
    sortStationsByDistance();

    if (stations.isNotEmpty) {
      final nearestStation = stations.first;

      mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
              double.parse(nearestStation.x!), double.parse(nearestStation.y!)),
        ),
      );
    }
  }

  void sortStationsByDistance() {
    stations.sort((a, b) {
      final distanceA = calculateDistance(
        center.value,
        LatLng(double.parse(a.x ?? '0'), double.parse(a.y ?? '0')),
      );
      final distanceB = calculateDistance(
        center.value,
        LatLng(double.parse(b.x ?? '0'), double.parse(b.y ?? '0')),
      );
      stationDistances[a.stationsName!] = distanceA;
      stationDistances[b.stationsName!] = distanceB;
      return distanceA.compareTo(distanceB);
    });
  }

  fetchChargingStations() async {
    statusRequest = StatusRequest.loading;
    update();

    var response =
        await request.postdata('ExiirManagementAPI/ChargingStationsInfo');

    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        chargingStations = (data as List)
            .map((item) => ChargingStations.fromJson(item))
            .toList();
      }
    }

    update();
  }

  void launchDirections(double lat, double lng) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  void launchPhone(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
