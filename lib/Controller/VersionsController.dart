import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Model/Models.dart';
import 'package:ExiirEV/Model/Versions.dart';
import 'package:get/get.dart';

class VersionsController extends GetxController {
Request request = Get.find();
  List<Versions> lVersions = [];
  RxList<Versions> filteredVersions = <Versions>[].obs;
  RxString searchText = ''.obs;
  StatusRequest statusRequest = StatusRequest.loading;
  int? ModelId;

  VersionsController({required this.ModelId});

  @override
  void onInit() {
    super.onInit();
    fetchModels();
    searchText.listen((value) => filterVersion());
  }

  fetchModels() async {
    statusRequest = StatusRequest.loading;
    var response = await request.getData('ExiirManagementAPI/GetVersionsByModelId/$ModelId');
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        lVersions = (data as List).map((item) => Versions.fromJson(item)).toList();
        filterVersion();
      }
    }
  }

  void filterVersion() {
    if (searchText.value.isEmpty) {
      filteredVersions.assignAll(List.from(lVersions));
    } else {
      filteredVersions.assignAll(lVersions.where((models) {
        final brNameLower = models.veName!.toLowerCase();
        final brNameArLower = models.veName!.toLowerCase();
        final searchLower = searchText.value.toLowerCase();
        return brNameLower.contains(searchLower) || brNameArLower.contains(searchLower);
      }).toList());
    }
  }
}
