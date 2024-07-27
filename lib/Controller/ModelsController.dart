// import 'package:ExiirEV/Controller/BaseController.dart';
// import 'package:ExiirEV/Core/Class/Request.dart';
// import 'package:ExiirEV/Core/Class/StatusRequest.dart';
// import 'package:ExiirEV/Core/Functions/Handingdata.dart';
// import 'package:ExiirEV/Model/Models.dart';
// import 'package:get/get.dart';

// class ModelsController extends BaseController {
//   Request request = Get.find();
//   List<Models> lModels = [];
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
//         lModels = (data as List).map((item) => Models.fromJson(item)).toList();
//         filterModels();
//       }
//     }
//   }

//   void filterModels() {
//     if (searchText.value.isEmpty) {
//       filteredModels.assignAll(List.from(lModels));
//     } else {
//       filteredModels.assignAll(lModels.where((models) {
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
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Model/Models.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModelsController extends BaseController {
  final translationController = Get.put(TranslationController());
  Request request = Get.find();
  // List<Models> lModels = [];
    RxList<Models> lModels = <Models>[].obs;

  RxList<Models> filteredModels = <Models>[].obs;
  RxString searchText = ''.obs;
  StatusRequest statusRequests = StatusRequest.loading;
  int? brandId;
  String? stationId;
  String? type;
    ModelsController({
    required this.brandId,
    this.stationId,
    this.type,
  });
  @override
  void onInit() {
    super.onInit();
    loadModels();
    searchText.listen((value) => filterModels());
        statusRequest = StatusRequest.loading;

  }

  Future<void> loadModels() async {
    final prefs = await SharedPreferences.getInstance();
    final storedModels = prefs.getString('Models');

    if (storedModels != null) {
       final List<dynamic> data = json.decode(storedModels);
      lModels.value = data.map((item) => Models.fromJson(item)).toList();
      filterModels();
    } else {
       fetchModels();
    }
  }

  Future<void> fetchModels() async {
    update();

    var response = await request.getData('ExiirManagementAPI/GetModelsById/$brandId');

    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        lModels.value =
            (data as List).map((item) => Models.fromJson(item)).toList();
        filterModels();

        // Store in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('Models', json.encode(lModels.map((e) => e.toJson()).toList()));
      }
    }

    update();
  }

  void filterModels() {
    if (searchText.value.isEmpty) {
      filteredModels.value = lModels;
    } else {
         filteredModels.assignAll(lModels.where((models) {
        final brNameLower = models.moName!.toLowerCase();
        final brNameArLower = models.moNameAr!.toLowerCase();
        final searchLower = searchText.value.toLowerCase();
        return brNameLower.contains(searchLower) ||
            brNameArLower.contains(searchLower);
      }).toList());
    }
  }

  Future<void> updateModelsIfNeeded() async {
    var response = await request.getData('ExiirManagementAPI/GetModelsById/$brandId');
    var data = response.fold((l) => null, (r) => r);

    if (data != null) {
      List<Models> newModels = (data as List).map((item) => Models.fromJson(item)).toList();
      // Compare with current list
      if (newModels.length != lModels.length || !newModels.every((Model) => lModels.contains(Model))) {
        lModels.value = newModels;
        filterModels();

        // Update SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('Models', json.encode(lModels.map((e) => e.toJson()).toList()));
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
updateModelsIfNeeded();  }

  @override
  void onClose() {
    super.onClose();
  }
}
