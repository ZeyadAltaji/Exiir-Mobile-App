import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';

import 'package:ExiirEV/Model/ListCars.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarsController extends BaseController {
  Request request = Get.find();
  RxList<ListCars > lCars  = <ListCars >[].obs;
   CarsController( );

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
      var response = await request.getData('ExiirManagementAPI/GetAllCars/$userId');

      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        var data = response.fold((l) => null, (r) => r);
        if (data != null) {
          lCars.value = (data as List).map((item) => ListCars.fromJson(item)).toList();
        }
      }
    } catch (e) {
      print('Error fetching cars: $e');
     }

    update();
  }
}
