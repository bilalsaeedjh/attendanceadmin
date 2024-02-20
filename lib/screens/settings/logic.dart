import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/utilities/constants.dart';

import 'state.dart';

class SettingsLogic extends GetxController {
  final SettingsState state = SettingsState();
  RxBool isCharHidden = true.obs;
  var db = FirebaseFirestore.instance;
  charShown(){
    isCharHidden.value = !isCharHidden.value;
  }
  Future<bool> changeCredentials(String email, String password) async{
    bool value = false;
    try {
       value = await db.collection('admin').doc('aadmin').update({
                'email':email,
                'password': password
          }).then((value) => true);
      if(value == true){
        Constants.defaultToast(Constants.LanguageKey("credChSuccess"));
      }else{
        Constants.defaultToast(Constants.LanguageKey("errorOccuredCD"));
      }
    } catch (e) {
     Constants.defaultToast("${e.toString()}");
     return value;
    }
    return value;
  }
}
