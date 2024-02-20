import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/main.dart';

class Config {
  //this holds_the language chosen
  static RxString app_language = 'english'.obs;
  /*static openStreamForConfigurations() async{
     FirebaseFirestore.instance.collection('admin').doc('aadmin').snapshots().listen((event) {

      if(event.data() != null){
        if(event.data()!.isNotEmpty){
          app_language.value = event.data()!['selectedLanguage'];
          debugPrint("=================APP LANGUAGE IS: $app_language==============");
         *//* showDialog(context: navigatorKey.currentContext!, builder: (BuildContext context){
            return StatefulBuilder(
              builder: (context,setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(10.0))),
                  content: Builder(
                      builder: (BuildContext context) {
                        var height = MediaQuery.of(context).size.height;
                        var width = MediaQuery.of(context).size.width;
                        return Container(
                          height: kIsWeb?height * 0.2:height * 0.2,
                          width: width * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Image.asset('assets/languageChanged.png',height: 90,width: 140,),
                              SizedBox(height: 20,),

                              Text(
                                'Application Language is Changed!',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: kIsWeb?22:16,
                                    color: Colors.black87),
                              ),
                              SizedBox(height: 20,),
                             // Restart(),




                            ],
                          ),
                        );
                      }
                  ),
                  actions: <Widget>[

                  ],
                );
              }
            );
          });*//*
        }
      }

    });
  }*/

}

class Restart extends StatefulWidget {
  const Restart({Key? key}) : super(key: key);

  @override
  _RestartState createState() => _RestartState();
}
class _RestartState extends State<Restart> {
  //Declare a timer
  Timer? timer;


  @override
  void initState() {
    super.initState();

    /// Initialize timer for 3 seconds, it will be active as soon as intialized
    timer = Timer(
      const Duration(seconds: 3),
          () {
        /// Navigate to seconds screen when timer callback in executed
        Phoenix.rebirth(context);
      },
    );
  }

  /// cancel the timer when widget is disposed,
  /// to avoid any active timer that is not executed yet
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return  Text("Application will be restarted in 3 seconds", style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: kIsWeb?16:12,
        color: Colors.black87),);
  }
}