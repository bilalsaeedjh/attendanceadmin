import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/screens/doorman/logic.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/languages.dart';

import 'logic.dart';

class DoormanFilterPage extends StatelessWidget {
  final logic = Get.put(DoormanFilterLogic());
  final state = Get.find<DoormanFilterLogic>().state;


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
                      value: logic.doorManActiveStatus.value,
                      activeColor: Constants.primaryOrangeColor,
                      side: BorderSide(
                          color: Constants.primaryOrangeColor
                      ),
                      onChanged: (value) {
                        logic.changeActiveDoormanStatus(value!);
                      }
                      );
                }),
               // SizedBox(width: 10,),
                Text(Languages.skeleton_language_objects[Config
                    .app_language.value]!['active']!),
              ],

            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() {
                  return Checkbox(value: logic.doorManInactiveStatus.value,
                      activeColor: Constants.primaryOrangeColor,
                      side: BorderSide(
                          color: Constants.primaryOrangeColor
                      ),
                      onChanged: (value) {
                        logic.changeInactiveDoormanStatus(value!);
                      });
                }),
                //SizedBox(width: 10,),
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
