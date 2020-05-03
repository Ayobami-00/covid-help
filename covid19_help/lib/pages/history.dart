import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covid19_help/bloc/others_bloc/bloc/others_bloc.dart';
import 'package:covid19_help/pages/login.dart';
import 'package:covid19_help/provider/user_provider.dart';
import 'package:covid19_help/services/calls_and_messages_service.dart';
import 'package:covid19_help/services/service_locator.dart';
import 'package:covid19_help/utils/hex_colour.dart';
import 'package:covid19_help/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _currentCountry = 'Cameroon';
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<OthersBloc>(context).add(LoadOthers());
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: HexColor("#d1e9ea"),
          title: Text('Symtomps', style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: HexColor("#d1e9ea"),
        body: BlocBuilder<OthersBloc, OthersState>(builder: (context, state) {
          if (state is OthersLoaded) {
            return ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Fever', style: TextStyle(fontSize: 15.0)),
                        Image.asset(
                          "images/Thermometer_48px.png",
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Row(
                      children: <Widget>[
                        Text('Aches', style: TextStyle(fontSize: 15.0)),
                        Image.asset(
                          "images/EdvardMunch_48px.png",
                          width: 30,
                        ),
                      ],
                    ), // Icon(Icons.label),
                    // Text()
                  ],
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Cough', style: TextStyle(fontSize: 15.0)),
                        Image.asset(
                          "images/Sneeze_50px.png",
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Row(
                      children: <Widget>[
                        Text('Runny Nose', style: TextStyle(fontSize: 15.0)),
                        Image.asset(
                          "images/RunnyNose_48px.png",
                          width: 30,
                        ),
                      ],
                    ), // Icon(Icons.label),
                    // Text()
                  ],
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Difficulty breathing',
                            style: TextStyle(fontSize: 15.0)),
                        Image.asset(
                          "images/Odor_64px.png",
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Row(
                      children: <Widget>[
                        Text('Sore throat', style: TextStyle(fontSize: 15.0)),
                        Image.asset(
                          "images/SadFace_50px.png",
                          width: 30,
                        ),
                      ],
                    ), // Icon(Icons.label),
                    // Text()
                  ],
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('Tiredness', style: TextStyle(fontSize: 15.0)),
                        SizedBox(width:5),
                        Image.asset(
                          "images/BeingSick_50px.png",
                          width: 30,
                        ),
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Row(
                      children: <Widget>[
                        Text('Bluish Face', style: TextStyle(fontSize: 15.0)),
                        Image.asset(
                          "images/Face_50px.png",
                          width: 30,
                        ),
                      ],
                    ), // Icon(Icons.label),
                  ],
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text('CALL FOR CDC HELP',
                      style:
                          TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 25.0),
                Row(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          width: 40.0,
                        ),
                        DropdownButton<String>(
                            items: state.othersList.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _currentCountry = value;
                              });
                            },
                            value: _currentCountry),
                        SizedBox(
                          width: 5.0,
                        ),
                        InkWell(
                            onTap: () {
                              String phone = state.othersDict[_currentCountry]
                                  .toString()
                                  .replaceAll(' ', '');
                              _service.call(phone);
                            },
                            child: Icon(
                              Icons.call,
                              color: Colors.blue,
                              size: 50.0,
                            )),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        'We need your support to keep this app live and our developers need a glass of beer and cofee to stay awake.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(90.0, .0, 90.0, .0),
                //   child: Material(
                //       borderRadius: BorderRadius.circular(10.0),
                //       color: Colors.green,
                //       elevation: 0.0,
                //       child: MaterialButton(
                //         onPressed: () async {},
                //         minWidth: MediaQuery.of(context).size.width,
                //         child: Text(
                //           "FUND US",
                //           textAlign: TextAlign.center,
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontWeight: FontWeight.bold,
                //               fontSize: 15.0),
                //         ),
                //       )),
                // ),
                InkWell(
                  onTap: () async {
                    String url  = 'https://www.paypal.com/ng/webapps/mpp/send-money-online';
                    if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                      
                      }
                  },
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "images/paypal_1215259.png",
                        width: 100,
                      ),
                      Text('help@freetek.com.ng')
                    ],
                  ),
                ),
                SizedBox(height: 20.0),

                InkWell(
                  onTap: () async {
                    // user.signOut();
                    String url  = 'https://www.freetek.com.ng';
                    if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                      
                      }
                  },
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 140.0,
                      ),
                      Icon(Icons.search, size: 30.0, color: Colors.blue),
                      Text('Contact us', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is OthersInitial) {
            return Loading();
          }
        }));
  }
}
