import 'package:ExiirEV/Controller/BaseController.dart';
import 'package:ExiirEV/Controller/TranslationController.dart';
import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:ExiirEV/Core/Class/StatusRequest.dart';
import 'package:ExiirEV/Core/Functions/Handingdata.dart';
import 'package:ExiirEV/Model/Brands.dart';
import 'package:get/get.dart';

class BrandsController extends BaseController {
  final translationController = Get.put(TranslationController());
  Request request = Get.find();
  RxList<Brands> lBrands = <Brands>[].obs;
  RxList<Brands> filteredBrands = <Brands>[].obs;
  RxString searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBrands();
    searchText.listen((value) => filterBrands());
  }

  fetchBrands() async {
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


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
