import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:with_database/users/authentication/login_screen.dart';
import 'package:with_database/users/fragments/dashboard_of_fragments.dart';
import 'package:with_database/users/userPreferences/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetTogether',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: RememberUserPrefs.readUserInfo(),
          builder: (context, dataSnapShot)
          {
            //if(dataSnapShot==null) {
              return LoginScreen();
            //}
            //else
              //return DashboardOfFragments();
          },
        ),
      );
  }
}


