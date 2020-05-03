import 'package:flutter/material.dart';

import 'package:covid19_help/pages/wash.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  // @override
  // void initState() {
  //   super.initState();
  //   _initializeNotification(context);
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

//   _initializeNotification(context) async {
//     Future onSelectNotification(String payload) async {
//       if (payload != null) {
//         debugPrint('notification payload: ' + payload);
//       }
//       await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => WashPage()),
//       );
//     }

//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
// // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     var initializationSettings =
//         InitializationSettings(initializationSettingsAndroid, null);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//   }
}
