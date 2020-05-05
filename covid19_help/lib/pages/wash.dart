import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:covid19_help/bloc/wash_bloc/bloc/wash_bloc.dart';
import 'package:covid19_help/services/sharedPreferencesDb.dart';
import 'package:covid19_help/utils/hex_colour.dart';
import 'package:covid19_help/widgets/cleaning.dart';
import 'package:covid19_help/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

class WashPage extends StatefulWidget {
  final String payload;

  const WashPage({Key key, this.payload}) : super(key: key);
  @override
  _WashPageState createState() => _WashPageState();
}

class _WashPageState extends State<WashPage> {
  Timer _timer;

  initializeNotification() async {
    // needed if you intend to initialize in the `main` function
    // WidgetsFlutterBinding.ensureInitialized();

    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<WashBloc>(context).add(LoadWashPage());
  }

  @override
  void initState() {
    super.initState();

    // _doSomething();
    initializeNotification();
    _checkIfFirstLoad();
    // print(widget.payload);
    // if (widget.payload == 'NOTIFICATION') {
    //   showNotificationAlertDialog(context);
    // }

    // }
    _timer = Timer.periodic(Duration(seconds: 1800), (timer) {
      showAlertDialog(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#d1e9ea"),
        body: BlocBuilder<WashBloc, WashState>(builder: (context, state) {
          if (state is HandsWashed) {
            return ListView(children: <Widget>[
              SizedBox(height: 80.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // _tips(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text('How did you sanitize your hands?'),
                                Text('With soap or a sanitizer?'),
                                Text('Touch the right icon'),
                                Text('to let us know!'),
                              ],
                            ),
                            SizedBox(width: 40.0),
                            InkWell(
                              onTap: () {
                                showAlertDialog(context);
                                _showAnotification();
                              },
                              child: Column(
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'images/Iconawesome-lightbulb.svg',
                                    width: 30.0,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text('More Tips'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            _showNotification();
                            _showDailyNotificationMorning();
                            _showDailyNotificationMorning2();
                            _showDailyNotificationMorning3();
                            _showDailyNotificationEvening();
                            BlocProvider.of<WashBloc>(context)
                                .add(CleanHands());
                            showNotificationAlertDialog(context);
                          },
                          child: SvgPicture.asset(
                            'images/faucet.svg',
                            width: 100.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _showNotification();
                            _showDailyNotificationMorning();
                            _showDailyNotificationMorning2();
                            _showDailyNotificationMorning3();
                            _showDailyNotificationEvening();
                            BlocProvider.of<WashBloc>(context)
                                .add(CleanHands());
                            showNotificationAlertDialog(context);
                          },
                          child: SvgPicture.asset(
                            'images/hand-sanitizer.svg',
                            width: 100.0,
                          ),
                        ),
                      ]),
                ),
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  child: SvgPicture.asset(
                    'images/soap.svg',
                    width: 150.0,
                    height: 150.0,
                    // color: state Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 210.0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text("Today's Record"),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor("#415f77"),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[350],
                        blurRadius:
                            20.0, // has the effect of softening the shadow
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.timer,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    enabled: true,
                    // title:
                    // Text("Next Wash",
                    //     style: TextStyle(color: Colors.white)),
                    // subtitle: Text(state.nextWashDate,
                    //     style: TextStyle(color: Colors.white)),
                    title:state.numberOfMissedWashes == 1?  Text(
                        'You have missed ${state.numberOfMissedWashes} wash',
                        style: TextStyle(color: Colors.white)) : Text(
                        'You have missed ${state.numberOfMissedWashes} wash',
                        style: TextStyle(color: Colors.white))

                    // Column(
                    //   children: <Widget>[
                    //     SizedBox(height: 10.0),
                    // Text('You have missed ${state.numberOfMissedWashes} washes',
                    //     style: TextStyle(color: Colors.white)),
                    //         SizedBox(height: 5.0),
                    //     Text('${state.numberOfMissedWashes} washes',
                    //         style: TextStyle(color: Colors.white)),
                    //   ],
                    // )
                  ),
                ),
              ),
            ]);
          } else if (state is WashInitial) {
            return Loading();
          }
        }));
  }

  showAlertDialog(BuildContext context) {
    Map<String, String> tips_dict = {
      "Wash your hands frequently":
          "Regularly and thoroughly clean your hands with an alcohol-based hand rub or wash them with soap and water. Why? Washing your hands with soap and water or using alcohol-based hand rub kills viruses that may be on your hands.",
      "Maintain social distancing":
          "Maintain at least 1 metre (3 feet) distance between yourself and anyone who is coughing or sneezing. Why? When someone coughs or sneezes they spray small liquid droplets from their nose or mouth which may contain virus. If you are too close, you can breathe in the droplets, including the COVID-19 virus if the person coughing has the disease.",
      "Avoid touching eyes, nose and mouth":
          "Why? Hands touch many surfaces and can pick up viruses. Once contaminated, hands can transfer the virus to your eyes, nose or mouth. From there, the virus can enter your body and can make you sick.",
      "Practice respiratory hygiene":
          "Make sure you, and the people around you, follow good respiratory hygiene. This means covering your mouth and nose with your bent elbow or tissue when you cough or sneeze. Then dispose of the used tissue immediately. Why? Droplets spread virus. By following good respiratory hygiene you protect the people around you from viruses such as cold, flu and COVID-19.",
      "If you have fever, cough and difficulty breathing, seek medical care early":
          "Stay home if you feel unwell. If you have a fever, cough and difficulty breathing, seek medical attention and call in advance. Follow the directions of your local health authority. Why? National and local authorities will have the most up to date information on the situation in your area. Calling in advance will allow your health care provider to quickly direct you to the right health facility. This will also protect you and help prevent spread of viruses and other infections.",
      "Stay informed and follow advice given by your healthcare provider":
          "Stay informed on the latest developments about COVID-19. Follow advice given by your healthcare provider, your national and local public health authority or your employer on how to protect yourself and others from COVID-19. Why? National and local authorities will have the most up to date information on whether COVID-19 is spreading in your area. They are best placed to advise on what people in your area should be doing to protect themselves.",
      "Remember to wear your facemasks":
          "Always remember to wear your face mask everywhere you go to keep you protected"
    };

    String key =
        tips_dict.keys.elementAt(new Random().nextInt(tips_dict.length));
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(key),
      content: Text(tips_dict[key]),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _showNotification() async {
    print('Notification entered');
    await flutterLocalNotificationsPlugin.cancelAll();

    if ((DateTime.now().hour == 7) ||
        (DateTime.now().hour == 8) ||
        (DateTime.now().hour == 21) ||
        (DateTime.now().hour == 6) ||
        ((DateTime.now().hour > 0) && (DateTime.now().hour < 7))) {
      // Show a notification every minute with the first appearance happening a minute after invoking the method
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeating channel id',
        'repeating channel name',
        'repeating description',
        ongoing: true,
        autoCancel: false,
      );
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.periodicallyShow(
          1005,
          'Time to Sanitize those hands!',
          'It is time to wash those hands, wash your hands using your preferred method and go to the Wash page to tell everyone that you have done so!',
          RepeatInterval.Hourly,
          platformChannelSpecifics,
          payload: 'NOTIFICATION');
      print('Notification entered');
    }
  }

  Future<void> _showDailyNotificationMorning() async {
    print('Morning entered');
    var time = Time(7, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        50,
        'Time to Sanitize those hands!',
        'It is time to wash those hands, wash your hands using your preferred method and go to the Wash page to tell everyone that you have done so!',
        time,
        platformChannelSpecifics,
        payload: 'NOTIFICATION');
  }

  Future<void> _showDailyNotificationMorning2() async {
    print('Morning entered');
    var time = Time(7, 45, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        50,
        'Time to Sanitize those hands!',
        'It is time to wash those hands, wash your hands using your preferred method and go to the Wash page to tell everyone that you have done so!',
        time,
        platformChannelSpecifics,
        payload: 'NOTIFICATION');
  }

  Future<void> _showDailyNotificationMorning3() async {
    print('Morning entered');
    var time = Time(8, 30, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        50,
        'Time to Sanitize those hands!',
        'It is time to wash those hands, wash your hands using your preferred method and go to the Wash page to tell everyone that you have done so!',
        time,
        platformChannelSpecifics,
        payload: 'NOTIFICATION');
  }

  Future<void> _showDailyNotificationEvening() async {
    print('Evening entered');
    await flutterLocalNotificationsPlugin.cancelAll();

    var time = Time(22, 0, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        60,
        'Time to Sanitize those hands!',
        'It is time to wash those hands, wash your hands using your preferred method and go to the Wash page to tell everyone that you have done so!',
        time,
        platformChannelSpecifics,
        payload: 'NOTIFICATION');
  }

  Future<void> _showAnotification() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(seconds: 10));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(0, 'TEST', 'TEST WORKS',
        scheduledNotificationDateTime, platformChannelSpecifics);
  }

  showNotificationAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Hands are clean!'),
      content: Text(
          "Yay! Bet those hands are cleaner now. Remember to keep washing your hands. Stay safe!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> getStringValuesSF(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(name);
    return stringValue;
  }

  _checkIfFirstLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('FIRST_TIME');
    if (stringValue == 'True') {
      _showNotification();
      _showDailyNotificationMorning();
      _showDailyNotificationMorning2();
      _showDailyNotificationMorning3();
      _showDailyNotificationEvening();
      Sharedpreference().addStringToSF('FIRST_TIME', 'False');
    }
  }

  // _doSomething() async {
  //   var _firebaseRef = FirebaseDatabase().reference();
  //   FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   String phone = await _firebaseRef
  //       .child('users')
  //       .child(user.uid)
  //       .child('phone')
  //       .once()
  //       .then((data) {
  //     return data.value;
  //   });
  //   // Map id = phone;
  //   print(phone);
  // }
}
