import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class DoormanFilterLogic extends GetxController {
  final DoormanFilterState state = DoormanFilterState();

  //For getting active doormen from firestore
  RxBool doorManActiveStatus = true.obs;
  //For getting Inactive doormen from firestore
  RxBool doorManInactiveStatus = true.obs;

  changeActiveDoormanStatus(bool value){
    doorManActiveStatus.value = value;
    debugPrint("Active state of Doorman is ${doorManActiveStatus.value.toString()}");
  }
  changeInactiveDoormanStatus(bool value){
    doorManInactiveStatus.value = value;
    debugPrint("Inactive state of DoorMan is ${doorManInactiveStatus.value.toString()}");
  }
}
