import 'dart:convert';
import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Model/AppointmentTypes.dart';
import 'package:ExiirEV/Model/Booking.dart';
import 'package:get/get.dart';

class BookingController extends BaseController {
  Request request = Get.find();
  RxList<AppointmentTypes> lAppointmentTypes = <AppointmentTypes>[].obs;

 
  BookingController( );

  @override
  void onInit() {
    super.onInit();
        fetchAppointmentTypes();

  }
  fetchAppointmentTypes() async {
    statusRequest = StatusRequest.loading;
    var response = await request
        .getData('ExiirManagementAPI/GetAppointmentTypes');
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        lAppointmentTypes.value =
            (data as List).map((item) => AppointmentTypes.fromJson(item)).toList();
       }
    }
  }
   

}
