import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/screens/buildings/building_filter/logic.dart';
import 'package:attendanceadmin/screens/buildings/building_filter/state.dart';
import 'package:attendanceadmin/screens/buildings/building_filter/view.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/languages.dart';

import 'logic.dart';

class BuildingsPage extends StatelessWidget {
  final logic = Get.put(BuildingsLogic());
  final logicFilter = Get.put(BuildingFilterLogic());
  final state = Get.find<BuildingsLogic>().state;

  final _searchController = TextEditingController();

  var _buildingName = TextEditingController();
  var _address = TextEditingController();

  final _formKey = GlobalKey<FormBuilderState>();

  Widget rowCard(BuildContext context, Size size, int index) {
    return InkWell(
      onTap: (){
        Constants.AlertDialogBeautiful(context, DateTime.now().toString(),isVisitor:false,isDoorman:false,isBuilding:true);
      },
      child: Card(
        elevation: 8.0,
        child: Row(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(left:3,right: 10),
              color: Colors.grey.shade100,
              width:55,
              height: 20,
              child: Text("${(index+1).toString()}"),
            ),
            Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,
                child: Text(logic.buildingsList[index].buildingName!,overflow:TextOverflow.ellipsis)), //id
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 350,
              child: Text(logic.buildingsList[index].address!),
            ),
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: logic.buildingsList[index].isActive!
                  ? InkWell(
                      onTap: () async {
                        bool value = logic.buildingsList[index].isActive!;
                        value = !value;

                        logic.changeBuildingStatusAlsoFirestore(
                            logic.buildingsList[index].id.toString(), value);
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
                        bool value = logic.buildingsList[index].isActive!;
                        value = !value;
                        logic.changeBuildingStatusAlsoFirestore(
                            logic.buildingsList[index].id.toString(), value);
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
                child: Row(
                    children: [
                      AnimatedContainer(
                          height: logic.isDeleting.value ? 80 : 40,
                          width: logic.isDeleting.value ? 80 : 40,
                          curve: Curves.bounceOut,
                          duration: Duration(milliseconds: 400),
                          child: !logic.isDeleting.value ? IconButton(
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
                                  logic.deleteVisitorDoc(logic.buildingsList[index].id!);
                                }else{
                                  debugPrint("Didn't deleted");
                                }


                              },
                              icon: Icon(Icons.delete,
                                color: Constants.primaryOrangeColor,)) :  SvgPicture.asset('redBin.svg',)
                      )
                    ]
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  Widget rowCardSearched(BuildContext context, Size size, int index) {
    return InkWell(
      onTap: (){
        Constants.AlertDialogBeautiful(context, DateTime.now().toString(),isVisitor:false,isDoorman:false,isBuilding:true);
      },
      child: Card(
        elevation: 8.0,
        child: Row(
          children: [
       /*     Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(left:3,right: 10),
              color: Colors.grey.shade100,
              width:55,
              height: 20,
              child: Text("${(index+1).toString()}"),
            ),*/

            Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,
                child: Text(logic.filteredBuildingsList[index].buildingName!,overflow:TextOverflow.ellipsis)), //id
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 350,
              child: Text(logic.filteredBuildingsList[index].address!),
            ),
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: logic.filteredBuildingsList[index].isActive!
                  ? InkWell(
                      onTap: () async {
                        bool value = logic.filteredBuildingsList[index].isActive!;
                        value = !value;

                        logic.changeBuildingStatusAlsoFirestore(
                            logic.filteredBuildingsList[index].id.toString(), value);
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
                        bool value = logic.filteredBuildingsList[index].isActive!;
                        value = !value;
                        logic.changeBuildingStatusAlsoFirestore(
                            logic.filteredBuildingsList[index].id.toString(), value);
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
                child: Row(
                    children: [
                      AnimatedContainer(
                          height: logic.isDeleting.value ? 80 : 40,
                          width: logic.isDeleting.value ? 80 : 40,
                          curve: Curves.bounceOut,
                          duration: Duration(milliseconds: 400),
                          child: !logic.isDeleting.value ? IconButton(
                              onPressed: () {
                                logic.deleteVisitorDoc(logic.buildingsList[index].id!);
                              },
                              icon: Icon(Icons.delete,
                                color: Constants.primaryOrangeColor,)) :  SvgPicture.asset('redBin.svg',)
                      )
                    ]
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget buildingData(BuildContext context, Size size) {
    return ListView(
      shrinkWrap: true,
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
                width: 300,

                child: Text(Constants.LanguageKey('dBname'),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                alignment: Alignment.center,
                height: 35,
                width: 290,
                child: Text(Constants.LanguageKey('address'),
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Container(
                //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                alignment: Alignment.center,
                height: 35,
                width: 240,
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
              itemCount: logic.buildingsList.length,
              itemBuilder: (BuildContext context, int index) {
                return Obx(() {
                  return SingleChildScrollView(
                      child: logicFilter.buildingActiveStatus.value == true &&
                              logicFilter.buildingInactiveStatus.value == false
                          ? logic.buildingsList[index].isActive == true
                              ? rowCard(context, size, index)
                              : null
                          : logicFilter.buildingActiveStatus.value == false &&
                                  logicFilter.buildingInactiveStatus.value ==
                                      true
                              ? logic.buildingsList[index].isActive == true
                                  ? null
                                  : rowCard(context, size, index)
                              : logicFilter.buildingActiveStatus.value ==
                                          true &&
                                      logicFilter
                                              .buildingInactiveStatus.value ==
                                          true
                                  ? rowCard(context, size, index)
                                  : null);
                });
              },
            )),
      ],
    );
  }
  Widget buildingSearchedData(BuildContext context, Size size) {
    return SingleChildScrollView(
      child:
          ListView(
            shrinkWrap: true,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${Constants.LanguageKey('recordsFound')}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,),),
                  Text("${logic.filteredBuildingsList.length}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
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
                      width: 350,
                      child: Text(Constants.LanguageKey('address'),
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
                    itemCount: logic.filteredBuildingsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Obx(() {
                        return SingleChildScrollView(
                            child: logicFilter.buildingActiveStatus.value == true &&
                                    logicFilter.buildingInactiveStatus.value == false
                                ? logic.filteredBuildingsList[index].isActive == true
                                    ? rowCardSearched(context, size, index)
                                    : null
                                : logicFilter.buildingActiveStatus.value == false &&
                                        logicFilter.buildingInactiveStatus.value ==
                                            true
                                    ? logic.filteredBuildingsList[index].isActive == true
                                        ? null
                                        : rowCardSearched(context, size, index)
                                    : logicFilter.buildingActiveStatus.value ==
                                                true &&
                                            logicFilter
                                                    .buildingInactiveStatus.value ==
                                                true
                                        ? rowCardSearched(context, size, index)
                                        : null);
                      });
                    },
                  )),
            ],
          ),

    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Container(
                height: 50,
                margin: EdgeInsets.all(05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //alignment: Alignment.center,

                      width: 270,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: Colors.grey.shade200,
                      ),
                      child: TextFormField(
                        onChanged: (dynamic val) {
                          if (val != null) {
                            logic.isSearching.value = true;
                            if (val!.length >= 1) {
                              logic.getSearchedBuildings(val);
                            } else {
                              logic.isSearching.value = false;
                              logic.filteredBuildingsList.clear();
                              logic.filteredBuildingsList.clear();
                              _searchController.clear();
                              logic.isSearching.value = false;
                              logic.isSearching.value = false;
                            }
                          }
                        },
                        textAlign: TextAlign.start,
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: Languages.skeleton_language_objects[
                              Config.app_language.value]!['search_building']!,
                          hintStyle: TextStyle(
                            fontSize: 12,
                          ),

                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search),
                          //prefixText: Languages.skeleton_language_objects[Config.app_language.value]!['search_building_building']!,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return FormBuilder(
                                key: _formKey,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 300,
                                  width: 200,
                                  margin: EdgeInsets.all(80),
                                  padding: EdgeInsets.all(40),
                                  child: AlertDialog(
                                    //alignment: Alignment.topLeft,
                                    // titlePadding: EdgeInsets.only(right: 40),
                                    //alignment: Alignment.center,
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          Languages.skeleton_language_objects[
                                                  Config.app_language.value]![
                                              'add_building']!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          Languages.skeleton_language_objects[
                                                  Config.app_language.value]![
                                              'details_building']!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    content: Column(
                                      children: [
                                        Obx(() {
                                          return Align(
                                              alignment: Alignment.centerRight,
                                              child: SwitchListTile(
                                                title: logic
                                                        .buildingStatus.value
                                                    ? Text(
                                                       Constants.LanguageKey('bActive'),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Text(
                                                    Constants.LanguageKey('bInactive'),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle: FontStyle
                                                                .italic)),
                                                value:
                                                    logic.buildingStatus.value,
                                                onChanged: (bool value) {
                                                  logic.changebuildingStatus(
                                                      value);
                                                  debugPrint("Value is $value");
                                                },
                                              ));
                                        }),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                width: 130,
                                                child: Text(Constants.LanguageKey('dBname'))),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Container(
                                              width: 400,
                                              height: 50,
                                              //margin: EdgeInsets.only(left: 12),
                                              padding:
                                                  EdgeInsets.only(left: 12),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  )),
                                              // padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                              child: FormBuilderTextField(
                                                controller: _buildingName,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,

                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                      r'[a-z A-Z]')),
                                                ],

                                                validator: FormBuilderValidators
                                                    .compose([
                                                  FormBuilderValidators
                                                      .required(),
                                                  FormBuilderValidators.maxLength(30),
                                                  FormBuilderValidators.minLength(6),

                                                ]),
                                                name: 'buildingName',
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
                                                child: Text(Constants.LanguageKey('address'))),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Container(
                                              width: 400,
                                              height: 50,
                                              //margin: EdgeInsets.only(left: 12),
                                              padding:
                                                  EdgeInsets.only(left: 12),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1,
                                                  )),
                                              // padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                                              child: FormBuilderTextField(
                                                validator: FormBuilderValidators
                                                    .compose([
                                                  FormBuilderValidators
                                                      .required(),
                                                  FormBuilderValidators.minLength(6),
                                                  FormBuilderValidators.maxLength(100),

                                                ]),
                                                controller: _address,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.allow(
                                                      RegExp(r'[a-z A-Z 1-9]')),
                                                ],
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                name: 'address',
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
                                                _formKey.currentState!.reset();debugPrint("Clearing");
                                                _buildingName.clear();
                                                _address.clear();
                                              },
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 42,
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                      //color: Constants.primaryOrangeColor
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade500)),
                                                  child: Text(
                                                    Constants.LanguageKey(
                                                        'clear'),
                                                    style: TextStyle(
                                                      color:
                                                      Colors.grey.shade700,
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
                                                Navigator.of(context).pop();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 42,
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      //color: Constants.primaryOrangeColor
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade500)),
                                                  child: Text(
                                                    Languages.skeleton_language_objects[
                                                            Config
                                                                .app_language.value]![
                                                        'cancel']!,
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
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
                                                bool alreadyExist = false;
                                                if (_formKey.currentState
                                                    ?.saveAndValidate() ??
                                                    false){
                                                  logic.buildingsList
                                                      .forEach((element) {
                                                    if (element.buildingName ==
                                                        _buildingName
                                                            .text &&
                                                        element.address ==
                                                            _address.text) {
                                                      alreadyExist == true;
                                                    }
                                                  });
                                                  if(alreadyExist == false){
                                                    bool value = await logic
                                                        .saveBuildingToFirestore(
                                                        _buildingName.text,
                                                        _address.text,
                                                        logic.buildingStatus
                                                            .value);
                                                    if (value) {
                                                      Navigator.of(context).pop();
                                                      Get.defaultDialog(
                                                          title: '',
                                                          content: Column(
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/successIcon.svg",
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              const Text(
                                                                "Building Added",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    Constants
                                                                        .textH6Size,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              const Text(
                                                                  "successfully"),
                                                              const SizedBox(
                                                                height: 25,
                                                              ),
                                                            ],
                                                          ));
                                                      Future.delayed(Duration(milliseconds: 1400)).then((value) => Get.back());
                                                    } else {
                                                      Get.defaultDialog(
                                                          title: '',
                                                          content: Column(
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/cross.svg",
                                                                height: 25,
                                                                width: 25,
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              const Text(
                                                                "Building couldn't be saved...",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    Constants
                                                                        .textH6Size,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              const Text(
                                                                "Try changing address. Address should be unique.",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    Constants
                                                                        .textH6Size,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              const Text(
                                                                  "Try Again!!"),
                                                              const SizedBox(
                                                                height: 25,
                                                              ),
                                                            ],
                                                          ));
                                                    }
                                                  } else{
                                                    Constants.defaultToast(
                                                        "Building already Exist");
                                                  }

                                                }else{
                                                  Constants.defaultToast(
                                                      "Form isn't validated");
                                                }


                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 42,
                                                  width: 110,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      color: Constants
                                                          .primaryOrangeColor),
                                                  child: Text(
                                                    Languages.skeleton_language_objects[
                                                            Config
                                                                .app_language.value]![
                                                        'save']!,
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
                                      ],
                                    ),
                                  ),
                                ),
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
                            Languages.skeleton_language_objects[
                                Config.app_language.value]!['add_building']!,
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
                        width: size.width * 0.90,
                        alignment: Alignment.center,
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 40),
                        child: logic.isSearching.value?buildingSearchedData(context, size):buildingData(context, size)),
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Constants.filterForBuilding(size))
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
