// import 'package:ExiirEV/Controller/BaseController.dart';
// import 'package:ExiirEV/Controller/TranslationController.dart';
// import 'package:ExiirEV/Core/Class/Request.dart';
// import 'package:ExiirEV/Core/Class/StatusRequest.dart';
// import 'package:ExiirEV/Core/Functions/Handingdata.dart';
// import 'package:ExiirEV/Model/Brands.dart';
// import 'package:get/get.dart';

// class BrandsController extends BaseController {
//   final translationController = Get.put(TranslationController());
//   Request request = Get.find();
//   RxList<Brands> lBrands = <Brands>[].obs;
//   RxList<Brands> filteredBrands = <Brands>[].obs;
//   RxString searchText = ''.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchBrands();
//     searchText.listen((value) => filterBrands());
//   }

//   fetchBrands() async {
//     statusRequest = StatusRequest.loading;
//     update();

//     var response = await request.getData('ExiirManagementAPI/GetBrands');

//     statusRequest = handlingData(response);
//     if (statusRequest == StatusRequest.success) {
//       var data = response.fold((l) => null, (r) => r);
//       if (data != null) {
//         lBrands.value =
//             (data as List).map((item) => Brands.fromJson(item)).toList();
//         filterBrands();
//       }
//     }

//     update();
//   }

//   void filterBrands() {
//     if (searchText.value.isEmpty) {
//       filteredBrands.value = lBrands;
//     } else {
//       filteredBrands.value = lBrands.where((brand) {
//         final brNameLower = brand.brName!.toLowerCase();
//         final brNameArLower = brand.brNameAr!.toLowerCase();
//         final searchLower = searchText.value.toLowerCase();
//         return brNameLower.contains(searchLower) ||
//             brNameArLower.contains(searchLower);
//       }).toList();
//     }
//   }


//   @override
//   void onReady() {
//     super.onReady();
//   }

//   @override
//   void onClose() {
//     super.onClose();
//   }
// }
import 'dart:convert';
import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Model/Brands.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandsController extends BaseController {
  final translationController = Get.put(TranslationController());
  Request request = Get.find();
  RxList<Brands> lBrands = <Brands>[].obs;
  RxList<Brands> filteredBrands = <Brands>[].obs;
  RxString searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBrands();
    searchText.listen((value) => filterBrands());
  }

  Future<void> loadBrands() async {
 
    final prefs = await SharedPreferences.getInstance();
    final storedBrands = prefs.getString('brands');

    if (storedBrands != null) {
       final List<dynamic> data = json.decode(storedBrands);
      lBrands.value = data.map((item) => Brands.fromJson(item)).toList();
      filterBrands();
    } else {
       fetchBrands();
    }
  }

  Future<void> fetchBrands() async {
    statusRequest = StatusRequest.loading;
    update();

    var response = await request.getData('ExiirManagementAPI/GetBrands');

    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        lBrands.value =
            (data as List).map((item) => Brands.fromJson(item)).toList();
        filterBrands();

        // Store in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('brands', json.encode(lBrands.map((e) => e.toJson()).toList()));
      }
    }

    update();
  }

  void filterBrands() {
    if (searchText.value.isEmpty) {
      filteredBrands.value = lBrands;
    } else {
      filteredBrands.value = lBrands.where((brand) {
        final brNameLower = brand.brName!.toLowerCase();
        final brNameArLower = brand.brNameAr!.toLowerCase();
        final searchLower = searchText.value.toLowerCase();
        return brNameLower.contains(searchLower) ||
            brNameArLower.contains(searchLower);
      }).toList();
    }
  }

  Future<void> updateBrandsIfNeeded() async {
    var response = await request.getData('ExiirManagementAPI/GetBrands');
    var data = response.fold((l) => null, (r) => r);

    if (data != null) {
      List<Brands> newBrands = (data as List).map((item) => Brands.fromJson(item)).toList();
      // Compare with current list
      if (newBrands.length != lBrands.length || !newBrands.every((brand) => lBrands.contains(brand))) {
        lBrands.value = newBrands;
        filterBrands();

        // Update SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('brands', json.encode(lBrands.map((e) => e.toJson()).toList()));
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    updateBrandsIfNeeded();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
