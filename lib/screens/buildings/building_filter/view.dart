import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/languages.dart';

import 'logic.dart';

class BuildingFilterPage extends StatelessWidget {
  final logic = Get.put(BuildingFilterLogic());
  final state = Get
      .find<BuildingFilterLogic>()
      .state;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15,top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Languages.skeleton_language_objects[Config.app_language.value]!['filter']!.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 18,),
            Text("${Languages.skeleton_language_objects[Config.app_language.value]!['status']!} :",style: TextStyle(fontSize: 16),),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() {
                  return Checkbox(
                      activeColor: Constants.primaryOrangeColor,
                      side: BorderSide(
                          color: Constants.primaryOrangeColor
                      ),
                      value: logic.buildingActiveStatus.value,
                      onChanged: (value) {
                        logic.changeActivebuildingStatus(value!);
                      });
                }),
                SizedBox(width: 10,),
                Text(Languages.skeleton_language_objects[Config
                    .app_language.value]!['active']!),
              ],

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() {
                  return Checkbox(
                      value: logic.buildingInactiveStatus.value,
                      activeColor: Constants.primaryOrangeColor,
                      side: BorderSide(
                          color: Constants.primaryOrangeColor
                      ),

                      onChanged: (value) {
                        logic.changeInactivebuildingStatus(value!);
                      });
                }),
                SizedBox(width: 10,),
                Text(Languages.skeleton_language_objects[Config
                    .app_language.value]!['inActive']!),
              ],

            ),



          ],
        ),
      ),
    );
  }
}
