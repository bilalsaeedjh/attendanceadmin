import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/screens/visitors/model.dart';
import 'package:attendanceadmin/screens/visitors/visitor_filter/logic.dart';
import 'package:attendanceadmin/screens/visitors/visitor_filter/view.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/languages.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:universal_html/html.dart' as html;
import 'package:to_csv/to_csv.dart' as exportCSV;

import 'logic.dart';

class VisitorsPage extends StatefulWidget {
  const VisitorsPage({Key? key}) : super(key: key);

  @override
  State<VisitorsPage> createState() => _VisitorsPageState();
}

class _VisitorsPageState extends State<VisitorsPage> {
  final logic = Get.put(VisitorsLogic());
  final logicFilter = Get.put(Visitor_filterLogic());
  final state = Get.find<VisitorsLogic>().state;

  //initState ()
  Future<void> getVisitors() async {
    await logic.getVisitors();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('pt_BR', null);
    getVisitors();
  }

  //search Query
  var _searchController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();

  //requiredControllers
  var doormanName = TextEditingController();
  String selectedBuildingName = '';
  var userName = TextEditingController();
  var password = TextEditingController();
  var mobileNum = TextEditingController();
  var idNum = TextEditingController();

  Widget rowCard(BuildContext context, Size size, int index) {
    return Obx(() {
      return InkWell(
        onTap: () async{
          String date = logic.visitors[index].checkIn == null
              ? '-'
              : DateFormat.yMMMMEEEEd().format(logic.visitors[index].checkIn!);
          String checkIn = logic.visitors[index].checkIn == null
              ? '-'
              :  DateFormat('hh:mm a').format(logic.visitors[index].checkIn!);
          String checkOut = logic.visitors[index].checkOut == null
              ? '-'
              : DateFormat('hh:mm a').format(logic.visitors[index].checkOut!);
          String? doormanName = await logic.visitors[index].lastDoormanId==null?'Unknown': Constants.get_doormanName(logic.visitors[index].lastDoormanId??logic.visitors[index].doormanId??'No Doorman');


          Constants.AlertDialogBeautiful(context, date,
              isVisitor: true,
              isDoorman: false,
              isBuilding: false,
              assetImage: false,
              image: logic.visitors[index].imageUrl,
              name: logic.visitors[index].userName,
              mobileNumber: logic.visitors[index].mobileNumber,
              idNumber: logic.visitors[index].idNumber,
              checkIn: checkIn,
              checkOut: checkOut,
            doorman:doormanName??'Unknown',
            reason: logic.visitors[index].reasonVisit
          );
        },
        child: Card(
          elevation: 8.0,
          child: SingleChildScrollView(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      logic.visitors[index].imageUrl != null
                          ? ClipOval(
                              child: logic.visitors[index].imageUrl == 'isEmpty'
                                  ?  Container(
                    height: 40,
                    width: 40,
                    child: Stack(
                      children: [
            
                        SvgPicture.asset("noImage.svg"),
                        Center(
                          child: Text('No Image',style: TextStyle(fontSize: 6),),
                        ),
                      ],
                    ),
                  )
                                  : Container(
                                      height: 40,
                                      width: 40,
                                      color: Colors.white,
                                      child: Image.network(
                                        logic.visitors[index].imageUrl!,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                            )
                          : Container(
                              height: 40,
                              width: 40,
                        child: Stack(
                          children: [
            
                            SvgPicture.asset("noImage.svg"),
                            Center(
                              child: Text('No Image',style: TextStyle(fontSize: 6),),
                            ),
                          ],
                        ),
                            ),
                      SizedBox(
                        width: 6,
                      ),
                      logic.visitors[index].userName == null
                          ? Text("username null")
                          : Expanded(
                              child: Text(
                              logic.visitors[index].userName!,
                              overflow: TextOverflow.ellipsis,
                            ))
                    ],
                  ),
                ), //id
                Container(
                  alignment: Alignment.center,
                  height: 45,
                  width: 200,
                  child: logic.visitors[index].mobileNumber == null
                      ? Text("Mobile null")
                      : Text(logic.visitors[index].mobileNumber!),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 45,
                  width: 200,
                  child: logic.visitors[index].idNumber == null
                      ? Text("idNumber null")
                      : Text(logic.visitors[index].idNumber!),
                ),
                Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 200,
                    child: logic.visitors[index].checkIn != null
                        ? Text(DateFormat('hh:mm a')
                            .format(logic.visitors[index].checkIn!))
                        : Text(' - ')),
                Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 200,
                    child: logic.visitors[index].checkOut != null
                        ? Text(DateFormat('hh:mm a')
                            .format(logic.visitors[index]!.checkOut!))
                        : Text(' - ')),
                Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 200,
                    child: logic.visitors[index]!.checkOut == null
                        ? Text('-')
                        : Text(DateFormat('dd/MM/yyyy')
                            .format(logic.visitors[index]!.checkOut!))),
                logic.visitors[index].lastDoormanId == null
                    ? Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: 200,
                        // child: Text('dOORMAN')
                        child: Text("Unknown")
                        //doormanName == null ? Text(' - ') : Text(doormanName),
                        )
                    : Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: 200,
                        // child: Text('dOORMAN')
                        child: logic.visitors[index].lastDoormanId!.isNotEmpty
                            ? FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('doormen')
                                    .doc(logic.visitors[index].lastDoormanId)
                                    .get(),
                                builder: (context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.data == null) {
                                    return Text("Doorman Deleted");
                                  }
                                  if (!snapshot.hasData) {
                                    return Text("Doorman Deleted");
                                  }
                                  if (snapshot.hasError) {
                                    return Text('Error');
                                  }
                                  if (snapshot.hasData) {
                                    String doormanName =
                                        snapshot.data!['userName'];
                                    return Text(doormanName);
                                  }
                                  return Text("Unknown");
                                },
                              )
                            : Text("Unknown")
            
                        //doormanName == null ? Text(' - ') : Text(doormanName),
                        ),
                Obx(() {
                  return Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 200,
            
                    // child: Text('dOORMAN')
                    child: Row(children: [
                      AnimatedContainer(
                          height: logic.isDeleting.value ? 40 : 25,
                          width: logic.isDeleting.value ? 40 : 25,
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
                                      logic.deleteVisitorDoc(
                                          logic.visitors[index].id!);
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
        ),
      );
    });
  }

  Widget rowCardFiltered(BuildContext context, Size size, int index) {
    return Obx(() {
      return Card(
        elevation: 8.0,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  logic.filteredVisitors[index].imageUrl != null
                      ? ClipOval(
                          child: logic.filteredVisitors[index].imageUrl ==
                                  'isEmpty'
                              ? Container(
                                  height: 40,
                                  width: 40,
                                  color: Colors.red,
                                )
                              : Container(
                                  height: 40,
                                  width: 40,
                                  color: Colors.red,
                                  child: Image.network(
                                      logic.filteredVisitors[index].imageUrl!,
                                    fit: BoxFit.fill,),

                                ),
                        )
                      : Container(
                          height: 40,
                          width: 40,
                          color: Colors.red,
                        ),
                  SizedBox(
                    width: 6,
                  ),
                  logic.filteredVisitors[index].userName == null
                      ? Text("username null")
                      : Expanded(
                          child: Text(
                          logic.filteredVisitors[index].userName!,
                          overflow: TextOverflow.ellipsis,
                        ))
                ],
              ),
            ), //id
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: logic.filteredVisitors[index].mobileNumber == null
                  ? Text("Mobile null")
                  : Text(logic.filteredVisitors[index].mobileNumber!),
            ),
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: logic.filteredVisitors[index].idNumber == null
                  ? Text("idNumber null")
                  : Text(logic.filteredVisitors[index].idNumber!),
            ),

            Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,
                child: logic.filteredVisitors[index]!.checkIn != null
                    ? Text(DateFormat('hh:mm a')
                        .format(logic.filteredVisitors[index]!.checkIn!))
                    : Text(' - ')),
            Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,
                child: logic.filteredVisitors[index]!.checkOut != null
                    ? Text(DateFormat('hh:mm a')
                        .format(logic.filteredVisitors[index]!.checkOut!))
                    : Text(' - ')),

            Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,
                child: logic.filteredVisitors[index]!.checkOut == null
                    ? Text('-')
                    : Text(DateFormat('dd/MM/yyyy')
                        .format(logic.filteredVisitors[index]!.checkOut!))),

            logic.filteredVisitors[index].lastDoormanId == null
                ? Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 200,
                    // child: Text('dOORMAN')
                    child: Text("Unknown")
                    //doormanName == null ? Text(' - ') : Text(doormanName),
                    )
                : Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 200,
                    // child: Text('dOORMAN')
                    child: logic.filteredVisitors[index].lastDoormanId != null
                        ? FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('doormen')
                                .doc(
                                    logic.filteredVisitors[index].lastDoormanId)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Unknown');
                              }
                              if (snapshot.hasData) {
                                String doormanName = snapshot.data!['userName'];
                                return Text(snapshot.data!['userName']!);
                              }
                              return Text("Unknown");
                            },
                          )
                        : Text("Unknown")

                    //doormanName == null ? Text(' - ') : Text(doormanName),
                    ),
            Obx(() {
              return Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,

                // child: Text('dOORMAN')
                child: Row(children: [
                  AnimatedContainer(
                      height: logic.isDeleting.value ? 40 : 25,
                      width: logic.isDeleting.value ? 40 : 25,
                      curve: Curves.bounceOut,
                      duration: Duration(milliseconds: 400),
                      child: !logic.isDeleting.value
                          ? IconButton(
                              onPressed: () {
                                logic.deleteVisitorDoc(
                                    logic.filteredVisitors[index].id!);
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
    });
  }

  Widget rowCardSearched(BuildContext context, Size size, int index) {
    return Obx(() {
      return Card(
        elevation: 8.0,
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  logic.searchedVisitorList[index].imageUrl != null
                      ? ClipOval(
                          child: logic.searchedVisitorList[index].imageUrl ==
                                  'isEmpty'
                              ? Container(
                                  height: 40,
                                  width: 40,
                                  color: Colors.red,
                                )
                              : Container(
                                  height: 40,
                                  width: 40,
                                  color: Colors.red,
                                  child: Image.network(logic
                                      .searchedVisitorList[index].imageUrl!,
                                    fit: BoxFit.fill,),
                                ),
                        )
                      : Container(
                          height: 40,
                          width: 40,
                          color: Colors.red,
                        ),
                  SizedBox(
                    width: 6,
                  ),
                  logic.searchedVisitorList[index].userName == null
                      ? Text("username null")
                      : Expanded(
                          child: Text(
                          logic.searchedVisitorList[index].userName!,
                          overflow: TextOverflow.ellipsis,
                        ))
                ],
              ),
            ), //id
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: logic.searchedVisitorList[index].mobileNumber == null
                  ? Text("Mobile null")
                  : Text(logic.searchedVisitorList[index].mobileNumber!),
            ),
            Container(
              alignment: Alignment.center,
              height: 45,
              width: 200,
              child: logic.searchedVisitorList[index].idNumber == null
                  ? Text("idNumber null")
                  : Text(logic.searchedVisitorList[index].idNumber!),
            ),

            Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,
                child: logic.searchedVisitorList[index]!.checkIn != null
                    ? Text(DateFormat('hh:mm a')
                        .format(logic.searchedVisitorList[index]!.checkIn!))
                    : Text(' - ')),
            Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,
                child: logic.searchedVisitorList[index]!.checkOut != null
                    ? Text(DateFormat('hh:mm a')
                        .format(logic.searchedVisitorList[index]!.checkOut!))
                    : Text(' - ')),

            Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,
                child: logic.searchedVisitorList[index]!.checkOut == null
                    ? Text('-')
                    : Text(DateFormat('dd/MM/yyyy')
                        .format(logic.searchedVisitorList[index]!.checkOut!))),

            logic.searchedVisitorList[index].lastDoormanId == null
                ? Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 200,
                    // child: Text('dOORMAN')
                    child: Text("Unknown")
                    //doormanName == null ? Text(' - ') : Text(doormanName),
                    )
                : Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 200,
                    // child: Text('dOORMAN')
                    child: logic.searchedVisitorList[index].lastDoormanId !=
                            null
                        ? FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('doormen')
                                .doc(logic
                                    .searchedVisitorList[index].lastDoormanId)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Unknown');
                              }
                              if (snapshot.hasData) {
                                String doormanName = snapshot.data!['userName'];
                                return Text(snapshot.data!['userName']!);
                              }
                              return Text("Unknown");
                            },
                          )
                        : Text("Unknown")

                    //doormanName == null ? Text(' - ') : Text(doormanName),
                    ),
            Obx(() {
              return Container(
                alignment: Alignment.center,
                height: 45,
                width: 200,

                // child: Text('dOORMAN')
                child: Row(children: [
                  AnimatedContainer(
                      height: logic.isDeleting.value ? 40 : 25,
                      width: logic.isDeleting.value ? 40 : 25,
                      curve: Curves.bounceOut,
                      duration: Duration(milliseconds: 400),
                      child: !logic.isDeleting.value
                          ? IconButton(
                              onPressed: () {
                                logic.deleteVisitorDoc(
                                    logic.filteredVisitors[index].id!);
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
    });
  }

  Widget visitorData(BuildContext context, Size size) {
    return Obx(() {
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
                        width: 220,

                        child: Text(Constants.LanguageKey('dName'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 260,
                        child: Text(Constants.LanguageKey('dMnum'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 150,
                        child: Text(Constants.LanguageKey('IdNum'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 250,
                        child: Text(Constants.LanguageKey('checkIn'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 150,
                        child: Text(Constants.LanguageKey('checkOut'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 250,
                        child: Text(Constants.LanguageKey('date'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 150,
                        child: Text(Constants.LanguageKey('doorman'),
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
                      itemCount: logic.visitors.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                            child: rowCard(context, size, index));
                      },
                    )),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget visitorDataFiltered(BuildContext context, Size size) {
    return Obx(() {
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
                    Text("${Constants.LanguageKey('recordsFound')}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,),),
                    Text("${logic.filteredVisitors.length}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
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
                        child: Text(Constants.LanguageKey('checkIn'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 200,
                        child: Text(Constants.LanguageKey('checkOut'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 200,
                        child: Text(Constants.LanguageKey('date'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 200,
                        child: Text(Constants.LanguageKey('doorman'),
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
                      itemCount: logic.filteredVisitors.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                            child: rowCardFiltered(context, size, index));
                      },
                    )),
              ],
            ),
          )
        ],
      );
    });
  }

  Widget visitorDataSearched(BuildContext context, Size size) {
    return Obx(() {
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
                    Text("${Constants.LanguageKey('recordsFound')}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,),),
                    Text("${logic.searchedVisitorList.length}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,),),
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
                        child: Text(Constants.LanguageKey('checkIn'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 200,
                        child: Text(Constants.LanguageKey('checkOut'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 200,
                        child: Text(Constants.LanguageKey('date'),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        //margin: EdgeInsets.only(left: 14, top: 14, right: 14, bottom: 4),
                        alignment: Alignment.center,
                        height: 35,
                        width: 200,
                        child: Text(Constants.LanguageKey('doorman'),
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
                      itemCount: logic.searchedVisitorList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                            child: rowCardSearched(context, size, index));
                      },
                    )),
              ],
            ),
          )
        ],
      );
    });
  }

  List<String> name = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Obx(() {
      return logic.isSearching.value == true
          ? SingleChildScrollView(
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
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8)),
                                color: Colors.grey.shade200,
                              ),
                              child: TextFormField(
                                onChanged: (String? val) {
                                  if (val != null) {
                                    logic.isSearching.value = true;
                                    if (val!.length >= 1) {
                                      logic.isSearching.value = true;
                                      logic.getSearchedVisitors(val);
                                    } else {
                                      logic.isSearching.value = false;
                                      logic.searchedVisitorList.clear();
                                      _searchController.clear();
                                      logic.isSearching.value = false;
                                    }
                                  }
                                },
                                textAlign: TextAlign.start,
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText:
                                      Languages.skeleton_language_objects[
                                          Config.app_language.value]!['search']!,
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
                              onTap: _exportCV,
                              child: Container(
                                alignment: Alignment.center,
                                height: 32,
                                width: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Constants.primaryOrangeColor),
                                child: Text(
                                  Constants.LanguageKey('exportCV'),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
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
                                child: visitorDataSearched(context, size)

                                /*logic.isFiltering.value?Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(logic.searchingText.value,style: TextStyle(fontSize: 30),),
                                SizedBox(
                                  width: size.width * 0.3,
                                  child: FAProgressBar(
                                    changeProgressColor: Constants.primaryOrangeLightColor,
                                    currentValue: logic.filterProgress.value,

                                    progressColor: Constants.primaryOrangeColor,
                                   // displayTextStyle: TextStyle(color: Constants.primaryBlackColor,fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                        ):visitorDataFiltered(context, size)*/
                                ),
                            Padding(
                                padding: EdgeInsets.only(right: 20.0),
                                child: Constants.filterForVisitor(size))
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            )
          : logic.isFilteringSearching.value == true
              ? SingleChildScrollView(
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
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: TextFormField(
                                    onChanged: (String? val) {
                                      if (val != null) {
                                        logic.isSearching.value = true;
                                        if (val!.length >= 1) {
                                          logic.isSearching.value = true;
                                          logic.getSearchedVisitors(val);
                                        } else {
                                          logic.isSearching.value = false;
                                          logic.searchedVisitorList.clear();
                                          _searchController.clear();
                                          logic.isSearching.value = false;
                                        }
                                      }
                                    },
                                    textAlign: TextAlign.start,
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: Languages
                                              .skeleton_language_objects[
                                          Config.app_language.value]!['search']!,
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
                                  onTap: _exportCV,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 32,
                                    width: 180,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Constants.primaryOrangeColor),
                                    child: Text(
                                      Constants.LanguageKey('exportCV'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
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
                                    child: visitorDataFiltered(context, size)

                                    /*logic.isFiltering.value?Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(logic.searchingText.value,style: TextStyle(fontSize: 30),),
                                SizedBox(
                                  width: size.width * 0.3,
                                  child: FAProgressBar(
                                    changeProgressColor: Constants.primaryOrangeLightColor,
                                    currentValue: logic.filterProgress.value,

                                    progressColor: Constants.primaryOrangeColor,
                                   // displayTextStyle: TextStyle(color: Constants.primaryBlackColor,fontSize: 16,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                        ):visitorDataFiltered(context, size)*/
                                    ),
                                Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Constants.filterForVisitor(size))
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
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
                                  height: 52,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: TextFormField(
                                    onChanged: (String? val) {
                                      if (val != null) {
                                        logic.isSearching.value = true;
                                        if (val!.length >= 1) {
                                          logic.isSearching.value = true;
                                          logic.getSearchedVisitors(val);
                                        } else {
                                          logic.isSearching.value = false;
                                          logic.searchedVisitorList.clear();
                                          _searchController.clear();
                                          logic.isSearching.value = false;
                                        }
                                      }
                                    },
                                    textAlign: TextAlign.start,
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: Languages
                                              .skeleton_language_objects[
                                          Config.app_language.value]!['search']!,
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
                                  onTap: _exportCV,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 32,
                                    width: 180,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        color: Constants.primaryOrangeColor),
                                    child: Text(
                                      Constants.LanguageKey('exportCV'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
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
                                  child: visitorData(context, size),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Constants.filterForVisitor(size))
                              ],
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                );
    });
  }

  //Export CV package
  //I'll create that soon

  void _exportCV() async {
    debugPrint("Export CV here");

    //* A list of header
    //* A single ***list*** that will contain the list of rows   []
    //*
    List<String> header = [];
    header.add(Constants.LanguageKey('no.'));
    header.add(Constants.LanguageKey('userName'));
    header.add(Constants.LanguageKey('mNum'));
    header.add(Constants.LanguageKey('idNum'));
    header.add(Constants.LanguageKey('checkIn'));
    header.add(Constants.LanguageKey('checkOut'));
    header.add(Constants.LanguageKey('date'));
    header.add(Constants.LanguageKey('doorMan'));

    int i = 0;
    List<List<String>> listOfVisitors = [];

    if (logic.searchedVisitorList.isNotEmpty) {
      debugPrint("CSV in searchedVisitorList");
      //  logic.searchedVisitorList
      // listOfVisitors.add(logic.searchedVisitorList);

      logic.searchedVisitorList.forEach((element) async{
        if (i == 0) {
          listOfVisitors.add(header);
        }
        i++;
        List<String> data = [];
        String checkIn = element.checkIn != null
            ? DateFormat('hh:mm a').format(element.checkIn!)
            : ' ';
        String checkOut = element.checkOut != null
            ? DateFormat('hh:mm a').format(element.checkOut!)
            : ' ';
        String date = element.checkIn != null
            ? DateFormat('dd/MM/yyyy').format((element!.checkIn!))
            : ' ';
        String doormanName =  Constants.get_doormanName(element.lastDoormanId??element.doormanId??'No Doorman');
        debugPrint("-------------------------------");
        debugPrint("DoormanId is: ${element.lastDoormanId}");
        debugPrint("DoormanId is: ${element.doormanId}");
        debugPrint("DoormanName is: $doormanName");
        debugPrint("-------------------------------");
        data.add("${i.toString()}");
        data.add!(element!.userName!);
        data.add!(element!.mobileNumber!);
        data.add!(element!.idNumber!);
        data.add!(checkIn);
        data.add!(checkOut);
        data.add!(date.toString());
        data.add!(doormanName);
        listOfVisitors.add(data);
      });
    } else if (logic.filteredVisitors.isNotEmpty) {
      debugPrint("CSV in searchedVisitorList");
      //  logic.searchedVisitorList
      // listOfVisitors.add(logic.searchedVisitorList);

      logic.filteredVisitors.forEach((element) async{
        if (i == 0) {
          listOfVisitors.add(header);
        }
        i++;
        List<String> data = [];
        String checkIn = element.checkIn != null
            ? DateFormat('hh:mm a').format(element.checkIn!)
            : ' ';
        String checkOut = element.checkOut != null
            ? DateFormat('hh:mm a').format(element.checkOut!)
            : ' ';
        String date = element.checkIn != null
            ? DateFormat('dd/MM/yyyy').format((element!.checkIn!))
            : ' ';
        String doormanName =  Constants.get_doormanName(element.lastDoormanId??element.doormanId??'No Doorman');
        debugPrint("-------------------------------");
        debugPrint("DoormanId is: ${element.lastDoormanId}");
        debugPrint("DoormanId is: ${element.doormanId}");
        debugPrint("DoormanName is: $doormanName");
        debugPrint("-------------------------------");
        data.add("${i.toString()}");
        data.add!(element!.userName!);
        data.add!(element!.mobileNumber!);
        data.add!(element!.idNumber!);
        data.add!(checkIn);
        data.add!(checkOut);
        data.add!(date.toString());
        data.add!(doormanName);
        listOfVisitors.add(data);
      });
    } else {
      debugPrint("CSV in VisitorList");
      if (logic.visitors.isNotEmpty) {
        debugPrint("CSV in VisitorList22");

        logic.visitors.forEach((element) async{
          if (i == 0) {
            listOfVisitors.add(header);
          }
          i++;
          List<String> data = [];

          String checkIn = element.checkIn != null
              ? DateFormat('hh:mm a').format(element.checkIn!)
              : ' ';
          String checkOut = element.checkOut != null
              ? DateFormat('hh:mm a').format(element.checkOut!)
              : ' ';
          String date = element.checkIn != null
              ? DateFormat('dd/MM/yyyy').format((element!.checkIn!))
              : ' ';
          String doormanName = Constants.get_doormanName(element.lastDoormanId??element.doormanId??'No Doorman');
          debugPrint("-------------------------------");
          debugPrint("DoormanId is: ${element.lastDoormanId}");
          debugPrint("DoormanId is: ${element.doormanId}");
          debugPrint("DoormanName is: $doormanName");
          debugPrint("-------------------------------");
          data.add("${i.toString()}");
          data.add!(element!.userName!);
          data.add!(element!.mobileNumber!);
          data.add!(element!.idNumber!);
          data.add!(checkIn);
          data.add!(checkOut);
          data.add!(date.toString());
          data.add!(doormanName);
          listOfVisitors.add(data);
        });
      }
    }
    exportCSV.myCSV(header, listOfVisitors);
  }
}
