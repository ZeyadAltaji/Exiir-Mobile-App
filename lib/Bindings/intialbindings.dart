import 'package:ExiirEV/Core/Class/Request.dart';
import 'package:get/get.dart';

import '../Controller/ConnectivityController.dart';

class InitialBindings extends Bindings {
  var connectivityController = ConnectivityController();

  @override
  void dependencies() {
    Get.put(Request(connectivityController));
  }
}
