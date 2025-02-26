import 'package:client_1/utils/helper/network_controller.dart';
import 'package:get/get.dart';

class GeneralBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkController());


  }
}
