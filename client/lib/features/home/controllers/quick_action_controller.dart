import 'package:get/get.dart';


class QuickActionController extends GetxController{
  final carousalCurrentIndex = 0.obs;
  

  void udpatePageIndicator(index) {
    carousalCurrentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }
}