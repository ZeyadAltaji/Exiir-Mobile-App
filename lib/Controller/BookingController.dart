import 'dart:convert';
import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Model/Booking.dart';
import 'package:get/get.dart';

class BookingController extends BaseController {
  Request request = Get.find();

  int? brandId;

  BookingController( );

  @override
  void onInit() {
    super.onInit();
  }
//   

}
