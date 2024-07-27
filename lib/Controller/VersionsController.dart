// import 'dart:convert';

// import 'package:ExiirEV/Core/Class/Request.dart';
// import 'package:ExiirEV/Core/Class/StatusRequest.dart';
// import 'package:ExiirEV/Core/Constant/Environment.dart';
// import 'package:ExiirEV/Core/Constant/routes.dart';
// import 'package:ExiirEV/Core/Functions/Handingdata.dart';
// import 'package:ExiirEV/Model/Models.dart';
// import 'package:ExiirEV/Model/Versions.dart';
// import 'package:ExiirEV/Views/screens/BookingPage.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class VersionsController extends GetxController {
//   Request request = Get.find();
//   List<Versions> lVersions = [];
//   RxList<Versions> filteredVersions = <Versions>[].obs;
//   RxString searchText = ''.obs;
//   StatusRequest statusRequest = StatusRequest.loading;
//   int? ModelId;
//   int? BrandId;
//   String? stationId;
//   String? type;

//   VersionsController(
//       {required this.ModelId,
//       required this.BrandId,
//       this.stationId,
//       this.type});

//   @override
//   void onInit() {
//     super.onInit();
//     fetchModels();
//     searchText.listen((value) => filterVersion());
//   }

//   fetchModels() async {
//     statusRequest = StatusRequest.loading;
//     var response = await request
//         .getData('ExiirManagementAPI/GetVersionsByModelId/$ModelId');
//     statusRequest = handlingData(response);
//     if (statusRequest == StatusRequest.success) {
//       var data = response.fold((l) => null, (r) => r);
//       if (data != null) {
//         lVersions =
//             (data as List).map((item) => Versions.fromJson(item)).toList();
//         filterVersion();
//       }
//     }
//   }

//   void filterVersion() {
//     if (searchText.value.isEmpty) {
//       filteredVersions.assignAll(List.from(lVersions));
//     } else {
//       filteredVersions.assignAll(lVersions.where((models) {
//         final brNameLower = models.veName!.toLowerCase();
//         final brNameArLower = models.veName!.toLowerCase();
//         final searchLower = searchText.value.toLowerCase();
//         return brNameLower.contains(searchLower) ||
//             brNameArLower.contains(searchLower);
//       }).toList());
//     }
//   }

//   Future<void> SaveUserCars(
//       int BrandId, int ModelId, int? VersionsId,String? stationId, String? type) async {
//     try {
//       if (type == '1') {
//         final preferences = await SharedPreferences.getInstance();

//         var UserId = preferences.getString('UserId');
//         var ActionBy = preferences.getString('us_username');

//         final response = await http.post(
//           Uri.parse('${Environment.baseUrl}ExiirManagementAPI/SaveUserCars'),
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//             'KeyToken': Environment.keyToken
//           },
//           body: jsonEncode({
//             'br_id': BrandId,
//             'mo_id': ModelId,
//             've_id': VersionsId!,
//             'actionBy': ActionBy!,
//             'us_user_id': UserId!,
//           }),
//         );

//         if (response.statusCode == 200) {
//             final String route = stationId != null ? '${AppRoutes.BookingPage}?stationId=$stationId&BrandId=$BrandId&ModelId=$ModelId&VersionsId=$VersionsId&type=$type' : AppRoutes.BookingPage;

//           Get.offAllNamed(route);
//         } else {
//           throw 'ex';
//         }
//       }else{
//           final String route = stationId != null ? '${AppRoutes.BookingPage}?stationId=$stationId&BrandId=$BrandId&ModelId=$ModelId&VersionsId=$VersionsId&type=$type' : AppRoutes.BookingPage;
//           Get.offAllNamed(route);

//       }
//     } catch (ex) {
//       throw ex;
//     }
//   }
// }
// import 'package:ExiirEV/Controller/BaseController.dart';
// import 'package:ExiirEV/Core/Class/Request.dart';
// import 'package:ExiirEV/Core/Class/StatusRequest.dart';
// import 'package:ExiirEV/Core/Functions/Handingdata.dart';
// import 'package:ExiirEV/Model/Models.dart';
// import 'package:get/get.dart';

// class ModelsController extends BaseController {
//   Request request = Get.find();
//   List<Models> lVersions = [];
//   RxList<Models> filteredModels = <Models>[].obs;
//   RxString searchText = ''.obs;
//   StatusRequest statusRequests = StatusRequest.loading;
//   int? ModelId;
//   String? stationId;
//   String? type;
//   ModelsController({
//     required this.ModelId,
//     this.stationId,
//     this.type,
//   });
//   @override
//   void onInit() {
//     super.onInit();
//     fetchModels();
//     searchText.listen((value) => filterModels());
//   }

//   fetchModels() async {
//     statusRequest = StatusRequest.loading;
//     var response =
//         await request.getData('ExiirManagementAPI/GetModelsById/$ModelId');
//     statusRequest = handlingData(response);
//     if (statusRequest == StatusRequest.success) {
//       var data = response.fold((l) => null, (r) => r);
//       if (data != null) {
//         lVersions = (data as List).map((item) => Models.fromJson(item)).toList();
//         filterModels();
//       }
//     }
//   }

//   void filterModels() {
//     if (searchText.value.isEmpty) {
//       filteredModels.assignAll(List.from(lVersions));
//     } else {
//       filteredModels.assignAll(lVersions.where((models) {
//         final brNameLower = models.moName!.toLowerCase();
//         final brNameArLower = models.moNameAr!.toLowerCase();
//         final searchLower = searchText.value.toLowerCase();
//         return brNameLower.contains(searchLower) ||
//             brNameArLower.contains(searchLower);
//       }).toList());
//     }
//   }
// }
import 'dart:convert';
import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Constant/Environment.dart';
import 'package:ExiirEV/Core/Constant/routes.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Model/Versions.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VersionsController extends BaseController {
  final translationController = Get.put(TranslationController());
  Request request = Get.find();
  RxList<Versions> lVersions = <Versions>[].obs;

  RxList<Versions> filteredVersions = <Versions>[].obs;
  RxString searchText = ''.obs;
  int? ModelId;
  int? BrandId;
  String? stationId;
  String? type;

  VersionsController(
      {required this.ModelId,
      required this.BrandId,
      this.stationId,
      this.type});

  @override
  void onInit() {
    super.onInit();
    loadVersion();
    searchText.listen((value) => filterVersion());
  }

  Future<void> loadVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getString('Version');

    if (storedVersion != null) {
      final List<dynamic> data = json.decode(storedVersion);
      lVersions.value = data.map((item) => Versions.fromJson(item)).toList();
      filterVersion();
    } else {
      fetchVersion();
    }
  }

  Future<void> fetchVersion() async {
    update();

    var response = await request
        .getData('ExiirManagementAPI/GetVersionsByModelId/$ModelId');

    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        lVersions.value =
            (data as List).map((item) => Versions.fromJson(item)).toList();
        filterVersion();

        // Store in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'Version', json.encode(lVersions.map((e) => e.toJson()).toList()));
      }
    }

    update();
  }

  void filterVersion() {
    if (searchText.value.isEmpty) {
      filteredVersions.value = lVersions;
    } else {
      filteredVersions.assignAll(lVersions.where((models) {
        final brNameLower = models.veName!.toLowerCase();
        final brNameArLower = models.veName!.toLowerCase();
        final searchLower = searchText.value.toLowerCase();
        return brNameLower.contains(searchLower) ||
            brNameArLower.contains(searchLower);
      }).toList());
    }
  }

  Future<void> updateVersionIfNeeded() async {
    var response = await request
        .getData('ExiirManagementAPI/GetVersionsByModelId/$ModelId');
    var data = response.fold((l) => null, (r) => r);

    if (data != null) {
      List<Versions> newVersion =
          (data as List).map((item) => Versions.fromJson(item)).toList();
      // Compare with current list
      if (newVersion.length != lVersions.length ||
          !newVersion.every((Version) => lVersions.contains(Version))) {
        lVersions.value = newVersion;
        filterVersion();

        // Update SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'Version', json.encode(lVersions.map((e) => e.toJson()).toList()));
      }
    }
  }

  Future<void> SaveUserCars(int BrandId, int ModelId, int? VersionsId,
      String? stationId, String? type) async {
    try {
      if (type == '1') {
        final preferences = await SharedPreferences.getInstance();

        var UserId = preferences.getString('UserId');
        var ActionBy = preferences.getString('us_username');
        String? userToken = preferences.getString('token');

        final response = await http.post(
          Uri.parse('${Environment.baseUrl}ExiirManagementAPI/SaveUserCars'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'KeyToken': Environment.keyToken,
            'Authorization': 'Bearer $userToken',

          },
          body: jsonEncode({
            'br_id': BrandId,
            'mo_id': ModelId,
            've_id': VersionsId!,
            'actionBy': ActionBy!,
            'us_user_id': UserId!,
          }),
        );

        if (response.statusCode == 200) {
          final String route = stationId != null
              ? '${AppRoutes.BookingPage}?stationId=$stationId&BrandId=$BrandId&ModelId=$ModelId&VersionsId=$VersionsId&type=$type'
              : AppRoutes.BookingPage;

          Get.offAllNamed(route);
        } else {
          throw 'ex';
        }
      } else {
        final String route = stationId != null
            ? '${AppRoutes.BookingPage}?stationId=$stationId&BrandId=$BrandId&ModelId=$ModelId&VersionsId=$VersionsId&type=$type'
            : AppRoutes.BookingPage;
        Get.offAllNamed(route);
      }
    } catch (ex) {
      throw ex;
    }
  }

  @override
  void onReady() {
    super.onReady();
    updateVersionIfNeeded();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
