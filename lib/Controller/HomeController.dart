import 'package:dartz/dartz.dart';
import 'package:exiir3/Controller/BaseController.dart';
import 'package:exiir3/Core/Class/Request.dart';
import 'package:exiir3/Core/Constant/ImgaeAssets.dart';
import 'package:exiir3/Core/Functions/Handingdata.dart';
import 'package:exiir3/Core/Functions/calculateDistance.dart';
import 'package:exiir3/Model/ChargingStations.dart';
import 'package:exiir3/Model/StationsModels.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Core/Class/StatusRequest.dart';
 


class HomeController extends BaseController {
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxList<StationsModels> stations = <StationsModels>[].obs;
  late Rx<LatLng> center = LatLng(31.999360418399394, 35.88007842069041).obs;
  GoogleMapController? mapController;
  final Map<String, double> stationDistances = {};
  Request request = Get.find();


  List<ChargingStations> chargingStations = [];


  @override
  void onInit() {
    super.onInit();
    creatMarkers();
    updateUserLocation();  
  }
  
  Future<void> creatMarkers() async {
    await fetchChargingStations();

    stations.clear();
    stations.addAll(chargingStations.map((station) => StationsModels(
          stationsName: station.csNameAr,
          stationsPhone: station.csPhone,
          x: station.csLatitude.toString(),
          y: station.csLangtitude.toString(),
        )));

    sortStationsByDistance();

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
            snippet: '${distance.toStringAsFixed(2)} km away',
          ),
          onTap: () {
          },
        ),
      );
    }
  }

  Future<BitmapDescriptor> getCustomerMarkerIcon() async {
    final String assetPath = AppimageUrlAsset.logoMap;
    const ImageConfiguration imageConfig = ImageConfiguration(size: Size(1,1), devicePixelRatio: 0.2);
    return BitmapDescriptor.fromAssetImage(imageConfig, assetPath);
  }


  Future<void> updateUserLocation() async {
    getUserCurrentLocation().then((value) async {
      center.value = LatLng(value.latitude, value.longitude);
      markers.add(
        Marker(
          markerId: MarkerId('موقع المستخدم'),
          position: LatLng(value.latitude, value.longitude),
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
              target: LatLng(value.latitude, value.longitude),
              zoom: 20.0,
            ),
          ),
        );
      }
    });
  }

  Future<Position> getUserCurrentLocation() async {
  await Geolocator.requestPermission().then((value) {}).onError((error, stackTrace) async {
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
        LatLng(double.parse(nearestStation.x!), double.parse(nearestStation.y!)),
      ),
    );
    
   }
}
  void moveToSearchPage() {
    Get.toNamed('/SearchPage');
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

    var response = await request.postdata('ExiirManagementAPI/ChargingStationsInfo');

    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        chargingStations = (data as List).map((item) => ChargingStations.fromJson(item)).toList();
      }
    }

    update();
  }
 

}
