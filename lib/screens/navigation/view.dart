import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/screens/buildings/logic.dart';
import 'package:attendanceadmin/screens/buildings/view.dart';
import 'package:attendanceadmin/screens/dashboard/view.dart';
import 'package:attendanceadmin/screens/doorman/logic.dart';
import 'package:attendanceadmin/screens/doorman/view.dart';
import 'package:attendanceadmin/screens/login_screen/view.dart';
import 'package:attendanceadmin/screens/settings/view.dart';
import 'package:attendanceadmin/screens/visitors/logic.dart';
import 'package:attendanceadmin/screens/visitors/view.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/languages.dart';
import 'package:attendanceadmin/utilities/widgets/logoWidget.dart';

import 'logic.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with SingleTickerProviderStateMixin {
  //Navigation Rail Logic
  final logic = Get.put(NavigationLogic());
  final visitorsLogic = Get.put(VisitorsLogic());
  final doormanLogin = Get.put(DoormanLogic());
  final buildingLogic = Get.put(BuildingsLogic());

  int _index = 0;
  late TabController _controller;

  //bottom navigation pages
  late DashboardPage one;
  late DoormanPage two;
  late BuildingsPage three;
  late VisitorsPage four;
  late SettingsPage five;

  late List<Widget> pages;
  late Widget currentPage;

  Widget returnPage(int value) {
    switch (value) {
      case 0:
        return one;
      case 1:
        return two;
      case 2:
        return three;
      case 3:
        return four;
      case 4:
        return five;
      default:
        return one;
    }
  }

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    debugPrint("On navigation");
    super.initState();
    one = DashboardPage();
    two = DoormanPage();
    three = BuildingsPage();
    four = VisitorsPage();
    five = SettingsPage();

    pages = [one, two, three, four, five];

    currentPage = one;

//    BackButtonInterceptor.add(myInterceptor);
    _controller = TabController(vsync: this, length: 5, initialIndex: _index);
  }

  bool shouldPop = true;
  late DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(milliseconds: 500)) {
      currentBackPressTime = now;
      Constants.defaultToast("pressLogoutButtonToExit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //SvgPicture.asset('assets/logoSSSVg.svg'),
                        LogoWidget(height: 50, width: 100,),
                        ClipOval(
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.red,
                            alignment: Alignment.center,
                            child: Text('A'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Container(
                    width: size.width,
                    height: size.height,
                    child: Row(
                      children: [
                        if (MediaQuery
                            .of(context)
                            .size
                            .width >= 640)
                          Obx(() {
                            return NavigationRail(
                              leading: AnimatedContainer(
                                height: logic.isNavigationLabel.value ? 50 : 50,
                                width: logic.isNavigationLabel.value ? 120 : 50,
                                curve: Curves.bounceOut,
                                duration: Duration(milliseconds: 1250),
                                child: IconButton(
                                    onPressed: () {
                                      bool value = logic.isNavigationLabel.value;
                                      logic.changeNavigationLabel(!value);
                                    },
                                    icon: logic.isNavigationLabel.value
                                        ? const Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      size: 30,
                                      color: Constants.primaryOrangeColor,
                                    )
                                        : const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 30,
                                      color: Constants.primaryBlackColor,
                                    )),
                              ),

                              useIndicator: false,
                              //rindicatorColor: Theme.of(context).appBarTheme.backgroundColor,

                              selectedIndex: _index,
                              onDestinationSelected: (int index) {
                                visitorsLogic.changeVisitorShowFilters(false);
                                doormanLogin.changeDoormanShowFilters(false);
                                buildingLogic.showFilters.value = false;
                                visitorsLogic.filteredVisitors.clear();
                                visitorsLogic.isFilteringSearching.value = false;
                                visitorsLogic.dateTimeStart.value = DateTime.now();
                                visitorsLogic.dateTimeEnd.value = DateTime(2024);
                                visitorsLogic.timeStart =
                                    TimeOfDay(hour: 01, minute: 00).obs;
                                visitorsLogic.timeEnd =
                                    TimeOfDay(hour: 20, minute: 59).obs;
                                visitorsLogic.selectedDoormen = [].obs;
                                setState(() {
                                  _index = index;
                                  _controller.animateTo(_index,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.ease);
                                  currentPage = pages[_index];
                                });
                              },

                              labelType: NavigationRailLabelType.selected,
                              destinations: <NavigationRailDestination>[
                                NavigationRailDestination(
                                    padding: EdgeInsets.only(left: 12, right: 12),
                                    icon: AnimatedContainer(
                                      height: logic.isNavigationLabel.value ? 20 : 22,
                                      width: logic.isNavigationLabel.value ? 120 : 22,
                                      curve: Curves.bounceOut,
                                      duration: Duration(milliseconds: 1250),
                                      child: logic.isNavigationLabel.value
                                          ? Container(
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/dashboard.svg',
                                              color: Colors.grey.shade700,
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              Languages.skeleton_language_objects[Config
                                                  .app_language.value]!['dashboard']!,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      )
                                          : SvgPicture.asset(
                                        'assets/dashboard.svg',
                                        color: Colors.grey.shade700,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                    selectedIcon: AnimatedContainer(
                                      height: logic.isNavigationLabel.value ? 20 : 22,
                                      width: logic.isNavigationLabel.value ? 120 : 22,
                                      curve: Curves.bounceOut,
                                      duration: Duration(milliseconds: 1250),
                                      child: logic.isNavigationLabel.value
                                          ? Container(
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/dashboard.svg',
                                              color: Constants.primaryOrangeColor,
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              Languages.skeleton_language_objects[Config
                                                  .app_language.value]!['dashboard']!,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Constants.primaryOrangeColor),
                                            ),
                                          ],
                                        ),
                                      )
                                          : SvgPicture.asset(
                                        'assets/dashboard.svg',
                                        color: Constants.primaryOrangeColor,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                    label: Text('')),
                                NavigationRailDestination(
                                    padding: EdgeInsets.only(left: 12, right: 12),
                                    icon: AnimatedContainer(
                                      height: logic.isNavigationLabel.value ? 20 : 22,
                                      width: logic.isNavigationLabel.value ? 120 : 22,
                                      curve: Curves.bounceOut,
                                      duration: Duration(milliseconds: 950),
                                      clipBehavior: Clip.none,
                                      child: logic.isNavigationLabel.value
                                          ? Container(
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // SizedBox(
                                            //   width: 8,
                                            // ),
                                            SvgPicture.asset(
                                              'assets/doorman.svg',
                                              color: Colors.grey.shade700,
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              Languages.skeleton_language_objects[
                                              Config.app_language.value]!['doorman']!,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      )
                                          : SvgPicture.asset(
                                        'assets/doorman.svg',
                                        color: Colors.grey.shade700,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                    selectedIcon: AnimatedContainer(
                                      height: logic.isNavigationLabel.value ? 20 : 22,
                                      width: logic.isNavigationLabel.value ? 120 : 22,
                                      curve: Curves.bounceOut,
                                      clipBehavior: Clip.none,
                                      duration: Duration(milliseconds: 950),
                                      child: logic.isNavigationLabel.value
                                          ? Container(
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/doorman.svg',
                                              color: Constants.primaryOrangeColor,
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              Languages.skeleton_language_objects[
                                              Config.app_language.value]!['doorman']!,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Constants.primaryOrangeColor),
                                            ),
                                          ],
                                        ),
                                      )
                                          : SvgPicture.asset(
                                        'assets/doorman.svg',
                                        color: Constants.primaryOrangeColor,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                    label: Text('')),
                                NavigationRailDestination(
                                    padding: EdgeInsets.only(left: 12, right: 12),
                                    icon: AnimatedContainer(
                                      height: logic.isNavigationLabel.value ? 20 : 22,
                                      width: logic.isNavigationLabel.value ? 120 : 22,
                                      curve: Curves.bounceOut,
                                      clipBehavior: Clip.none,
                                      duration: Duration(milliseconds: 950),
                                      child: logic.isNavigationLabel.value
                                          ? Container(
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // SizedBox(
                                            //   width: 8,
                                            // ),
                                            SvgPicture.asset(
                                              'assets/building.svg',
                                              color: Colors.grey.shade700,
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              Languages.skeleton_language_objects[Config
                                                  .app_language.value]!['buildings']!,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      )
                                          : SvgPicture.asset(
                                        'assets/building.svg',
                                        color: Colors.grey.shade700,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                    selectedIcon: AnimatedContainer(
                                      height: logic.isNavigationLabel.value ? 20 : 22,
                                      width: logic.isNavigationLabel.value ? 120 : 22,
                                      curve: Curves.bounceOut,
                                      clipBehavior: Clip.none,
                                      duration: Duration(milliseconds: 950),
                                      child: logic.isNavigationLabel.value
                                          ? Container(
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/building.svg',
                                              color: Constants.primaryOrangeColor,
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              Languages.skeleton_language_objects[Config
                                                  .app_language.value]!['buildings']!,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Constants.primaryOrangeColor),
                                            ),
                                          ],
                                        ),
                                      )
                                          : SvgPicture.asset(
                                        'assets/building.svg',
                                        color: Constants.primaryOrangeColor,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                    label: Text('')),
                                NavigationRailDestination(
                                    padding: EdgeInsets.only(left: 12, right: 12),
                                    icon: AnimatedContainer(
                                      height: logic.isNavigationLabel.value ? 20 : 22,
                                      width: logic.isNavigationLabel.value ? 120 : 22,
                                      curve: Curves.bounceOut,
                                      clipBehavior: Clip.none,
                                      duration: Duration(milliseconds: 950),
                                      child: logic.isNavigationLabel.value
                                          ? Container(
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'assets/scanIcons.png',
                                              color: Colors.grey.shade700,
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              Languages.skeleton_language_objects[
                                              Config.app_language.value]!['visitor']!,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      )
                                          : Image.asset(
                                        'assets/scanIcons.png',
                                        color: Colors.grey.shade700,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                    selectedIcon: AnimatedContainer(
                                      height: logic.isNavigationLabel.value ? 20 : 22,
                                      width: logic.isNavigationLabel.value ? 120 : 22,
                                      curve: Curves.bounceOut,
                                      clipBehavior: Clip.none,
                                      duration: Duration(milliseconds: 750),
                                      child: logic.isNavigationLabel.value
                                          ? Container(
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // SizedBox(
                                            //   width: 8,
                                            // ),

                                            Image.asset(
                                              'assets/scanIcons.png',
                                              color: Constants.primaryOrangeColor,
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              Languages.skeleton_language_objects[
                                              Config.app_language.value]!['visitor']!,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Constants.primaryOrangeColor),
                                            ),
                                          ],
                                        ),
                                      )
                                          : Image.asset(
                                        'assets/scanIcons.png',
                                        color: Constants.primaryOrangeColor,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                    label: Text('')),
                                NavigationRailDestination(
                                    padding: EdgeInsets.only(left: 12, right: 12),
                                    icon: AnimatedContainer(
                                      height: logic.isNavigationLabel.value ? 20 : 22,
                                      width: logic.isNavigationLabel.value ? 120 : 22,
                                      curve: Curves.bounceOut,
                                      clipBehavior: Clip.none,
                                      duration: Duration(milliseconds: 1250),
                                      child: logic.isNavigationLabel.value
                                          ? Container(
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // SizedBox(
                                            //   width: 8,
                                            // ),
                                            SvgPicture.asset(
                                              'assets/settings.svg',
                                              color: Colors.grey.shade700,
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              Languages.skeleton_language_objects[Config
                                                  .app_language.value]!['settings']!,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  color: Colors.grey.shade700,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      )
                                          : SvgPicture.asset(
                                        'assets/settings.svg',
                                        color: Colors.grey.shade700,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                    selectedIcon: AnimatedContainer(
                                      height: logic.isNavigationLabel.value ? 20 : 22,
                                      width: logic.isNavigationLabel.value ? 120 : 22,
                                      curve: Curves.bounceOut,
                                      clipBehavior: Clip.none,
                                      duration: Duration(milliseconds: 1250),
                                      child: logic.isNavigationLabel.value
                                          ? Container(
                                        width: 120,
                                        alignment: Alignment.centerLeft,
                                        height: 20,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/settings.svg',
                                              color: Constants.primaryOrangeColor,
                                              height: 22,
                                              width: 22,
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              Languages.skeleton_language_objects[Config
                                                  .app_language.value]!['settings']!,
                                              style: TextStyle(
                                                  fontFamily: "Roboto",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Constants.primaryOrangeColor),
                                            ),
                                          ],
                                        ),
                                      )
                                          : SvgPicture.asset(
                                        'assets/settings.svg',
                                        color: Constants.primaryOrangeColor,
                                        height: 22,
                                        width: 22,
                                      ),
                                    ),
                                    label: Text('')),
                              ],
                            );
                          }),
                        if (MediaQuery
                            .of(context)
                            .size
                            .width >= 640)
                          VerticalDivider(thickness: 1, width: 1),
                        Expanded(
                          child: PageStorage(
                            child: currentPage,
                            bucket: bucket,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
      bottomNavigationBar: MediaQuery
          .of(context)
          .size
          .width < 640
          ? CircleNavBar(
        activeIcons: [
          SvgPicture.asset(
            'assets/dashboard.svg',
            color: Constants.primaryOrangeColor,
            height: 12,
            width: 12,
          ),
          SvgPicture.asset(
            'assets/doorman.svg',
            color: Constants.primaryOrangeColor,
            height: 22,
            width: 22,
          ),
          SvgPicture.asset(
            'assets/building.svg',
            color: Constants.primaryOrangeColor,
            height: 22,
            width: 22,
          ),
          Image.asset(
            'assets/scanIcons.png',
            color: Constants.primaryOrangeColor,
            height: 22,
            width: 22,
          ),
          SvgPicture.asset(
            'assets/settings.svg',
            color: Constants.primaryOrangeColor,
            height: 22,
            width: 22,
          ),
        ],
        inactiveIcons: [
          Text(
            "Dashboard",
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            "Doorman",
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            "Buildings",
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            "Visitors",
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            "Settings",
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
        color: Colors.white,
        height: 30,

        circleWidth: 30,

        onTap: (id) {
          selectedIndex = id;
          setState(() {
            currentPage = returnPage(id);
          });
        },
        // tabCurve: ,
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: Colors.red,
        elevation: 10,
        activeIndex: selectedIndex,
      )
          : null,
    );
  }
}
