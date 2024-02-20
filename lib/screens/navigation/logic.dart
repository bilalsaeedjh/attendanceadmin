import 'package:get/get.dart';

import 'state.dart';

class NavigationLogic extends GetxController {
  final NavigationState state = NavigationState();
  RxBool isNavigationLabel = true.obs;
  void changeNavigationLabel(bool value){
    isNavigationLabel.value = value;
    isNavigationLabel.refresh();
  }
}
