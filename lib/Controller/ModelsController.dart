import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Model/Models.dart';
import 'package:get/get.dart';

class ModelsController extends BaseController {
  Request request = Get.find();
  List<Models> lModels = [];
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
    fetchModels();
    searchText.listen((value) => filterModels());
  }

  fetchModels() async {
    statusRequest = StatusRequest.loading;
    var response =
        await request.getData('ExiirManagementAPI/GetModelsById/$brandId');
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      var data = response.fold((l) => null, (r) => r);
      if (data != null) {
        lModels = (data as List).map((item) => Models.fromJson(item)).toList();
        filterModels();
      }
    }
  }

  void filterModels() {
    if (searchText.value.isEmpty) {
      filteredModels.assignAll(List.from(lModels));
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
}
