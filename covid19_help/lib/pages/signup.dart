import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:covid19_help/pages/homepage.dart';
import 'package:covid19_help/provider/user_provider.dart';
import 'package:covid19_help/widgets/loading.dart';
import 'package:gender_selection/gender_selection.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _phonenumber = TextEditingController();
  bool hidePass = true;
  String selectedGender;
  DateTime dateOfBirth;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    String Datee = 'Date of Birth';
    // const double screenHeight = MediaQuery.of(context).size.height;
    // const double screenWidth = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _key,
        body: user.status == Status.Authenticating
            ? Loading()
            : Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.deepPurple,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(55.0),
                      child: Container(
                        margin: const EdgeInsets.all(0.0),
                        height: MediaQuery.of(context).size.height -
                            3 * (MediaQuery.of(context).size.height / 15),
                        color: Colors.white,
                        child: Form(
                            key: _formKey,
                            child: ListView(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 0.0, 5.0),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 0.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListTile(
                                        title: TextFormField(
                                          controller: _name,
                                          decoration: InputDecoration(
                                            hintText: "Full name",
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "The name field cannot be empty";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 0.0, 5.0),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 0.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListTile(
                                        title: TextFormField(
                                          controller: _email,
                                          decoration: InputDecoration(
                                            hintText: "Email",
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              Pattern pattern =
                                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                              RegExp regex =
                                                  new RegExp(pattern);
                                              if (!regex.hasMatch(value))
                                                return 'Please make sure your email address is valid';
                                              else
                                                return null;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 0.0, 5.0),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 0.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListTile(
                                        title: TextFormField(
                                          controller: _phonenumber,
                                          decoration: InputDecoration(
                                            hintText: "Phone No.",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 0.0, 0.0, 5.0),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 0.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListTile(
                                        title: TextFormField(
                                          controller: _password,
                                          decoration: InputDecoration(
                                            hintText:
                                                "Password : above 6 digits",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    // Text('Above 6 characters'),
                    Positioned(
                      left: 0.0,
                      right: 20.0,
                      top: 90.0,
                      bottom: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(70.0),
                        child: GenderSelection(
                          maleText: "Male", //default Male
                          femaleText: "Female", //default Female
                          selectedGenderIconBackgroundColor:
                              Colors.indigo, // default red
                          checkIconAlignment:
                              Alignment.centerRight, // default bottomRight
                          selectedGenderCheckIcon: null, // default Icons.check
                          onChanged: (Gender gender) {
                            if (gender.toString() == 'Gender.Male') {
                              selectedGender = 'male';
                              print(selectedGender);
                            } else {
                              selectedGender = 'female';
                              print(selectedGender);
                            }
                          },
                          equallyAligned: true,
                          animationDuration: Duration(milliseconds: 400),
                          isCircular: true, // default : true,
                          isSelectedGenderIconCircular: true,
                          opacityOfGradient: 0.6,
                          padding: const EdgeInsets.all(3),
                          size: 120, //default : 120
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      right: 20.0,
                      top: MediaQuery.of(context).size.height/2,
                      bottom: MediaQuery.of(context).size.height/18,
                      child: Padding(
                        padding: const EdgeInsets.all(110.0),
                        child: FlatButton(
                            color: Colors.white,
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1919, 3, 5),
                                  maxTime: DateTime(2020, 1, 1),
                                  onChanged: (date) {
                                dateOfBirth = date;

                                print('change $date');
                              }, onConfirm: (date) {
                                dateOfBirth = date;
                                print('confirm $date');
                                setState(() {
                                  Datee = date.toString();
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Text(
                              'Date of birth',
                              style: TextStyle(color: Colors.deepPurple),
                            )),
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 1.15,
                      right: 0.0,
                      top: MediaQuery.of(context).size.height / 2.5,
                      bottom: MediaQuery.of(context).size.height /2.5,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Text('LOGIN',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ),
                        color: Colors.green.withOpacity(0.7),
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width/5,
                      right: MediaQuery.of(context).size.width/5,
                      top: MediaQuery.of(context).size.height -
                            3  * (MediaQuery.of(context).size.height / 15),
                      bottom: MediaQuery.of(context).size.height/7,
                      child: FlatButton(
                        onPressed: () async {
                          // set up the buttons
                          Widget cancelButton = FlatButton(
                            child: Text("Disagree"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );
                          Widget continueButton = FlatButton(
                            child: Text("Agree"),
                            onPressed: () async {
                              Navigator.pop(context);
                              if (_formKey.currentState.validate()) {
                                try {
                                  if (!await user.signUp(
                                      _name.text,
                                      _email.text,
                                      _password.text,
                                      _phonenumber.text,
                                      selectedGender,
                                      dateOfBirth.toString())) {
                                    _key.currentState.showSnackBar(SnackBar(
                                        content: Text("Sign up failed")));
                                    return;
                                  }
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                } catch (e) {
                                  _key.currentState.showSnackBar(SnackBar(
                                      content: Text("Sign up failed")));
                                }
                              }
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Terms and condition"),
                            content: Text(
                                "By using this app, you agree to us using your data to help solve the corona virus pandemic"),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          );

                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                        child: Text('SIGN UP',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Colors.green.withOpacity(0.7),
                      ),
                    )
                  ],
                )));
  }
}
