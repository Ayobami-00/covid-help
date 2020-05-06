import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:covidhelp/bloc/group_bloc/bloc/group_bloc.dart';
import 'package:covidhelp/bloc/news_bloc/bloc/news_bloc.dart';
import 'package:covidhelp/bloc/others_bloc/bloc/others_bloc.dart';
import 'package:covidhelp/bloc/stats_bloc/bloc/stats_bloc.dart';
import 'package:covidhelp/bloc/wash_bloc/bloc/wash_bloc.dart';
import 'package:covidhelp/bloc/wash_bloc/bloc/wash_bloc.dart';
import 'package:covidhelp/pages/news.dart';
import 'package:covidhelp/pages/group.dart';
import 'package:covidhelp/pages/statistics.dart';
import 'package:covidhelp/pages/wash.dart';
import 'package:covidhelp/pages/history.dart';
import 'package:covidhelp/provider/user_provider.dart';
import 'package:covidhelp/repositories/repositories.dart';
import 'package:covidhelp/utils/hex_colour.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String payload;

  const HomePage({Key key, this.payload}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static String _payload;
  int _currentIndex = 2;
  static final ApiRepository apiRepository =
      ApiRepository(apiClient: ApiClient());
  final List<Widget> _children = [
    BlocProvider(
      create: (context) => NewsBloc(apiRepository),
      child: NewsPage(),
    ),
    BlocProvider(
      create: (context) => StatsBloc(apiRepository),
      child: StatsPage(),
    ),
    BlocProvider(
      create: (context) => WashBloc(),
      child: WashPage(payload: _payload),
    ),
    BlocProvider(
      create: (context) => GroupBloc(),
      child: GroupPage(),
    ),
    BlocProvider(
      create: (context) => OthersBloc(),
      child: HistoryPage(),
    ),
  ];

  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');
  @override
  void initState() {
    _payload = widget.payload;
    super.initState();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomePage(payload: receivedNotification.payload),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage(payload: payload),
      //   ),
      // );
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: HexColor("#d1e9ea"),
      body: _children[_currentIndex],
      //  _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/news.svg',
              width: 20.0,
              color: Colors.black,
            ),
            title: new Text(
              'News',
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/business-and-finance-1.svg',
              width: 20.0,
              // color: Colors.black,
            ),
            title: new Text(
              'Statistics',
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/soap.svg',
              width: 30.0,
              // color: Colors.black,
            ),
            title: new Text(
              'Wash',
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'images/team.svg',
              width: 20.0,
              // color: Colors.black,
            ),
            title: new Text(
              'Friends',
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.more_horiz,
              color: Colors.black,
              size: 35.0
            ),
            title: new Text(
              'Symptoms',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
