import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:attendanceadmin/screens/buildings/logic.dart';
import 'package:attendanceadmin/screens/buildings/model.dart';
import 'package:attendanceadmin/screens/doorman/doorman_filter/logic.dart';
import 'package:attendanceadmin/screens/doorman/doorman_filter/view.dart';
import 'package:attendanceadmin/screens/doorman/model.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/languages.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import 'logic.dart';

class DoormanPage extends StatefulWidget {
  const DoormanPage({Key? key}) : super(key: key);

  @override
  State<DoormanPage> createState() => _DoormanPageState();
}

class _DoormanPageState extends State<DoormanPage> {
  final logic = Get.put(DoormanLogic());
  final logicBuilding = Get.put(BuildingsLogic());
  final logicFilter = Get.put(DoormanFilterLogic());
  final state = Get.find<DoormanLogic>().state;

  var idFormatter = MaskTextInputFormatter(
      mask: '##########',
      filter: {"#": RegExp(r'[a-zA-Z0-9]')},
      type: MaskAutoCompletionType.lazy);
  var mobileFormatter = MaskTextInputFormatter(
      mask: '+591########',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  //initState ()
/*  Future<void> getBuildingsNames() async {
    await logic.getBuildingsNames();
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* getBuildingsNames();*/
  }

  //search Query
  var _searchController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  //requiredControllers
  var doormanName = TextEditingController();
  String selectedBuildingId = '';
  String selectedBuildingName = '';
  var userName = TextEditingController();
  var password = TextEditingController();
  var mobileNum = TextEditingController();
  var idNum = TextEditingController();

  Widget rowCard(BuildContext context, Size size, int index) {
    return Card(
      elevation: 8.0,
      child: Container(
        width: MediaQuery.of(context).size.width*1.3,
        child: Row(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(left: 3, right: 10),
              color: Colors.grey.shade100,
              width: 55,
              height: 20,
              child: Text("${(index + 1).toString()}"),
            ),
            Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,
                child: Text(
                  logic.doormens[index].doormanName!,
                  overflow: TextOverflow.ellipsis,
                )
                ), //id
            Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,
                child: Text(
                  logic.doormens[index].userName!,
                  overflow: TextOverflow.ellipsis,
                )

                ), //id
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: Text(logic.doormens[index].buildingName!),
            ),
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: Text(logic.doormens[index].password!),
            ),
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: Text(logic.doormens[index].mobileNumber!),
            ),
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: Text(logic.doormens[index].idNumber!),
            ),
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: logic.doormens[index].isActive!
                  ? InkWell(
                      onTap: () async {
                        bool value = logic.doormens[index].isActive!;
                        value = !value;
                        logic.changeDoormanStatusAlsoFirestore(
                            logic.doormens[index].id.toString(), value);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 105,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                        ),
                        child: Text(
                          Constants.LanguageKey("active"),
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        bool value = logic.doormens[index].isActive!;
                        value = !value;
                        logic.changeDoormanStatusAlsoFirestore(
                            logic.doormens[index].id.toString(), value);

                        /* try {
                                     await FirebaseFirestore.instance.collection('doormen').doc(logic.doormens[index].id).update({
                                                                            'isActive':!logic.doormens[index]!.isActive!
                                                                          });
                                     debugPrint("----------Status of Doorman Changed ----------");
                                     debugPrint("Doorman id: ${logic.doormens[index].id}");
                                     debugPrint("Doorman name: ${logic.doormens[index].doormanName}");
                                   } catch (e) {
                                     debugPrint(e.toString());
                                   }*/
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 105,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade200,
                        ),
                        child: Text(
                            Constants.LanguageKey("inActive"),
                          style: TextStyle(color: Colors.grey.shade900),
                        ),
                      ),
                    ),
            ),
            Obx(() {
              return Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,

                // child: Text('dOORMAN')
                child: Row(children: [
                  AnimatedContainer(
                      height: logic.isDeleting.value ? 80 : 40,
                      width: logic.isDeleting.value ? 80 : 40,
                      curve: Curves.bounceOut,
                      duration: Duration(milliseconds: 400),
                      child: !logic.isDeleting.value
                          ? IconButton(
                              onPressed: () async{
                                bool value = await Get.defaultDialog(
                                    title: '',
                                    content: Column(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/redBin.svg",
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          Languages.skeleton_language_objects[Config.app_language.value]!['sure']!,
                                          style: TextStyle(
                                              fontSize: Constants.textH6Size,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(onPressed: (

                                                ){
                                              Navigator.of(context).pop(true);
                                            }, child: Text(Constants.LanguageKey('yes'))),
                                            SizedBox(width: 12,),
                                            TextButton(onPressed: (){
                                              Navigator.of(context).pop(false);
                                            }, child: Text(Constants.LanguageKey('no'))),
                                          ],
                                        )

                                      ],
                                    )

                                );
                                if(value == true){
                                  logic.deleteVisitorDoc(logic.doormens[index].id!);
                                }else{
                                  debugPrint("Didn't deleted");
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Constants.primaryOrangeColor,
                              ))
                          : SvgPicture.asset(
                              'redBin.svg',
                            ))
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }
  Widget rowCardFiltered(BuildContext context, Size size, int index) {
    return Card(
      elevation: 8.0,
      child: Row(
        children: [
          Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: Text(logic.filteredDoormenList[index].userName!)), //id
          Container(
            alignment: Alignment.center,
            height: 45,
            width: 200,
            child: Text(logic.filteredDoormenList[index].buildingName!),
          ),
          Container(
            alignment: Alignment.center,
            height: 45,
            width: 200,
            child: Text(logic.filteredDoormenList[index].password!),
          ),
          Container(
            alignment: Alignment.center,
            height: 45,
            width: 200,
            child: Text(logic.filteredDoormenList[index].mobileNumber!),
          ),
          Container(
            alignment: Alignment.center,
            height: 45,
            width: 200,
            child: Text(logic.filteredDoormenList[index].idNumber!),
          ),
          Container(
            alignment: Alignment.center,
            height: 45,
            width: 200,
            child: logic.filteredDoormenList[index].isActive!
                ? InkWell(
                    onTap: () async {
                      bool value = logic.filteredDoormenList[index].isActive!;
                      value = !value;
                      logic.changeDoormanStatusAlsoFirestore(
                          logic.filteredDoormenList[index].id.toString(),
                          value);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 105,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      child: Text(
                        Constants.LanguageKey("active"),
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      bool value = logic.filteredDoormenList[index].isActive!;
                      value = !value;
                      logic.changeDoormanStatusAlsoFirestore(
                          logic.filteredDoormenList[index].id.toString(),
                          value);

                      /* try {
                                   await FirebaseFirestore.instance.collection('doormen').doc(logic.doormens[index].id).update({
                                                                          'isActive':!logic.doormens[index]!.isActive!
                                                                        });
                                   debugPrint("----------Status of Doorman Changed ----------");
                                   debugPrint("Doorman id: ${logic.doormens[index].id}");
                                   debugPrint("Doorman name: ${logic.doormens[index].doormanName}");
                                 } catch (e) {
                                   debugPrint(e.toString());
                                 }*/
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 105,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      child: Text(
                        Constants.LanguageKey("inActive"),
                        style: TextStyle(color: Colors.grey.shade900),
                      ),
                    ),
                  ),
          ),
          Obx(() {
            return Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,

              // child: Text('dOORMAN')
              child: Row(children: [
                AnimatedContainer(
                    height: logic.isDeleting.value ? 80 : 40,
                    width: logic.isDeleting.value ? 80 : 40,
                    curve: Curves.bounceOut,
                    duration: Duration(milliseconds: 400),
                    child: !logic.isDeleting.value
                        ? IconButton(
                            onPressed: () {
                              logic.deleteVisitorDoc(
                                  logic.filteredDoormenList[index].id!);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Constants.primaryOrangeColor,
                            ))
                        : SvgPicture.asset(
                            'redBin.svg',
                          ))
              ]),
            );
          }),
        ],
      ),
    );
  }
  Widget doorManData(BuildContext context, Size size) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        Container(
          width: size.width * 1.15,
          height: size.height,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              SizedBox(
                width: size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
//margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 310,

                      child: Text(Constants.LanguageKey('doorMan'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
//margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.centerLeft,
                      height: 35,
                      width: 200,
                      padding: EdgeInsets.only(left: 20),


                      child: Text(Constants.LanguageKey('dName'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
//margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 100,
                      child: Text(Constants.LanguageKey('dBname'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
//margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 290,
                      child: Text(Constants.LanguageKey('pswrd2'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
//margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 125,
                      child: Text(Constants.LanguageKey('dMnum'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
//margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 245,
                      child: Text(Constants.LanguageKey('IdNum'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
//margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 180,
                      child: Text(Constants.LanguageKey('status'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.width,
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                  height: size.height,
                  width: size.width * 1.2,
                  child: ListView.builder(
                    itemCount: logic.doormens.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Obx(() {
                        return SingleChildScrollView(
                            child: logicFilter.doorManActiveStatus.value ==
                                        true &&
                                    logicFilter.doorManInactiveStatus.value ==
                                        false
                                ? logic.doormens[index].isActive == true
                                    ? rowCard(context, size, index)
                                    : null
                                : logicFilter.doorManActiveStatus.value ==
                                            false &&
                                        logicFilter
                                                .doorManInactiveStatus.value ==
                                            true
                                    ? logic.doormens[index].isActive == true
                                        ? null
                                        : rowCard(context, size, index)
                                    : logicFilter.doorManActiveStatus.value ==
                                                true &&
                                            logicFilter.doorManInactiveStatus
                                                    .value ==
                                                true
                                        ? rowCard(context, size, index)
                                        : null);
                      });
                    },
                  )),

            ],
          ),
        )
      ],
    );
  }
  Widget doorManDataFiltered(BuildContext context, Size size) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        Container(
          width: size.width * 1.15,
          height: size.height,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${Constants.LanguageKey('recordsFound')}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "${logic.filteredDoormenList.length}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 200,

                      child: Text(Constants.LanguageKey('dName'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 200,
                      child: Text(Constants.LanguageKey('dBname'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 200,
                      child: Text(Constants.LanguageKey('pswrd2'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 200,
                      child: Text(Constants.LanguageKey('dMnum'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 200,
                      child: Text(Constants.LanguageKey('IdNum'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                      alignment: Alignment.center,
                      height: 35,
                      width: 200,
                      child: Text(Constants.LanguageKey('status'),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.width,
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                  height: size.height,
                  width: size.width,
                  child: ListView.builder(
                    itemCount: logic.filteredDoormenList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Obx(() {
                        return SingleChildScrollView(
                            child: logicFilter.doorManActiveStatus.value ==
                                        true &&
                                    logicFilter.doorManInactiveStatus.value ==
                                        false
                                ? logic.filteredDoormenList[index].isActive ==
                                        true
                                    ? rowCardFiltered(context, size, index)
                                    : null
                                : logicFilter.doorManActiveStatus.value ==
                                            false &&
                                        logicFilter
                                                .doorManInactiveStatus.value ==
                                            true
                                    ? logic.filteredDoormenList[index]
                                                .isActive ==
                                            true
                                        ? null
                                        : rowCardFiltered(context, size, index)
                                    : logicFilter.doorManActiveStatus.value ==
                                                true &&
                                            logicFilter.doorManInactiveStatus
                                                    .value ==
                                                true
                                        ? rowCardFiltered(context, size, index)
                                        : null);
                      });
                    },
                  )),
            ],
          ),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<String> names = [];
    logicBuilding.buildingsList.forEach((element) {
      names.add(element.buildingName!);
    });

    return SingleChildScrollView(
      child: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            //This Container contains alertBox for adding doorman in the AlertDialog box
            Expanded(
              flex: 0,
              child: Container(
                height: 50,
                width: size.width,
                //margin: EdgeInsets.all(05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //alignment: Alignment.center,
                      width: 270,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: Colors.grey.shade200,
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        onChanged: (dynamic val) {
                          if (val != null) {
                            logic.isSearching.value = true;
                            if (val!.length >= 1) {
                              logic.getFilteredRows(val);
                            } else {
                              logic.isSearching.value = false;
                              logic.filteredDoormenList.clear();
                              logic.filteredDoormenList.clear();
                              _searchController.clear();
                              logic.isSearching.value = false;
                              logic.isSearching.value = false;
                            }
                          }
                        },
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: Languages
                              .skeleton_language_objects[
                          Config.app_language.value]!['search_doorman_building']!,/*"${Languages.skeleton_language_objects[Config
                              .app_language]!['add_doorman']}",*/
                          hintStyle: TextStyle(
                            fontSize: 12,
                          ),

                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),

                          //prefixText: Languages.skeleton_language_objects[Config.app_language.value]!['search_doorman_building']!,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return logicBuilding.buildingsList.isEmpty
                                  ? Container(
                                      alignment: Alignment.center,
                                      height: 300,
                                      width: 200,
                                      child: AlertDialog(
                                        scrollable: true,
                                        title: Text(
                                          Languages.skeleton_language_objects[
                                                  Config.app_language.value]![
                                              'pleaseAddDoorman']!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(
                                          Languages.skeleton_language_objects[
                                                  Config.app_language.value]![
                                              'buildingAdditionIsMandatory']!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : FormBuilder(
                                      key: _formKey,
                                      child: StatefulBuilder(
                                          builder: (context, setState) {
                                        return Container(
                                          alignment: Alignment.center,
                                          height: 300,
                                          width: 200,
                                          child: AlertDialog(
                                            scrollable: true,
                                            title: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Languages.skeleton_language_objects[
                                                          Config.app_language.value]![
                                                      'add_doorman']!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  Languages.skeleton_language_objects[
                                                          Config.app_language.value]![
                                                      'details_doorman']!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                           content: Column(
                                              children: [
                                               Obx(() {
                                                  return Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: SwitchListTile(
                                                        title: logic
                                                                .doorManStatus
                                                                .value
                                                            ? Text(
                                                                "Doorman will be Active",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : Text(
                                                                "Doorman will be Inactive",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic)),
                                                        value: logic
                                                            .doorManStatus
                                                            .value,
                                                        onChanged:
                                                            (bool value) {
                                                          logic
                                                              .changeDoormanStatus(
                                                                  value);
                                                          debugPrint(
                                                              "Value is $value");
                                                        },
                                                      ));
                                                }),
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: 130,
                                                        child: Text(Languages
                                                                    .skeleton_language_objects[
                                                                Config
                                                                    .app_language.value]![
                                                            'doorman']!)),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Container(
                                                      width: 400,
                                                      height: 50,
                                                      //margin: EdgeInsets.only(left: 12),
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1,
                                                          )),
                                                      // padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                                      child:
                                                          FormBuilderTextField(
                                                        controller: doormanName,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        name: 'doormanName',
                                                            inputFormatters: <
                                                                TextInputFormatter>[
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                  r'[a-z A-Z]')),
                                                            ],
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(),
                                                          FormBuilderValidators
                                                              .maxLength(30),
                                                          FormBuilderValidators
                                                              .minLength(6)
                                                        ]),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                               SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: 130,
                                                        child: Text(Languages
                                                                    .skeleton_language_objects[
                                                                Config
                                                                    .app_language.value]![
                                                            'address']!)),


                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Container(
                                                        width: 400,
                                                        height: 50,
                                                        //margin: EdgeInsets.only(left: 12),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 12),
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .grey,
                                                                  width: 1,
                                                                )),
                                                        // padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                                        child:
                                                            Container(
                                                              padding:EdgeInsets.only(left:10,right:22),

                                                              decoration:
                                                              BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      22),
                                                                  border:
                                                                  Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 1,
                                                                  )),
                                                              child: DropdownButtonHideUnderline(

                                                          child: DropdownButton<
                                                                BuildingModel>(

                                                              hint: Text(
                                                                selectedBuildingName,
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .black87,
                                                                  fontSize: 14,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              icon: Icon(Icons
                                                                  .keyboard_arrow_down),
                                                              iconSize: 24,
                                                              isExpanded: true,
                                                              elevation: 16,
                                                              onChanged:
                                                                  (BuildingModel?
                                                                      newValue) {
                                                                FocusScope.of(
                                                                        context)
                                                                    .unfocus();

                                                                setState(() {
                                                                  //  countyName = newValue!.buildingName;
                                                                  selectedBuildingName =
                                                                      newValue!
                                                                          .buildingName!;
                                                                  selectedBuildingId =
                                                                  newValue!
                                                                      .id!;
                                                                });
                                                              },
                                                              items: logicBuilding
                                                                  .buildingsList
                                                                  ?.map<
                                                                          DropdownMenuItem<
                                                                              BuildingModel>>(
                                                                      (BuildingModel
                                                                          value) {
                                                                return DropdownMenuItem<
                                                                    BuildingModel>(
                                                                  value: value,
                                                                  child: Text(
                                                                    value!
                                                                        .buildingName!,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black87,
                                                                      fontSize:
                                                                          14,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                          ),
                                                        ),
                                                            ))


                                                  ],
                                                ),

                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: 130,
                                                        child: Text(Languages
                                                                    .skeleton_language_objects[
                                                                Config
                                                                    .app_language.value]![
                                                            'userName']!)),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Container(
                                                      width: 400,
                                                      height: 50,
                                                      //margin: EdgeInsets.only(left: 12),
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1,
                                                          )),
                                                      // padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                                      child:
                                                          FormBuilderTextField(
                                                        controller: userName,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        name: 'userName',
                                                        inputFormatters: <
                                                            TextInputFormatter>[
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'[a-zA-Z1-9@_]')),
                                                        ],
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(),
                                                          FormBuilderValidators
                                                              .maxLength(30),
                                                        ]),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: 130,
                                                        child: Text(Languages
                                                                    .skeleton_language_objects[
                                                                Config
                                                                    .app_language.value]![
                                                            'pswrd']!)),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Container(
                                                      width: 400,
                                                      height: 50,
                                                      //margin: EdgeInsets.only(left: 12),
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1,
                                                          )),
                                                      // padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                                      child:
                                                          FormBuilderTextField(
                                                        controller: password,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        //obscureText: true,
                                                        decoration:
                                                        InputDecoration(
                                                          hintText: Constants.LanguageKey('pswrd'),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        name: 'password',
                                                        validator:
                                                            (String? value) {
                                                          String pattern =
                                                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
                                                          RegExp regExp =
                                                              new RegExp(
                                                                  pattern);

                                                          if (password
                                                              .text.isEmpty)
                                                            return "password Required!";
                                                          else if (password.text
                                                                  .length <=
                                                              5)
                                                            return "At least_6_characters";
                                                          else if (password.text
                                                                  .length >=
                                                              25)
                                                            return "Can't exceed from 25 charachters";
                                                          else if (!regExp
                                                              .hasMatch(password
                                                                  .text
                                                                  .toString()))
                                                            return "Please use correct format.eg:Abc1@";
                                                          else
                                                            return null;
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: 130,
                                                        child: Text(Languages
                                                                    .skeleton_language_objects[
                                                                Config
                                                                    .app_language.value]![
                                                            'mNum']!)),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Container(
                                                      width: 400,
                                                      height: 50,
                                                      //margin: EdgeInsets.only(left: 12),
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1,
                                                          )),
                                                      // padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                                      child:
                                                          FormBuilderTextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        controller: mobileNum,
                                                        //obscureText: true,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: '+591',
                                                        ),
                                                        inputFormatters: [
                                                          mobileFormatter
                                                        ],
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(),
                                                          FormBuilderValidators
                                                              .equalLength(12),
                                                        ]),
                                                        autocorrect: true,
                                                        name: 'mNum',
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                        width: 130,
                                                        child: Text(
                                                          Languages
                                                                    .skeleton_language_objects[
                                                                Config
                                                                    .app_language.value]![
                                                            'idNum']!)),
                                                    SizedBox(
                                                      width: 12,
                                                    ),
                                                    Container(
                                                      width: 400,
                                                      height: 50,
                                                      //margin: EdgeInsets.only(left: 12),
                                                      padding: EdgeInsets.only(
                                                          left: 12),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1,
                                                          )),
                                                      // padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                                      child:
                                                          FormBuilderTextField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        controller: idNum,
                                                        //obscureText: true,
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        name: 'idNum',
                                                        inputFormatters: [
                                                          idFormatter
                                                        ],

                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(),
                                                          FormBuilderValidators
                                                              .numeric(),
                                                          FormBuilderValidators
                                                              .equalLength(10),
                                                        ]),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        _formKey.currentState!
                                                            .reset();
                                                        doormanName.clear();
                                                        password.clear();
                                                        userName.clear();
                                                        mobileNum.clear();
                                                        idNum.clear();
                                                        selectedBuildingName = 'Select Building';

                                                        setState(() {});
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 42,
                                                          width: 110,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  //color: Constants.primaryOrangeColor
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade500)),
                                                          child: Text(
                                                            Constants
                                                                .LanguageKey(
                                                                    'clear'),
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade700,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _formKey.currentState!
                                                            .reset();
                                                        doormanName.clear();
                                                        password.clear();
                                                        userName.clear();
                                                        mobileNum.clear();
                                                        idNum.clear();
                                                        selectedBuildingName = 'Select Building';

                                                        setState(() {});
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 42,
                                                          width: 110,
                                                          decoration:
                                                              BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  //color: Constants.primaryOrangeColor
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade500)),
                                                          child: Text(
                                                            Languages.skeleton_language_objects[
                                                                    Config
                                                                        .app_language.value]![
                                                                'cancel']!,
                                                            style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade700,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 25,
                                                    ),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (_formKey
                                                                .currentState
                                                                ?.saveAndValidate() ??
                                                            false) {
                                                          if (selectedBuildingName
                                                              .isEmpty) {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        'Please select the building first!'),
                                                                    actions: [
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                           Get.back();
                                                                          },
                                                                          child:
                                                                              Text("OK"))
                                                                    ],
                                                                  );
                                                                });
                                                            //Constants.defaultToast('Please select the building first');
                                                          } else {
                                                            try {
                                                              bool
                                                                  doormanExist =
                                                                  false;

                                                              logic.doormens
                                                                  .forEach(
                                                                      (element) {
                                                                if (element.userName ==
                                                                        userName
                                                                            .text &&
                                                                    element.password ==
                                                                        password
                                                                            .text) {
                                                                  doormanExist ==
                                                                      true;
                                                                } else {
                                                                  doormanExist ==
                                                                      false;
                                                                }
                                                              });
                                                              if (doormanExist ==
                                                                  false) {
                                                                DoormanModel doorman = DoormanModel();
                                                                var uuid = Uuid();
                                                                String uid = uuid.v1();
                                                                doorman.id= uid;
                                                                doorman.doormanName= doormanName
                                                                    .text;
                                                                doorman.buildingName= selectedBuildingName;
                                                                doorman.buildingId= selectedBuildingId;
                                                                doorman.userName = userName
                                                                    .text;
                                                                doorman.password = password
                                                                    .text;
                                                                doorman.mobileNumber = mobileNum.text;
                                                                doorman.idNumber= idNum.text;
                                                                doorman.isActive = logic
                                                                    .doorManStatus
                                                                    .value;

                                                                bool value = await logic.saveDoormanToFirestore(uid,doorman);
                                                                if (value) {
                                                                  setState(
                                                                      () {});
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Get.defaultDialog(
                                                                      title: '',
                                                                      content: Column(
                                                                        children: [
                                                                          SvgPicture
                                                                              .asset(
                                                                            "assets/successIcon.svg",
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          const Text(
                                                                            "Doorman added successfully",
                                                                            style:
                                                                                TextStyle(fontSize: Constants.textH6Size, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          const Text(
                                                                            "Give doorman the username and password for login on Mobile app",
                                                                            style:
                                                                                TextStyle(fontSize: Constants.textH6Size, fontWeight: FontWeight.normal),
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Card(
                                                                              elevation: 8.0,
                                                                              shadowColor: Constants.primaryOrangeColor,
                                                                              child: Column(
                                                                                children: [
                                                                                  ListTile(
                                                                                    title: Text(
                                                                                      "Doorman Username: ${userName.text}",
                                                                                      style: TextStyle(fontSize: Constants.textH5Size, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    onTap: () async {
                                                                                      await Clipboard.setData(ClipboardData(text: "${userName.text}"));
                                                                                    },
                                                                                    trailing: Icon(Icons.copy),
                                                                                  ),
                                                                                  ListTile(
                                                                                    title: Text(
                                                                                      "Doorman Password: ${password.text}",
                                                                                      style: TextStyle(fontSize: Constants.textH5Size, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    onTap: () async {
                                                                                      await Clipboard.setData(ClipboardData(text: "${password.text}"));
                                                                                    },
                                                                                    trailing: Icon(Icons.copy),
                                                                                  ),

                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          TextButton(
                                                                              onPressed: () {
                                                                               // _formKey.currentState!.reset();
                                                                                doormanName.clear();
                                                                                password.clear();
                                                                                userName.clear();
                                                                                mobileNum.clear();
                                                                                idNum.clear();
                                                                                selectedBuildingName = 'Select Building';
                                                                                Get.back();
                                                                              },
                                                                              child: Text("OK"))
                                                                        ],
                                                                      ));
                                                                } else {
                                                                  Get.defaultDialog(
                                                                      title: '',
                                                                      content: Column(
                                                                        children: [
                                                                          SvgPicture
                                                                              .asset(
                                                                            "assets/cross.svg",
                                                                            height:
                                                                                25,
                                                                            width:
                                                                                25,
                                                                              color:Constants.primaryOrangeColor
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          const Text(
                                                                            "Doorman couldn't be added...",
                                                                            style:
                                                                                TextStyle(fontSize: Constants.textH6Size, fontWeight: FontWeight.bold),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          const Text(
                                                                              "Mobile Number or ID Number or Username is already present!"),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          const Text(
                                                                              "Try Again!!"),
                                                                          const SizedBox(
                                                                            height:
                                                                                25,
                                                                          ),
                                                                        ],
                                                                      ));
                                                                }
                                                              } else {
                                                                Constants
                                                                    .defaultToast(
                                                                        " Doorman is already present ");
                                                              }
                                                            } catch (e) {
                                                              debugPrint(
                                                                  e.toString());
                                                            }
                                                          }
                                                        } else {
                                                          Constants.defaultToast(
                                                              "Form isn't validated");
                                                        }
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: 42,
                                                          width: 110,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              color: Constants
                                                                  .primaryOrangeColor),
                                                          child: Text(
                                                            Languages.skeleton_language_objects[
                                                                    Config
                                                                        .app_language.value]![
                                                                'save']!,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                          alignment: Alignment.center,
                          height: 52,
                          width: 180,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Constants.primaryOrangeColor),
                          child: Text(
                            Languages.skeleton_language_objects[Config.app_language.value]!['add_doorman']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Obx(() {
                return Stack(
                  children: [
                    Container(
                      height: size.height,
                      width: size.width,
                      alignment: Alignment.center,
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 40),
                      child: logic.isSearching.value
                          ? doorManDataFiltered(context, size)
                          : doorManData(context, size),
                    ),
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Constants.filterForDoorman(size))
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
