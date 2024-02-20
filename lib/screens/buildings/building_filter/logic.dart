import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class BuildingFilterLogic extends GetxController {
  final BuildingFilterState state = BuildingFilterState();





  //For getting active doormen from firestore
  RxBool buildingActiveStatus = true.obs;
  //For getting Inactive doormen from firestore
  RxBool buildingInactiveStatus = true.obs;

  changeActivebuildingStatus(bool value){
    buildingActiveStatus.value = value;
    debugPrint("Active state of Building is ${buildingActiveStatus.value.toString()}");
  }
  changeInactivebuildingStatus(bool value){
    buildingInactiveStatus.value = value;
    debugPrint("Inactive state of Building is ${buildingInactiveStatus.value.toString()}");
  }
}
