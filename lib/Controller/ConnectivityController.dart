import 'dart:io';

import 'package:exiir3/Controller/BaseController.dart';
import 'package:get/get.dart';

import '../Views/Dialogs/showOfflineDialog.dart';

class ConnectivityController extends BaseController {
  var isOnline = true.obs;

  @override
  void onInit() {
    super.onInit();
    checkInternetPeriodically();
  }

  Future<void> checkInternet() async {
    try {
      var result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!isOnline.value) {
          isOnline.value = true;
        }
      } else {
        if (isOnline.value) {
          isOnline.value = false;
          showOfflineDialog();
        }
      }
    } on SocketException catch (_) {
      if (isOnline.value) {
        isOnline.value = false;
        showOfflineDialog();
      }
    }
  }
  void checkInternetPeriodically() {
    Future.delayed(Duration(seconds: 5), () async {
      await checkInternet();
      checkInternetPeriodically();
    });
  }
}