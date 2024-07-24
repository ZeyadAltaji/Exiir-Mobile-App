import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Core/Functions/calculateDistance.dart';
import 'package:ExiirEV/Model/ChargingStations.dart';
import 'package:ExiirEV/Model/StationsModels.dart';
import 'package:ExiirEV/Views/Widget/details_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sizer_pro/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Core/Class/StatusRequest.dart';

class HomeController extends BaseController {
  final TranslationController translationController =
      Get.put(TranslationController());
  double offsetExplore = 0.0;
  double zoomLevel = 8.0;
  double get currentExplorePercent =>
      max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxList<StationsModels> stations = <StationsModels>[].obs;
  RxList<StationsModels> filteredStations = <StationsModels>[].obs;

  late Rx<LatLng> center =
      const LatLng(31.999360418399394, 35.88007842069041).obs;
  GoogleMapController? mapController;
  final Map<String, double> stationDistances = {};
  Request request = Get.find();
  RxString searchText = ''.obs;

  List<ChargingStations> chargingStations = [];
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    await _initializeMarkers();
    await _updateUserLocation();
    
    searchText.listen((value) => filterStations());
  }

  Future<void> _initializeMarkers() async {
    await _fetchChargingStations();

    stations.clear();
    stations.addAll(chargingStations.map((station) => StationsModels(
      
          stationId: station.csId,
          stationsName: translationController.Translate(
              station.csNameAr!, station.csName!),
          stationsPhone: station.csPhone,
          x: station.csLatitude.toString(),
          y: station.csLangtitude.toString(),
          address: station.csAddress,
          available: Random().nextBool() == true ? translationController.getLanguage(63) : translationController.getLanguage(64),
        )));

    _sortStationsByDistance();

    for (var station in stations) {
      final distance = calculateDistance(
        center.value,
        LatLng(double.parse(station.x!), double.parse(station.y!)),
      );

      markers.add(
        Marker(
          markerId: MarkerId(station.stationsName.toString()),
          position: LatLng(double.parse(station.x!), double.parse(station.y!)),
          icon: await _createCustomMarkerIcon(Get.context!, 35.0),
          infoWindow: InfoWindow(
            title: station.stationsName.toString(),
            snippet:
                '${distance.toStringAsFixed(2)} ${translationController.getLanguage(60)}',
            onTap: () {
              showDetail(Get.context!, station, distance);
            },
          ),
        ),
      );
    }
  }

  Future<void> _fetchChargingStations() async {
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
        filterStations();
      }
    }

    update();
  }

  void _sortStationsByDistance() {
    stations.sort((a, b) {
      final distanceA = calculateDistance(center.value,
          LatLng(double.parse(a.x ?? '0'), double.parse(a.y ?? '0')));
      final distanceB = calculateDistance(center.value,
          LatLng(double.parse(b.x ?? '0'), double.parse(b.y ?? '0')));
      stationDistances[a.stationsName!] = distanceA;
      stationDistances[b.stationsName!] = distanceB;
      return distanceA.compareTo(distanceB);
    });
  }

  Future<void> _updateUserLocation() async {
    final position = await _getUserCurrentLocation();
    center.value = LatLng(position.latitude, position.longitude);

    markers.add(
      const Marker(
        markerId: MarkerId('user_location'),
        position: LatLng(31.999360418399394, 35.88007842069041),
        infoWindow: InfoWindow(
          title: 'User Location',
          snippet: 'You are here!',
        ),
      ),
    );

    _sortStationsByDistance();
    final nearestStation = _getNearestStation();
    if (nearestStation != null && mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(
        LatLng(
            double.parse(nearestStation.x!), double.parse(nearestStation.y!)),
      ));
    }

    update();
  }

  Future<Position> _getUserCurrentLocation() async {
    LocationPermission permission =
        await Geolocator.requestPermission().onError((error, stackTrace) async {
      return await Geolocator.requestPermission();
    });

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  StationsModels? _getNearestStation() {
    if (stations.isEmpty) return null;

    return stations.reduce((a, b) {
      final distanceA = calculateDistance(center.value,
          LatLng(double.parse(a.x ?? '0'), double.parse(a.y ?? '0')));
      final distanceB = calculateDistance(center.value,
          LatLng(double.parse(b.x ?? '0'), double.parse(b.y ?? '0')));
      return distanceA < distanceB ? a : b;
    });
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
              child: SizedBox(
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

  void showDetails(
      BuildContext context, StationsModels station, double distance) {
    LatLng stationLatLng = LatLng(
      double.parse(station.x ?? '0'),
      double.parse(station.y ?? '0'),
    );
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(stationLatLng, 18.0),
    );
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Sizer(
          builder: (context, orientation, deviceType) {
            return ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
              child: SizedBox(
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

  void zoomIn() {
    mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void zoomOut() {
    mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void findNearestStation() {
    _sortStationsByDistance();
    if (stations.isNotEmpty) {
      final nearestStation = stations.first;
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
              double.parse(nearestStation.x!), double.parse(nearestStation.y!)),
          18.0, // Set the zoom level to 18
        ),
      );
    }
  }

  void launchDirections(double lat, double lng) async {
    final googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  void launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void goToLoginPage(int? stationid) {
    final String route = stationid != null
        ? '${AppRoutes.BrandsPage}?stationId=$stationid'
        : AppRoutes.BrandsPage;
    Get.toNamed(route);
  }

  Future<BitmapDescriptor> _createCustomMarkerIcon(
      BuildContext context, double zoom) async {
    String imageUrl =
        "https://res.cloudinary.com/dk5eekms5/image/upload/v1719838882/ExiirEV/yrasrxny9kowyylgsyuv.png";
    final double markerSize = 3500.0 / zoom;

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Size size = Size(markerSize, markerSize);

    // رسم دائرة
    final Paint paint = Paint()..color = Colors.blue;
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), markerSize / 2, paint);

    // تحميل الصورة من الرابط المعطى
    final Uint8List imageData = await _loadImageFromUrl(imageUrl);
    if (imageData.isNotEmpty) {
      final ui.Codec codec = await ui.instantiateImageCodec(imageData);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      // حساب النسبة المئوية لتناسب الصورة داخل الدائرة
      double imageWidth = image.width.toDouble();
      double imageHeight = image.height.toDouble();
      double aspectRatio = imageWidth / imageHeight;

      double scaledWidth, scaledHeight;
      if (aspectRatio >= 1.0) {
        scaledWidth = markerSize;
        scaledHeight = markerSize / aspectRatio;
      } else {
        scaledHeight = markerSize;
        scaledWidth = markerSize * aspectRatio;
      }

      // رسم الصورة داخل الدائرة
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, imageWidth, imageHeight),
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: scaledWidth,
          height: scaledHeight,
        ),
        Paint(),
      );
    }

    // إنهاء الرسم وتحويله إلى صورة نهائية
    final ui.Image markerImage = await pictureRecorder.endRecording().toImage(
          size.width.toInt(),
          size.height.toInt(),
        );
    final ByteData? byteData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List bytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(bytes);
  }

  

  Future<Uint8List> _loadImageFromUrl(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return Uint8List(0);
    }
  }

  void onCameraMove(CameraPosition position) {
    zoomLevel = position.zoom;
  }

 void filterStations() {
    if (searchText.value.isEmpty) {
      filteredStations.value = stations;
    } else {
      filteredStations.value = stations.where((station) {
        final stationsNameLower = station.stationsName!.toLowerCase();
        final availableLower = station.available!.toLowerCase();
        final searchLower = searchText.value.toLowerCase();
        return stationsNameLower.contains(searchLower) || availableLower.contains(searchLower);
      }).toList();
    }
  }
}
