import 'package:shared_preferences/shared_preferences.dart';

class Sharedpreference{

addStringToSF(String name,String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(name,value);
}

getStringValuesSF(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String stringValue = prefs.getString(name);
  return stringValue;
}

}