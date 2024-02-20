import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'state.dart';

class Visitor_filterLogic extends GetxController {
  final Visitor_filterState state = Visitor_filterState();
  //For getting active doormen from firestore
  RxBool visitorActiveStatus = true.obs;
  //For getting Inactive doormen from firestore
  RxBool visitorInactiveStatus = true.obs;
  //Is Visitor Filters active and searching


  changeActivevisitorStatus(bool value){
    visitorActiveStatus.value = value;
    debugPrint("Active state of visitor is ${visitorActiveStatus.value.toString()}");
  }
  changeInactivevisitorStatus(bool value){
    visitorInactiveStatus.value = value;
    debugPrint("Inactive state of visitor is ${visitorInactiveStatus.value.toString()}");
  }

  RxBool Date = true.obs;


}
