import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/screens/buildings/logic.dart';
import 'package:attendanceadmin/screens/doorman/logic.dart';
import 'package:attendanceadmin/screens/visitors/logic.dart';
import 'package:attendanceadmin/screens/visitors/visitor_filter/logic.dart';
import 'package:attendanceadmin/utilities/widgets/webCard.dart';

import 'logic.dart';

class DashboardPage extends StatelessWidget {
  final logic = Get.put(DashboardLogic());
  final logicDoorman = Get.put(DoormanLogic());
  final logicBuildings = Get.put(BuildingsLogic());
  final logicVisitors = Get.put(VisitorsLogic());
  final state = Get
      .find<DashboardLogic>()
      .state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(40),
          margin: EdgeInsets.all(40),
          child: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                webCard(
                  columnFirst: 'assets/doorman.svg',
                  columnSecond: 't_dmn',
                  rowSecond: logicDoorman.totalDoormen.toString(),
                ),
                webCard(
                  columnFirst: 'assets/building.svg',
                  columnSecond: 't_bdings',
                  rowSecond: logicBuildings.totalBuildings.toString(),
                ),
                webCard(
                  columnFirst: 'assets/tVisitors.svg',
                  columnSecond: 't_visitors',
                  rowSecond: logicVisitors.totalVisitors.toString(),
                ),
              ],
            );
          })
      ),
    );
  }
}
