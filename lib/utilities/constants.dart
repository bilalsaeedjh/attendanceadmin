import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/screens/buildings/building_filter/view.dart';
import 'package:attendanceadmin/screens/buildings/logic.dart';
import 'package:attendanceadmin/screens/doorman/doorman_filter/view.dart';
import 'package:attendanceadmin/screens/doorman/logic.dart';
import 'package:attendanceadmin/screens/visitors/logic.dart';
import 'package:attendanceadmin/screens/visitors/visitor_filter/view.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/languages.dart';
import 'package:flutter/material.dart';

class Constants {
  static const double textH1Size = 32;
  static const double textH2Size = 28;
  static const double textH5Size = 19;
  static const double textH6Size = 16;
  static const double textH7Size = 14;
  static const double basicPaddingValue = 10;
  static const primaryOrangeColor = Color(0xFFf06735);
  static const primaryOrangeLightColor = Color(0xFFff9862);

  static var primaryBoldStyle = TextStyle(
      color: primaryBlackColor,
      fontSize: textH1Size,
      fontWeight: FontWeight.bold);
  static const primaryBlackColor = Color(0xFF414142);

  static String LanguageKey(String value) {
    return Languages.skeleton_language_objects[Config.app_language.value]![value]!;
  }

  static final logicDoorman = Get.put(DoormanLogic());
  static final visitorsLogic = Get.put(VisitorsLogic());

  static Widget filterForDoorman(Size size) {
    return Align(
      alignment: Alignment.topRight,
      child: AnimatedContainer(
          height: logicDoorman.showFilters.value ? size.height : 23,
          width: logicDoorman.showFilters.value ? size.width * 0.18 : 70,
          duration: Duration(milliseconds: 700),
          curve: Curves.bounceOut,
          child: logicDoorman.showFilters.value
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          bool value = logicDoorman.showFilters.value;
                          logicDoorman.showFilters(!value);
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          height: 25,
                          width: 70,
                          //margin:EdgeInsets.only(right:16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Constants.primaryOrangeLightColor),
                          child: Row(
                            children: [
                              Icon(
                                Icons.keyboard_arrow_left_outlined,
                                color: Colors.black87,
                              ),
                              Text(
                                Constants.LanguageKey('filter'),
                                style: TextStyle(color: Colors.black87),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.grey,
                        elevation: 8.0,
                        child: Container(
                          height: size.height,
                          color: Colors.white,
                          alignment: Alignment.topLeft,
                          child: DoormanFilterPage(),
                        ),
                      ),
                    ],
                  ),
                )
              : InkWell(
                  onTap: () {
                    bool value = logicDoorman.showFilters.value;
                    logicDoorman.showFilters(!value);
                  },
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: 23,
                    width: 70,
                    //margin:EdgeInsets.only(right:16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Constants.primaryOrangeColor),
                    child: Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.white,
                        ),
                        Text(
                          Constants.LanguageKey('filter'),
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }

  static Widget filterForVisitor(Size size) {
    return Align(
      alignment: Alignment.topRight,
      child: AnimatedContainer(
          height: visitorsLogic.showFilters.value ? size.height : 23,
          width: visitorsLogic.showFilters.value ? size.width * 0.18 : 70,
          duration: Duration(milliseconds: 700),
          curve: Curves.bounceOut,
          child: visitorsLogic.showFilters.value
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          bool value = visitorsLogic.showFilters.value;
                          visitorsLogic.showFilters(!value);
                          visitorsLogic.isFiltering.value =
                              visitorsLogic.showFilters.value;
                          visitorsLogic.isFilteringSearching.value =
                              visitorsLogic.showFilters.value;
                          visitorsLogic.filteredVisitors.clear();
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          height: 25,
                          width: 70,
                          //margin:EdgeInsets.only(right:16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Constants.primaryOrangeLightColor),
                          child: Row(
                            children: [
                              Icon(
                                Icons.keyboard_arrow_left_outlined,
                                color: Colors.black87,
                              ),
                              Text(
                                Constants.LanguageKey('filter'),
                                style: TextStyle(color: Colors.black87),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.grey,
                        elevation: 8.0,
                        child: Container(
                          height: size.height,
                          color: Colors.white,
                          alignment: Alignment.topLeft,
                          child: Visitor_filterPage(),
                        ),
                      ),
                    ],
                  ),
                )
              : InkWell(
                  onTap: () {
                    bool value = visitorsLogic.showFilters.value;
                    visitorsLogic.showFilters(!value);

                 /*   visitorsLogic.isSearching.value =
                        visitorsLogic.showFilters.value;*/
                    visitorsLogic.isFiltering.value =
                        visitorsLogic.showFilters.value;
                    visitorsLogic.isFilteringSearching.value =
                        visitorsLogic.showFilters.value;
                    visitorsLogic.getFilteredVisitors();
                    //debugPrint("FilteredVisitor are cleared");
                  },
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: 23,
                    width: 70,
                    //margin:EdgeInsets.only(right:16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Constants.primaryOrangeColor),
                    child: Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.white,
                        ),
                        Text(
                          Constants.LanguageKey('filter'),
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }

  static Widget staticContainerForAlert(String title, String value){
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: TextStyle(color: Colors.grey.shade500,fontSize: 14),),
          Text(value,style: TextStyle(color: Colors.black87,fontSize: 14),),
          Divider(color: Colors.grey,)
        ],
      ),
    );
  }

  static Future<void> AlertDialogBeautiful(BuildContext context, String date,
      {String? id,
      bool? isVisitor,
      bool? isDoorman,
      bool? isBuilding,
      bool? assetImage,
      String? image,
      String? name,
      String? reason,
      String? mobileNumber,
      String? idNumber,
      String? checkIn,
      String? checkOut,
      String? doorman,
      String? address,
      bool? status,
      String? buildingName}) {

    if (isVisitor == true) {
      return showDialog<void>(
        context: context,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(10.0))),
            content: Builder(
              builder: (context) {
                var height = MediaQuery.of(context).size.height;
                var width = MediaQuery.of(context).size.width;
                return Container(
                  height: height * 0.6,
                  width: width * 0.5,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            image == null
                                ? Container()
                                : assetImage == true
                                ? ClipOval(
                                child: Container(
                                    height: 115,
                                    width: 115,
                                    child: Image.asset(image!,fit:BoxFit.fill)))
                                : ClipOval(
                                child: Container(
                                    height: 115,
                                    width: 115,
                                    child: Image.network(image!,fit: BoxFit.fill,))),
                            name == null
                                ? Text('name null')
                                : Text(
                              name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.black87),
                            ),
                            Text(
                              date,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                staticContainerForAlert("Mobile Number",mobileNumber!),
                                staticContainerForAlert("ID Number",idNumber!),
                                staticContainerForAlert("Check-In",checkIn!),
                                staticContainerForAlert("Check-Out",checkOut!),
                                staticContainerForAlert("Doorman",doorman!),
                                staticContainerForAlert("Reason",reason!),



                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
            actions: <Widget>[

            ],
          );
        },
      );
    } else if (isDoorman == true) {
      debugPrint("Doorman tile pressed");
     /* return showDialog<void>(
        context: context,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Is Doorman'),
            content: Text(date),
            actions: <Widget>[
              TextButton(
                child: Text('buttonText'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );*/
    } else {
      debugPrint("Building  tile pressed");
     /* return showDialog<void>(
        context: context,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Is Building'),
            content: Text(date),
            actions: <Widget>[
              TextButton(
                child: Text('buttonText'),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),
            ],
          );
        },
      );*/
    }
    return Future.delayed(Duration(milliseconds: 100));/*showDialog<void>(context: context, builder: (context){
      return Container(

      );
    });*/
  }

  static final logicBuilding = Get.put(BuildingsLogic());

  static Widget filterForBuilding(Size size) {
    return Align(
      alignment: Alignment.topRight,
      child: AnimatedContainer(
          height: logicBuilding.showFilters.value ? size.height : 23,
          width: logicBuilding.showFilters.value ? size.width * 0.18 : 70,
          duration: Duration(milliseconds: 700),
          curve: Curves.bounceOut,
          child: logicBuilding.showFilters.value
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          bool value = logicBuilding.showFilters.value;
                          logicBuilding.showFilters(!value);
                        },
                        child: Container(
                          alignment: Alignment.topLeft,
                          height: 25,
                          width: 70,
                          //margin:EdgeInsets.only(right:16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Constants.primaryOrangeLightColor),
                          child: Row(
                            children: [
                              Icon(
                                Icons.keyboard_arrow_left_outlined,
                                color: Colors.black87,
                              ),
                              Text(
                                Constants.LanguageKey('filter'),
                                style: TextStyle(color: Colors.black87),
                              )
                            ],
                          ),
                        ),
                      ),
                      Card(
                        shadowColor: Colors.grey,
                        elevation: 8.0,
                        child: Container(
                          height: size.height,
                          color: Colors.white,
                          alignment: Alignment.topLeft,
                          child: BuildingFilterPage(),
                        ),
                      ),
                    ],
                  ),
                )
              : InkWell(
                  onTap: () {
                    bool value = logicBuilding.showFilters.value;
                    logicBuilding.showFilters(!value);
                  },
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: 23,
                    width: 70,
                    //margin:EdgeInsets.only(right:16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Constants.primaryOrangeColor),
                    child: Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.white,
                        ),
                        Text(
                          Constants.LanguageKey('filter'),
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }

  static void defaultToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: Constants.primaryOrangeColor,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG);
  }

  static String get_doormanName(String doormanId) {
    String name = '';
    logicDoorman.doormens.forEach((element) {
      if (element.id == doormanId) {
        name = element.userName!;
      }
    });
    return name;
  }

  static Future<bool> getBuildingStatus(String id) async{
    bool value = false;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('buildings').doc(id).get();
    if(documentSnapshot.exists){
      value = documentSnapshot['isActive'];
      debugPrint("Building status = $value");
    }
    return value;
  }
}
