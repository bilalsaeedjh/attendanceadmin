import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/screens/buildings/model.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:uuid/uuid.dart';

import 'state.dart';

class BuildingsLogic extends GetxController {
  @override
  onInit(){
    getTotalBuildings();
    super.onInit();
  }

  var _db = FirebaseFirestore.instance;
  final BuildingsState state = BuildingsState();
  var uuid = Uuid();

  //Deleting building
  RxBool isDeleting = false.obs;
  deleteVisitorDoc(String id) async{
    isDeleting.value = true;
    await _db.collection('buildings').doc(id).delete().then((value){
      debugPrint("Deleted");
    });
    isDeleting.value = false;

  }

  //building Statuses

  //Change building Active/Inactive status while saving to Firestore
  RxBool showFilters = false.obs;
  RxBool buildingStatus = true.obs;


  changebuildingStatus (bool value){
    buildingStatus.value = value;
  }
  changeBuildingStatusAlsoFirestore (String buildingID, bool value) async{
    try {
      await FirebaseFirestore.instance.collection('buildings').doc(buildingID).update({
        'isActive':value
      });

    } catch (e) {
      debugPrint(e.toString());
    }

    buildingStatus.value = value;
    debugPrint("Doorman state to Firestore is ${buildingStatus.value.toString()}");
  }

  //Total Buildings
  RxInt totalBuildings = 0.obs;
  List<BuildingModel> buildingsList = <BuildingModel>[].obs;
  Future<void> getTotalBuildings () async{
    _db.collection('buildings').snapshots().listen((buildings) {
     /* event.docs.forEach((element) {
        debugPrint("-----------Building----------");
        debugPrint(element.data().toString());
      });*/

      buildingsList.clear();
      buildings.docs.forEach((element) {
        BuildingModel building = BuildingModel.fromJson(element.data());
        buildingsList.add(building);
        if(filteredBuildingsList.isNotEmpty){
          filteredBuildingsList.forEach((element) {
            if(element.id == building.id){
              if(element != building){
                element = building;
              }
            }
          });
        }
      });
      buildingsList.toSet().toList();
      buildingsList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      totalBuildings.value = buildingsList.length;

    });

    /*   await _db.collection('doormen').get().then((value){
      totalDoormen.value = value.docs.length;
    });*/
  }

  //GET FILTERED Buildings
  List<BuildingModel> filteredBuildingsList = <BuildingModel>[].obs;
  RxBool isSearching = false.obs;
  getSearchedBuildings(dynamic name) {
    filteredBuildingsList.clear();


    buildingsList.forEach((element) {
      bool value = false;
      if (element.buildingName!.toLowerCase().contains(name.toLowerCase())) {
        value = true;
      }
      else {}
      if (value == true) {
        if (filteredBuildingsList.contains(element) != true) {
          filteredBuildingsList.add(element);
          filteredBuildingsList.toSet().toList();
          filteredBuildingsList.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
        }
      }
    });
  }

  //Save building data to Firestore
  Future<bool> saveBuildingToFirestore(String name, String address,bool isActive) async{
    String uid = uuid.v1();
    bool valueIS = false;
    bool recordExist = false;

    if(buildingsList.isNotEmpty){
      buildingsList.forEach((element) {
        if(element.address == address){
          Constants.defaultToast("This address already exists");
          recordExist = true;
        }
      });
      if(recordExist == true){
        debugPrint("Duplicated building exist");
      }else{
        try {
          await _db.collection('buildings').doc(uid).set({
            'id':uid,
            'name':name,
            'address':address,
            'isActive':isActive,
            'createdAt':DateTime.now(),
            'updatedAt': DateTime.now(),
          }).then((value){
            debugPrint("My value is ${valueIS.toString()}");
            valueIS = true;
          });
        } catch (e) {
          print(e);
          valueIS = false;
        }
      }
    }
    else{
      try {
        await _db.collection('buildings').doc(uid).set({
          'id':uid,
          'name':name,
          'address':address,
          'isActive':isActive,
          'createdAt':DateTime.now(),
          'updatedAt': DateTime.now(),
        }).then((value){
          debugPrint("My value is ${valueIS.toString()}");
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
