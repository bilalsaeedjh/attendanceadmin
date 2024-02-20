import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/utilities/config.dart';

import 'state.dart';

class LoginScreenLogic extends GetxController {
  final LoginScreenState state = LoginScreenState();
  RxBool isCharHidden = true.obs;
  RxBool isLoggedIn = false.obs;

  void charShown() {
    isCharHidden.value = !isCharHidden.value;
    debugPrint("isCharShown value is ${isCharHidden.value.toString()}");
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   /* Config.openStreamForConfigurations();*/
  }

  Future signIn(String email, String password) async {
    await FirebaseFirestore.instance
        .collection('admin')
        .doc('aadmin')
        .get()
        .then((value) {
          debugPrint("Valueeeeeeeeeee is"+value.toString());
        String emaill = value['email'];
        String passwordd = value['password'];
        if (emaill == email) {
          if (passwordd == password) {

            debugPrint("Credentials are correct");
            isLoggedIn.value = true;
          }
        } else {
          isLoggedIn.value = false;
        }
    });
  }
}
