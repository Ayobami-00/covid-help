import 'package:flutter/material.dart';
import 'package:covid19_help/pages/homepage.dart';

import 'package:covid19_help/pages/signup.dart';
import 'package:covid19_help/pages/wash.dart';
import 'package:covid19_help/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _initializeNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.green,
      key: _key,
      body: user.status == Status.Authenticating
          ? Loading()
          : Stack(
              children: <Widget>[
                Container(
                  color: Colors.grey.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[350],
                            blurRadius:
                                20.0, // has the effect of softening the shadow
                          )
                        ],
                      ),
                      child: Form(
                          key: _formKey,
                          child: ListView(
                            children: <Widget>[
                              SizedBox(
                                height: 100,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                    alignment: Alignment.topCenter,
                                    child: Image.asset(
                                      "images/icon.png",
                                      width: 80,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    50.0, 8.0, 80.0, 8.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                  elevation: 3.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 80.0),
                                    child: TextFormField(
                                      controller: _email,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        icon: Icon(Icons.alternate_email),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          Pattern pattern =
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                          RegExp regex = new RegExp(pattern);
                                          if (!regex.hasMatch(value))
                                            _key.currentState.showSnackBar(SnackBar(
                                                content: Text(
                                                    'Please make sure your email address is valid')));
                                          else
                                            return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    50.0, 8.0, 80.0, 8.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                  elevation: 3.0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 80.0),
                                    child: TextFormField(
                                      controller: _password,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        icon: Icon(Icons.lock_outline),
                                      ),
                                      obscureText: true,
                                      // validator: (value) {
                                      //   if (value.isEmpty) {
                                      //     _key.currentState.showSnackBar(SnackBar(
                                      //         content: Text(
                                      //             "The password field cannot be empty")));
                                      //   } else if (value.length < 6) {
                                      //     _key.currentState.showSnackBar(SnackBar(
                                      //         content: Text(
                                      //             "The password has to be at least 6 characters long")));
                                      //   }
                                      //   return null;
                                      // },
                                    ),
                                  ),
                                ),
                              ),
                              // Row(
                              //   children: <Widget>[
                              //     Padding(
                              //       padding: const EdgeInsets.fromLTRB(
                              //           105.0, 15.0, 15.0, 15.0),
                              //       child: Text(
                              //         "Forgot password ?",
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.w400,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    50.0, 8.0, 80.0, 8.0),
                                child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.transparent,
                                    elevation: 0.0,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          try {
                                            if (!await user.signIn(
                                                _email.text, _password.text)) {
                                              _key.currentState.showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          "Sign in failed")));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage()));
                                            }
                                          } catch (e) {
                                            _key.currentState.showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Sign in failed")));
                                          }
                                        }
                                      },
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      child: Text(
                                        "LOGIN",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                      ),
                                    )),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(
                              //       120.0, 160.0, 80.0, 8.0),
                              //   child: InkWell(
                              //     onTap: () {},
                              //     child: Row(
                              //       children: <Widget>[
                              //         Icon(Icons.search,
                              //             size: 60.0, color: Colors.white),
                              //         Text('Visit us',
                              //             style:
                              //                 TextStyle(color: Colors.white)),
                              //       ],
                              //     ),
                              //   ),
                              // )
                            ],
                          )),
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width/1.145,
                  right: 0.0,
                  top: 0.0,
                  bottom: 0.0,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: RotatedBox(
                      quarterTurns: -1,
                      child: Text('SIGN UP',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    color: Colors.deepPurple,
                  ),
                )
              ],
            ),
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
