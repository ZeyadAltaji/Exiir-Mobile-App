import 'package:ExiirEV/Core/Services/BaseServices.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends BaseServices {
  late SharedPreferences sharedPreferences;

  Future<MyServices> initial() async {
       await Firebase.initializeApp();

    sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }
}

initialServices() async {
  await Get.putAsync(() async => await MyServices().initial());
}
