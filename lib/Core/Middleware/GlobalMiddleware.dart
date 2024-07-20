import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GlobalMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    redirectToCorrectPage();
    return null;
  }

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('us_username') != null;
  }

  Future<String?> getUserId() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('UserId');
  }

  Future<bool> userHasCars(String userId) async {
    try {
      final response = await http.get(Uri.parse(
          '${Environment.baseUrl}ExiirManagementAPI/HasCars/$userId'));

      if (response.statusCode == 200) {
        return json.decode(response.body) as bool;
      } else {
        // Handle non-200 status codes if needed
        return false;
      }
    } catch (e) {
      // Handle exceptions, such as ClientException
      print('Error fetching user cars: $e');
      return false;
    }
  }

  void redirectToCorrectPage() async {
    final stationId = Get.parameters['stationId'];

    final loggedIn = await isLoggedIn();
    if (!loggedIn) {
      final String route = stationId != null
          ? '${AppRoutes.LoginPage}?stationId=$stationId'
          : AppRoutes.LoginPage;

      return Get.offNamed(route);
    } else {
      final userId = await getUserId();
      if (userId != null) {
        final hasCars = await userHasCars(userId);
        if (hasCars) {
          final String route = stationId != null
              ? '${AppRoutes.ListandAddnewCars}?stationId=$stationId'
              : AppRoutes.ListandAddnewCars;

          return Get.offNamed(route);
        } else {
          final String route = stationId != null
              ? '${AppRoutes.BrandsPage}?stationId=$stationId'
              : AppRoutes.BrandsPage;

          return Get.offNamed(route);
        }
      } else {
        final String route = stationId != null
            ? '${AppRoutes.LoginPage}?stationId=$stationId'
            : AppRoutes.LoginPage;

        return Get.offAllNamed(route);
      }
    }
  }
}
