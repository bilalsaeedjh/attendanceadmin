import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:attendanceadmin/screens/buildings/model.dart';
import 'package:attendanceadmin/screens/doorman/model.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:uuid/uuid.dart';

import 'state.dart';

class DoormanLogic extends GetxController {
  final DoormanState state = DoormanState();
  var _db = FirebaseFirestore.instance;

  //Change doorman Active/Inactive status while saving to Firestore
  RxBool doorManStatus = true.obs;

  //Deleting Doorman
  RxBool isDeleting = false.obs;
  deleteVisitorDoc(String id) async{
    isDeleting.value = true;
    await _db.collection('doormen').doc(id).delete().then((value){
      debugPrint("Deleted");
    });
    isDeleting.value = false;

  }

  //ChangeDoormanShowFilters
  RxBool showFilters = false.obs;
  changeDoormanShowFilters(bool value){
    showFilters.value = value;
    debugPrint("Doorman state to Firestore is ${doorManStatus.value.toString()}");
  }
  changeDoormanStatus (bool value) async{
    doorManStatus.value = value;
  }
  changeDoormanStatusAlsoFirestore (String doormanID, bool value) async{
    try {
      await FirebaseFirestore.instance.collection('doormen').doc(doormanID).update({
        'isActive':value
      });

    } catch (e) {
      debugPrint(e.toString());
    }

    doorManStatus.value = value;
  }

  //Total Doormen
  RxInt totalDoormen = 0.obs;


  //Get Doormens
  List<DoormanModel> doormens = <DoormanModel>[].obs;
  getDoormen() async{
    try {
       FirebaseFirestore.instance.collection('doormen').snapshots().listen((doormenss) {
         doormens.clear();
            doormenss.docs.forEach((element) {
              DoormanModel doorman = DoormanModel.fromJson(element.data());
              doormens.add(doorman);
            });
            doormens.toSet().toList();
            doormens.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
            totalDoormen.value = doormens.length;
          });
    } catch (e) {
      debugPrint(e.toString());
    }

  }

  //GET FILTERED DOORMEN
  List<DoormanModel> filteredDoormenList = <DoormanModel>[].obs;
  RxBool isSearching = false.obs;

  getFilteredRows(dynamic name) {
    filteredDoormenList.clear();


    doormens.forEach((element) {
      bool value = false;
      bool foundInUsername = false;
      bool foundInMobNum = false;
      bool foundInIdNum = false;
      if (element.userName!.toLowerCase().contains(name.toLowerCase())) {
        value = true;
        foundInUsername = true;
      } else if (element.mobileNumber!
          .toLowerCase()
          .contains(name.toLowerCase())) {
        value = true;
        foundInMobNum = true;
      } else if (element.idNumber!.toLowerCase().contains(name.toLowerCase())) {
        value = true;
        foundInIdNum = true;
      } else {}
      if (value == true) {
        if (filteredDoormenList.contains(element) != true) {
          filteredDoormenList.add(element);
          List<String> username = element.userName!.split(' ');
          String firstName = username[0];
          filteredDoormenList.toSet().toList();
          filteredDoormenList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        }
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInitr

    getDoormen();
    super.onInit();

  }


  var uuid = Uuid();

  Future<bool> saveDoormanToFirestore(String uid,DoormanModel doorman) async {

    bool valueIS = false;
    bool recordExist = false;

    if(doormens.isNotEmpty){
      doormens.forEach((element) {
        if(element.mobileNumber == doorman.mobileNumber){
          Constants.defaultToast("This phone number already exists");
          recordExist = true;
        }
        else if(element.idNumber == doorman.idNumber){
          Constants.defaultToast("This ID Number already exists");
          recordExist = true;
        }
        else if(element.userName == doorman.userName){
          Constants.defaultToast("This userName already exists");
          recordExist = true;
        }
      });
      if(recordExist == false){
        try {
          await _db.collection('doormen').doc(uid).set(doorman.toJson()).then((value) {
            debugPrint("My Doorman added is ${valueIS.toString()}");
            valueIS = true;
          });
        } catch (e) {
          print(e);
          valueIS = false;
        }
      }else{
        debugPrint("Duplicated record exists");
      }
    }else{
      try {
        await _db.collection('doormen').doc(uid).set(doorman.toJson()).then((value) {
          debugPrint("My Doorman added is ${valueIS.toString()}");
          valueIS = true;
        });
      } catch (e) {
        print(e);
        valueIS = false;
      }
    }



    return valueIS;
  }


}
