import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/utilities/config.dart';
import 'package:attendanceadmin/utilities/constants.dart';
import 'package:attendanceadmin/utilities/languages.dart';
import 'package:attendanceadmin/utilities/widgets/logoWidget.dart';

import 'logic.dart';

class SettingsPage extends StatelessWidget {
  final logic = Get.put(SettingsLogic());
  final state = Get
      .find<SettingsLogic>()
      .state;

  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  var _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Obx(() {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: LanguageChanger(showImage: true,)),
              ),

              Card(
                elevation: 18.0,
                shadowColor: Colors.black87,
                child: FormBuilder(
                  key: _formKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width>640?MediaQuery.of(context).size.width * 0.5:MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          Languages.skeleton_language_objects[
                          Config.app_language.value]!['chCred']!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Constants.textH5Size),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          Languages.skeleton_language_objects[
                          Config.app_language.value]!['provideChangeEmail']!,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          Languages.skeleton_language_objects[
                          Config.app_language.value]!['pMportal']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Constants.primaryOrangeColor),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Expanded(
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
                                height: MediaQuery.of(context).size.height * 0.08,
                                width:  MediaQuery.of(context).size.width>640?MediaQuery.of(context).size.width * 0.25: MediaQuery.of(context).size.width * 0.6,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: FormBuilderTextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: Constants.LanguageKey('email'),
                                      border: InputBorder.none,
                                    ),
                                    name: 'email',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.maxLength(30),
                                      FormBuilderValidators.minLength(8),
                                      FormBuilderValidators.email(
                                          errorText:
                                          "Please enter valid email address"),
                                    ]),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
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
                                height: MediaQuery.of(context).size.height * 0.08,
                                width:  MediaQuery.of(context).size.width>640?MediaQuery.of(context).size.width * 0.25: MediaQuery.of(context).size.width * 0.6,

                                padding: const EdgeInsets.only(left: 8),
                                // width: size.width * 0.8,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Obx(() {
                                    return FormBuilderTextField(
                                      controller: _passController,
                                      decoration: InputDecoration(
                                        hintText: Constants.LanguageKey(
                                            'pswrd'),
                                        border: InputBorder.none,
                                        suffix: IconButton(
                                            onPressed: () {
                                              logic.charShown();
                                            },
                                            icon: logic.isCharHidden.value
                                                ? const Icon(Icons.visibility_off)
                                                : const Icon(Icons.remove_red_eye))

                                      ),
                                      obscureText: logic.isCharHidden.value,
                                      name: 'pswrd',
                                      validator:
                                      FormBuilderValidators.compose([
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.maxLength(12),
                                        FormBuilderValidators.minLength(6),
                                      ]),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState?.saveAndValidate() ??
                                false) {
                              try {
                                if (_emailController.text.isEmpty ||
                                    _passController.text.isEmpty) {
                                  Constants.defaultToast(Constants.LanguageKey(
                                      "email/pass can't be empty"));
                                } else {
                                  bool value = await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          title: Text(
                                              Constants.LanguageKey(
                                                  'areyouSureTOChangeCredentials')),
                                          content: Builder(builder: (context) {
                                            var height = MediaQuery
                                                .of(context)
                                                .size
                                                .height;
                                            var width =
                                                MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width;
                                            return Container(
                                              height: height * 0.3,
                                              width: width * 0.2,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  /* Text(
                                              "Are you sure to change previous credentials to these new Credentials?"),*/
                                                  Text(
                                                    Constants.LanguageKey(
                                                        "yourNewCredentials"),
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        Constants.LanguageKey(
                                                            'email: '),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black87,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      Text(
                                                        _emailController.text,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black87,
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        Constants.LanguageKey(
                                                            "pass: "),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black87,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),
                                                      Text(
                                                        _passController.text,
                                                        style: TextStyle(
                                                            color: Colors
                                                                .black87,
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context)
                                                                .pop(true);
                                                          },
                                                          child: Text("Yes")),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context)
                                                                .pop(false);
                                                          },
                                                          child: Text("No")),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                          actions: [],
                                        );
                                      });
                                  if (value == true) {
                                    bool value = await logic.changeCredentials(
                                        _emailController.text,
                                        _passController.text);
                                    if (value) {
                                      _emailController.clear();
                                      _passController.clear();
                                      Phoenix.rebirth(context);
                                    } else {

                                    }
                                  }
                                }
                              } catch (e) {
                                debugPrint(e.toString());
                              }
                            } else {
                              Constants.defaultToast(
                                  Constants.LanguageKey('formIsNotValidated'));
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
                                  Config.app_language.value]!['chNow']!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Constants.textH5Size),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
