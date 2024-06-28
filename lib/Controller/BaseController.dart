import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseController extends GetxController {
    StatusRequest ? statusRequest;



  Future<void> saveSharedPreferences(String setName,String val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(setName, val);
  }

  Future<String?> getSharedPreferences(String getName,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(getName);
  }
}