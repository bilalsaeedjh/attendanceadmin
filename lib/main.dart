import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:attendanceadmin/firebase_options.dart';
import 'package:attendanceadmin/screens/buildings/view.dart';
import 'package:attendanceadmin/screens/dashboard/view.dart';
import 'package:attendanceadmin/screens/doorman/view.dart';
import 'package:attendanceadmin/screens/login_screen/view.dart';
import 'package:attendanceadmin/screens/navigation/view.dart';
import 'package:attendanceadmin/screens/settings/view.dart';
import 'package:attendanceadmin/screens/visitors/view.dart';
import 'package:attendanceadmin/utilities/constants.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Constants.primaryOrangeColor, // navigation bar color
    statusBarColor: Constants.primaryOrangeColor, // status bar color
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) async {
    debugPrint("**************--Firebase is Initialized--*************");
    FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
    runApp(Phoenix(child:  MyApp()));
  });
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home:  LoginScreenPage(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context)=> LoginScreenPage(),
        '/login': (context)=> LoginScreenPage(),
        '/dashboard':(context)=>DashboardPage(),
        '/navigation': (context) => NavigationPage(),
        '/visitors': (context) => VisitorsPage(),
        '/settings': (context) => SettingsPage(),
        '/doorman':(context) => DoormanPage(),
        '/buildings': (context) => BuildingsPage()
      },
      supportedLocales: [...FormBuilderLocalizations.supportedLocales],
      localizationsDelegates: const [
        //...GlobalMaterialLocalizations.delegates,
        FormBuilderLocalizations.delegate,
      ],
    );
  }
}

