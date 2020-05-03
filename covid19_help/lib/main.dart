import 'package:flutter/material.dart';
import 'package:covid19_help/pages/homepage.dart';
import 'package:covid19_help/pages/login.dart';
import 'package:covid19_help/pages/splash_screen.dart';
import 'package:covid19_help/provider/user_provider.dart';
import 'package:covid19_help/services/service_locator.dart';
import 'package:provider/provider.dart';

void main() async {
  setupLocator();
  runApp(ChangeNotifierProvider(
      create: (_) => UserProvider.initialize(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
        home: ScreensController(),
      )));
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    switch (user.status) {
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return Login();
      case Status.Authenticated:
        return HomePage();
      default:
        return Login();
    }
  }
}
