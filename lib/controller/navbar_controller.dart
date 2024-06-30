import 'package:get/get.dart';

class NavBarController extends GetxController {
  var currentTab = 0.obs;

  void pageChange(int screen) {
    currentTab.value = screen;
  }
}
