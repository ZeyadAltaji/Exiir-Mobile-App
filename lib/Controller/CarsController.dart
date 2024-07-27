import 'dart:convert';

import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Model/ListCars.dart';
import 'package:ExiirEV/Views/screens/MyCars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toasty_box/toast_service.dart';

class CarsController extends BaseController {
  Request request = Get.find();
  RxList<ListCars> lCars = <ListCars>[].obs;
  final translationController = Get.put(TranslationController());

  CarsController();

  @override
  void onInit() {
    super.onInit();
    fetchListCars();
  }

  Future<void> fetchListCars() async {
    statusRequest = StatusRequest.loading;
    update();

    try {
      final preferences = await SharedPreferences.getInstance();
      var userId = preferences.getString('UserId');

      // Check if data exists in SharedPreferences
      String? storedCars = preferences.getString('StoredCars');

      if (storedCars != null) {
        // Load data from SharedPreferences
        var decodedCars = jsonDecode(storedCars) as List;
        lCars.value =
            decodedCars.map((item) => ListCars.fromJson(item)).toList();
      } else {
        // Fetch data from API if not in SharedPreferences
        await fetchFromApiAndStore(userId, preferences);
      }

      // Optionally, always check for updates in the background
      // This could be scheduled or triggered as per app's requirement
      await checkForUpdates(userId, preferences);
    } catch (e) {
      print('Error fetching cars: $e');
    }

    update();
  }

  Future<void> fetchFromApiAndStore(
      String? userId, SharedPreferences preferences) async {
    var response =
        await request.getData('ExiirManagementAPI/GetAllCars/$userId');
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        lCars.value =
            (data as List).map((item) => ListCars.fromJson(item)).toList();
        // Store fetched data in SharedPreferences
        preferences.setString('StoredCars', jsonEncode(lCars));
      }
    }
  }

  Future<void> checkForUpdates(
      String? userId, SharedPreferences preferences) async {
    // Fetch latest data from API
    var response =
        await request.getData('ExiirManagementAPI/GetAllCars/$userId');
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        var fetchedCars =
            (data as List).map((item) => ListCars.fromJson(item)).toList();
        // Compare with current stored data
        String? storedCars = preferences.getString('StoredCars');
        if (storedCars != null) {
          var decodedStoredCars = jsonDecode(storedCars) as List;
          var currentStoredCars =
              decodedStoredCars.map((item) => ListCars.fromJson(item)).toList();
          if (!_areListsEqual(fetchedCars, currentStoredCars)) {
            // Update SharedPreferences if data is different
            lCars.value = fetchedCars;
            preferences.setString('StoredCars', jsonEncode(fetchedCars));
          }
        } else {
          // If no stored data, store the fetched data
          lCars.value = fetchedCars;
          preferences.setString('StoredCars', jsonEncode(fetchedCars));
        }
      }
    }
  }

  bool _areListsEqual(List<ListCars> list1, List<ListCars> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  void showDeleteDialog(BuildContext context, int userCarId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogShow(
          onYes: () async {
            await deleteCar(context, userCarId);
            Navigator.of(context).pop();
          },
          onNo: () {
            ToastService.showWarningToast(
              context,
              message: translationController.GetMessages(22),
            );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> deleteCar(BuildContext context, int userCarId) async {
    try {
      final preferences = await SharedPreferences.getInstance();

      var UserId = preferences.getString('UserId');
      var ActionBy = preferences.getString('us_username');
      String? userToken = preferences.getString('token');

      final response = await http.post(
        Uri.parse(
            '${Environment.baseUrl}ExiirManagementAPI/DeleteCars/$userCarId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'KeyToken': Environment.keyToken,
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        int intlange = int.parse(response.body);
        if (intlange == 21) {
          ToastService.showSuccessToast(
            context,
            message:
                translationController.GetMessages(int.parse(response.body)),
          );
        } else {
          ToastService.showWarningToast(
            context,
            message:
                translationController.GetMessages(int.parse(response.body)),
          );
        }

        // Remove the deleted car from the list
        lCars.removeWhere((car) => car.userCar_id == userCarId);
        update();
      } else {
        throw 'Deletion failed';
      }
    } catch (ex) {
      print('Error deleting car: $ex');
    }
  }
}
