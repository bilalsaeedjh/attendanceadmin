import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/screens/visitors/model.dart';
import 'package:intl/intl.dart';
import 'package:attendanceadmin/screens/visitors/visitor_filter/logic.dart';

import 'state.dart';

class VisitorsLogic extends GetxController {
  final VisitorsState state = VisitorsState();
  final logicFilter = Get.put(Visitor_filterLogic());
  var _db = FirebaseFirestore.instance;

  @override
  onInit() {
    //Enable this function when collecion of Visitors is created
    getVisitors();
    super.onInit();
  }

  RxBool isDeleting = false.obs;

  deleteVisitorDoc(String id) async {
    isDeleting.value = true;
    await _db.collection('checkInVisitors').doc(id).delete().then((value) {
      debugPrint("Deleted");
    });
    isDeleting.value = false;
  }

  //ChangeDoormanShowFilters
  RxBool showFilters = false.obs;

  changeVisitorShowFilters(bool value) {
    isFiltering.value = value;
    showFilters.value = value;
  }

  //Total Visitors
  RxInt totalVisitors = 0.obs;

  //Get Visitors
  List<VisitorModel> visitors = <VisitorModel>[].obs;

  getVisitors() async {
    try {
      _db.collection('checkInVisitors').snapshots().listen((visitorss) {
        visitors.clear();
        visitorss.docs.forEach((element) {
          VisitorModel visitor = VisitorModel().fromJson(element.data());
          visitors.add(visitor);
        });
        visitors.toSet().toList();
        totalVisitors.value = visitors.length;
      });
    } catch (e) {
      print(e);
    }
  }

  List<VisitorModel> filteredVisitors = <VisitorModel>[].obs;

  //Visitors in Filters

  Rx<DateTime> dateRangeStart = DateTime(2020).obs;
  Rx<DateTime> dateRangeEnd = DateTime(2026).obs;

  Rx<DateTime> dateTimeStart = DateTime.now().obs;
  Rx<DateTime> dateTimeEnd = DateTime(2026).obs;

  Rx<TimeOfDay> timeStart = TimeOfDay(hour: 01, minute: 00).obs;
  Rx<TimeOfDay> timeEnd = TimeOfDay(hour:3, minute: 59).obs;

  RxList<dynamic> selectedDoormen = [].obs;

  RxBool isFiltering = false.obs;
  RxBool isFilteringSearching = false.obs;
  RxString searchingText = ''.obs;
  RxDouble filterProgress = 0.0.obs;

  getFilteredVisitors() {
    filteredVisitors.clear();

    debugPrint("----------------FilteredVisitorValues are -------------");
    debugPrint("Length of selectedDoormen ${selectedDoormen.length}");

    selectedDoormen.forEach((element) {
      debugPrint("${element} is Selected Doorman\n");
    });
    debugPrint("Came after");

    List<VisitorModel> localFilteredVisiters = [];
    debugPrint("Came after2");
    localFilteredVisiters.addAll(visitors);
    debugPrint("Came after3");

    localFilteredVisiters.forEach((element) {

      //What these conditions mean:
      //As we know that our date ranges, time ranges and doorman are observables
      //And we have set the values of these to maximum, which means all Elements that would be created will lie in the
      // by default given ranges given to these observable values.
      //So, therefore we have set conditions to these observables.
      //Now, first we need to check that whether the record we are fetching does lie in the same
      // range or not. If yes then check for time, if the record lies in the observable time range or not
      // And then finally if row being fetched contains the doorman selected or not

      //We have comparedCheckedIn

      //Checking Date Range
      if(element.checkIn != null){
        if ((element.checkIn!.isAfter(dateTimeStart.value) &&
            element.checkIn!.isBefore(dateTimeEnd.value)) ||
            (element.checkIn!.year == dateTimeStart.value.year &&
                element.checkIn!.month == dateTimeStart.value.month &&
                element.checkIn!.day == dateTimeStart.value.day) ||
            (element.checkIn!.year == dateTimeEnd.value.year &&
                element.checkIn!.month == dateTimeEnd.value.month &&
                element.checkIn!.day == dateTimeEnd.value.day)) {
          debugPrint("----------------------Date is Working");
          //Checking Time Range i.e if the record time is greater than startTime and lessThan EndTime

          TimeOfDay userTime = TimeOfDay.fromDateTime(element.checkIn!);
          double userTime2 =(userTime.hour.toDouble() +
              userTime.minute.toDouble() / 60);


          double timeStartSec =(timeStart.value.hour.toDouble() +
              timeStart.value.minute.toDouble() / 60);
          double timeEndSec =(timeEnd.value.hour.toDouble() +
              timeEnd.value.minute.toDouble() / 60);
          debugPrint("${userTime2} User Record \n $timeStartSec Time Start \n $timeEndSec Time End");

          if(userTime2>=timeStartSec && userTime2 <=timeEndSec){

            //if Any doormanIsSelected or not
            if (selectedDoormen.isEmpty) {
              debugPrint("----------------------Doorman is Empty");
              filteredVisitors.contains(element)
                  ? debugPrint("========Element exist for this ID @*@*@*@*@")
                  : filteredVisitors.add(element);
            } else {
              debugPrint("----------------------Doorman is not Empty");
              selectedDoormen.forEach((id) {
                localFilteredVisiters.forEach((element) {
                  if (element.lastDoormanId == id) {
                    if (filteredVisitors.contains(element)) {
                      debugPrint(
                          "2nd========Element Already Exist for this ID @*@*@*@*@");
                    } else {
                      filteredVisitors.add(element);
                    }
                  } else {}
                });
              });
            }
          }

        }
      }else{
        debugPrint("Eleemnt check in is null");
      }

    });
    if (filteredVisitors.isEmpty) {
    } else {
      isFiltering.value = false;
    }
    debugPrint("Element in filtered list are: ${filteredVisitors.length}");
  }

  //
  //GET FILTERED Visitors
  List<VisitorModel> searchedVisitorList = <VisitorModel>[].obs;
  RxBool isSearching = false.obs;

  getSearchedVisitors(dynamic name) {
    searchedVisitorList.clear();


    visitors.forEach((element) {
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
        if (searchedVisitorList.contains(element) != true) {
          searchedVisitorList.add(element);
          List<String> username = element.userName!.split(' ');
          String firstName = username[0];
          searchedVisitorList.toSet().toList();
          searchedVisitorList.sort((a, b) => b.checkIn!.compareTo(a.checkIn!));
        }
      }
    });
  }

}
