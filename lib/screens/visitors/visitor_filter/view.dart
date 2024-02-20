import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/screens/doorman/logic.dart';
import 'package:attendanceadmin/screens/visitors/logic.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/languages.dart';
import 'package:time_range/time_range.dart';
import 'package:time_range/time_range.dart' as tm;
import 'package:time_range_picker/time_range_picker.dart' as tmPick;

import 'logic.dart';

class Visitor_filterPage extends StatefulWidget {
  const Visitor_filterPage({Key? key}) : super(key: key);

  @override
  State<Visitor_filterPage> createState() => _Visitor_filterPageState();
}

class _Visitor_filterPageState extends State<Visitor_filterPage> {
  final logic = Get.put(Visitor_filterLogic());
  final logicDoorman = Get.put(DoormanLogic());
  final logicVisitor = Get.put(VisitorsLogic());
  final state = Get.find<Visitor_filterLogic>().state;
  final _formKey = GlobalKey<FormBuilderState>();
  TimeOfDay? startTime;
  String? endTime = '12:00 pm';
  var _searchController = TextEditingController();
  bool _searchingDoormen = false;
  showTimeRangePickerTM() async {
    final TimeRange result = await tmPick.showTimeRangePicker(
      context: context,
        start: logicVisitor.timeStart.value, // Set initial start time
        end: logicVisitor.timeEnd.value, // Set initial end time

    );

    if (result != null) {
      debugPrint("${result.firstTime} - ${result.lastTime}");
      logicVisitor.timeStart.value = result.firstTime;
      logicVisitor.timeEnd.value = result.lastTime;
      logicVisitor.getFilteredVisitors();
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Languages
                        .skeleton_language_objects[Config.app_language.value]!['filter']!
                        .toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: (){
                          logicVisitor.filteredVisitors.clear();
                          _formKey.currentState!.reset();
                          logicVisitor.isFilteringSearching.value = false;
                          logicVisitor.showFilters.value = false;
                        logicVisitor.dateTimeStart.value = DateTime.now();
                          logicVisitor.dateTimeEnd.value = DateTime(2024);

                          logicVisitor.timeStart = TimeOfDay(hour: 00, minute: 00).obs;
                          logicVisitor.timeEnd = TimeOfDay(hour: 23, minute: 59).obs;
                          logicVisitor.selectedDoormen = [].obs;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 20,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Constants.primaryOrangeLightColor),
                          child: Text(
                            Constants.LanguageKey('cancel'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5,),
                      InkWell(
                        onTap: (){
                          logicVisitor.isFilteringSearching.value = true;
                          logicVisitor.showFilters.value = false;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 25,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Constants.primaryOrangeColor),
                          child: Text(
                            Constants.LanguageKey('save'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )

                ],
              ),
              FormBuilderDateRangePicker(
                name: 'dateRangePicker',
                firstDate: logicVisitor.dateRangeStart.value,
                lastDate: logicVisitor.dateRangeEnd.value,
                initialValue: DateTimeRange(
                    start: logicVisitor.dateTimeStart.value, end: logicVisitor.dateTimeEnd.value),
                initialEntryMode: DatePickerEntryMode.input,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black87, fontSize: 14),
                onChanged: (value){
                  logicVisitor.dateTimeStart.value= value!.start;
                  logicVisitor.dateTimeEnd.value= value!.end;
                  logicVisitor.getFilteredVisitors();
                },

                // inputType: InputType.both,
                decoration: InputDecoration(
                  labelText: Constants.LanguageKey('date_range'),
                ),
              ),
              SizedBox(height: 30),
              Obx(() {
                return InkWell(
                  onTap:showTimeRangePickerTM,
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                        /*   borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                          ),*/
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shift Time',
                          style: TextStyle(fontSize: 11),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${logicVisitor.timeStart.value.format(context)}"),
                            Text(' - '),
                            Text(
                                "${logicVisitor.timeEnd.value.format(context)}"),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
              Divider(
                color: Colors.grey.shade200,
              ),
              SizedBox(height: 30),
              Text(
                Constants.LanguageKey('doormen'),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
              Container(
                //alignment: Alignment.center,
                width: 250,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Colors.grey.shade200,
                ),
                child: TextFormField(
                  textAlign: TextAlign.start,
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: Languages.skeleton_language_objects[
                        Config.app_language.value]!['search_doorman_building']!,
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),

                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    //prefixText: Languages.skeleton_language_objects[Config.app_language.value]!['search_building_building']!,
                  ),
                  onChanged: (value){
                    if(value.length>0){
                      setState(() {
                        _searchingDoormen = true;
                      });
                    }else{
                      setState((){
                        _searchingDoormen = false;
                      });

                    }
                  },
                ),
              ),
              Obx(() {
                return SizedBox(
                  height: 300,
                  width: 250,
                  child: _searchingDoormen
                      ? ListView.builder(
                          itemCount: logicDoorman.doormens.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() {
                              if(logicDoorman.doormens[index]!.userName!.toLowerCase().contains(_searchController.text)){
                                return Row(
                                  children: [
                                    Checkbox(
                                      value: logicVisitor.selectedDoormen.contains(
                                          logicDoorman.doormens[index]!.id!)
                                          ? true
                                          : false,
                                      side: BorderSide(
                                          color: Constants.primaryOrangeColor),
                                      onChanged: (bool? value) {
                                        if (logicVisitor.selectedDoormen.contains(
                                            logicDoorman.doormens[index]!.id!)) {
                                          int indexWhere = logicVisitor.selectedDoormen
                                              .indexOf(logicDoorman
                                              .doormens[index]!.id!);
                                          logicVisitor.selectedDoormen
                                              .removeAt(indexWhere);

                                          logicVisitor.getFilteredVisitors();
                                        } else {
                                          logicVisitor.selectedDoormen.add(
                                              logicDoorman.doormens[index]!.id!);
                                         // logicVisitor.getFilteredVisitors();

                                        }
                                      },
                                    ),
                                    Text(logicDoorman.doormens[index].userName!)
                                  ],
                                );
                              }
                              return Text('');

                            });
                          })
                      : ListView.builder(
                          itemCount: logicDoorman.doormens.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Obx(() {
                              return Row(
                                children: [
                                  Checkbox(
                                    activeColor:Constants.primaryOrangeColor,
                                    value: logicVisitor.selectedDoormen.contains(
                                            logicDoorman.doormens[index]!.id!)
                                        ? true
                                        : false,
                                    side: BorderSide(
                                        color: Constants.primaryOrangeColor),
                                    onChanged: (bool? value) {
                                      if (logicVisitor.selectedDoormen.contains(
                                          logicDoorman.doormens[index]!.id!)) {
                                        int indexWhere = logicVisitor.selectedDoormen
                                            .indexOf(logicDoorman
                                                .doormens[index]!.id!);
                                        logicVisitor.selectedDoormen
                                            .removeAt(indexWhere);
                                        logicVisitor.getFilteredVisitors();
                                      } else {
                                        logicVisitor.selectedDoormen.add(
                                            logicDoorman.doormens[index]!.id!);
                                        logicVisitor.getFilteredVisitors();
                                      }
                                    },
                                  ),
                                  Text(logicDoorman.doormens[index].userName!)
                                ],
                              );
                            });
                          }),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
