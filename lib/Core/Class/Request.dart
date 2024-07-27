import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Controller/ConnectivityController.dart';
import 'StatusRequest.dart';

class Request {
  final TranslationController translationController = Get.find();

  final ConnectivityController check;
  late final IOClient ioClient;

  Request(this.check) {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    ioClient = IOClient(httpClient);
  }
 Future<Either<StatusRequest, dynamic>> Senddata(String linkurl, {required String body}) async {
    try {
      await check.checkInternet();
      if (check.isOnline.value) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userToken = prefs.getString('token');
        var response = await ioClient.post(
          Uri.parse(Environment.baseUrl + linkurl),
          headers: {
            'Content-Type': 'application/json',
            'KeyToken': Environment.keyToken,
                        'Authorization': 'Bearer $userToken',

          },
          body: body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          var responseBody = jsonDecode(response.body);
          return Right(responseBody);
        } else {
          return const Left(StatusRequest.serverfailure);
        }
      } else {
        return const Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return const Left(StatusRequest.serverfailure);
    }
  }
  Future<Either<StatusRequest, dynamic>> getData(String linkurl) async {
    try {
      await check.checkInternet();
      if (check.isOnline.value) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userToken = prefs.getString('token');
        var response = await ioClient.get(
          Uri.parse(Environment.baseUrl + linkurl),
          headers: {
            'Content-Type': 'application/json',
            'KeyToken': Environment.keyToken,
            'Authorization': 'Bearer $userToken',

          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          var responseBody = jsonDecode(response.body);
          return Right(responseBody);
        } else {
          return const Left(StatusRequest.serverfailure);
        }
      } else {
        return const Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return const Left(StatusRequest.serverfailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> postdata(String linkurl) async {
    try {
      await check.checkInternet();
      if (check.isOnline.value) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userToken = prefs.getString('token');
        var response = await ioClient.post(
          Uri.parse(Environment.baseUrl + linkurl),
          headers: {
            'Content-Type': 'application/json',
            'KeyToken': Environment.keyToken,
            'Authorization': 'Bearer $userToken',

          },
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          var responseBody = jsonDecode(response.body);
          return Right(responseBody);
        } else {
          return const Left(StatusRequest.serverfailure);
        }
      } else {
        return const Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return const Left(StatusRequest.serverfailure);
    }
  }
}
