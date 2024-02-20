import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/screens/dashboard/view.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/languages.dart';
import 'package:attendanceadmin/utilities/widgets/logoWidget.dart';
import 'package:attendanceadmin/utilities/widgets/rounded_button.dart';

import 'logic.dart';


class LoginScreenPage extends StatelessWidget {
  final logic = Get.put(LoginScreenLogic());
  final state = Get
      .find<LoginScreenLogic>()
      .state;

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Obx(() {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LogoWidget(height: 200,width: 300,),
                  Text(
                    Languages.skeleton_language_objects[Config.app_language
                        .value]![
                    'qrHome']!
                        .toUpperCase(),
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.normal,
                        fontSize: Constants.textH2Size),
                  ),
                  Text(
                    Languages.skeleton_language_objects[Config.app_language
                        .value]![
                    'property_text']!
                        .toUpperCase(),
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: Constants.textH1Size),
                  ),
                  Text(
                    Languages.skeleton_language_objects[Config.app_language
                        .value]![
                    'm_portal']!
                        .toUpperCase(),
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: Constants.textH1Size),
                  ),
                  Text(Languages.skeleton_language_objects[Config.app_language
                      .value]![
                  'manageVisitorsData']!),
                ],
              ),
              SizedBox(
                width: 200,
              ),
              Card(
                elevation: 18.0,
                shadowColor: Colors.black87,
                child: Container(
                  height: 550,
                  width: 650,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        Languages.skeleton_language_objects[Config.app_language
                            .value]![
                        'login']!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Constants.textH5Size),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        Languages.skeleton_language_objects[Config.app_language
                            .value]![
                        'provideYourEmail']!,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        Languages.skeleton_language_objects[Config.app_language
                            .value]![
                        'pMportal']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Constants.primaryOrangeColor),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 180,
                        width: 380,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(
                                  color: Colors.grey.shade500,
                                ),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.only(left: 8),
                              // margin: const EdgeInsets.only(left: 15, right: 15),
                              height: 50,
                              width: 380,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: Constants.LanguageKey('email'),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      border: Border.all(
                                        color: Colors.grey.shade500,
                                      ),
                                    color: Colors.white,
                                  ),
                                  //padding: EdgeInsets.only(left: 25,right: 25),
                                  //margin: const EdgeInsets.only(left: 15, right: 15),
                                  height: 50,
                                  width: 340,
                                  padding: const EdgeInsets.only(left: 8),
                                  // width: size.width * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Obx(() {
                                      return TextField(
                                        controller: _passController,
                                        decoration: InputDecoration(
                                          hintText: Constants.LanguageKey(
                                              'pswrd'),
                                          border: InputBorder.none,
                                        ),
                                        obscureText: logic.isCharHidden.value,
                                      );
                                    }),
                                  ),
                                ),
                                Obx(() {
                                  return IconButton(
                                      onPressed: () {
                                        logic.charShown();
                                      },
                                      icon: logic.isCharHidden.value
                                          ? const Icon(Icons.visibility_off)
                                          : const Icon(Icons.remove_red_eye));
                                })
                              ],
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (_emailController.text.isEmpty ||
                              _passController.text.isEmpty) {
                            Constants.defaultToast(Constants.LanguageKey(
                                "email/pass can't be empty"));
                          } else {
                            await logic.signIn(
                                _emailController.text, _passController.text);
                            if (logic.isLoggedIn.value) {
                              debugPrint("Successfully signed IN");
                              Get.offAndToNamed('/navigation');
                              //Get.off(() => DashboardPage());
                            } else {
                              Constants.defaultToast(
                                  Constants.LanguageKey("email/pass is wrong"));

                              /*  Get.defaultDialog(
                                 title: "Email or Password is wrong",
                                 content: Text("Please try again"),
                                 actions: [
                                   TextButton(
                                       onPressed: () => Get.back(),
                                       child: Text(
                                         "OK",
                                         style: TextStyle(
                                           fontWeight: FontWeight.bold,
                                         ),
                                       ))
                                 ]);*/
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                            color: Constants.primaryOrangeColor,
                          ),
                          padding: const EdgeInsets.only(left: 8),
                          // margin: const EdgeInsets.only(left: 15, right: 15),
                          height: 50,
                          width: 380,
                          alignment: Alignment.center,
                          child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                Languages.skeleton_language_objects[
                                Config.app_language.value]!['signIn']!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Constants.textH5Size),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      LanguageChanger(showImage:false)
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    });
  }
}
