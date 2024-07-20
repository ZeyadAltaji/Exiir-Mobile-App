import 'dart:convert';

import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Model/Models.dart';
import 'package:ExiirEV/Model/Versions.dart';
import 'package:ExiirEV/Views/screens/BookingPage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VersionsController extends GetxController {
  Request request = Get.find();
  List<Versions> lVersions = [];
  RxList<Versions> filteredVersions = <Versions>[].obs;
  RxString searchText = ''.obs;
  StatusRequest statusRequest = StatusRequest.loading;
  int? ModelId;
  int? BrandId;
  String? stationId;
  String? type;

  VersionsController(
      {required this.ModelId,
      required this.BrandId,
      this.stationId,
      this.type});

  @override
  void onInit() {
    super.onInit();
    fetchModels();
    searchText.listen((value) => filterVersion());
  }

  fetchModels() async {
    statusRequest = StatusRequest.loading;
    var response = await request
        .getData('ExiirManagementAPI/GetVersionsByModelId/$ModelId');
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        lVersions =
            (data as List).map((item) => Versions.fromJson(item)).toList();
        filterVersion();
      }
    }
  }

  void filterVersion() {
    if (searchText.value.isEmpty) {
      filteredVersions.assignAll(List.from(lVersions));
    } else {
      filteredVersions.assignAll(lVersions.where((models) {
        final brNameLower = models.veName!.toLowerCase();
        final brNameArLower = models.veName!.toLowerCase();
        final searchLower = searchText.value.toLowerCase();
        return brNameLower.contains(searchLower) ||
            brNameArLower.contains(searchLower);
      }).toList());
    }
  }

  Future<void> SaveUserCars(
      int BrandId, int ModelId, int? VersionsId,String? stationId, String? type) async {
    try {
      if (type == '1') {
        final preferences = await SharedPreferences.getInstance();

        var UserId = preferences.getString('UserId');
        var ActionBy = preferences.getString('us_username');

        final response = await http.post(
          Uri.parse('${Environment.baseUrl}ExiirManagementAPI/SaveUserCars'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'br_id': BrandId,
            'mo_id': ModelId,
            've_id': VersionsId!,
            'actionBy': ActionBy!,
            'us_user_id': UserId!,
          }),
        );

        if (response.statusCode == 200) {
            final String route = stationId != null ? '${AppRoutes.BookingPage}?stationId=$stationId&BrandId=$BrandId&ModelId=$ModelId&VersionsId=$VersionsId&type=$type' : AppRoutes.BookingPage;

          Get.offAllNamed(route);
        } else {
          throw 'ex';
        }
      }else{
          final String route = stationId != null ? '${AppRoutes.BookingPage}?stationId=$stationId&BrandId=$BrandId&ModelId=$ModelId&VersionsId=$VersionsId&type=$type' : AppRoutes.BookingPage;
          Get.offAllNamed(route);

      }
    } catch (ex) {
      throw ex;
    }
  }
}
