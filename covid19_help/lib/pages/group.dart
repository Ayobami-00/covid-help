import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covid19_help/bloc/group_bloc/bloc/group_bloc.dart';
import 'package:covid19_help/services/calls_and_messages_service.dart';
import 'package:covid19_help/services/service_locator.dart';
import 'package:covid19_help/utils/hex_colour.dart';
import 'package:covid19_help/widgets/loading.dart';
import 'package:permission_handler/permission_handler.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final List<String> _dropdownValues = [
    "Add manually",
    "Add from contacts",
  ]; //The list of values we want on the dropdown

  String _selectedValue = "";

  List<Contact> _contacts;
  TextEditingController _textFieldName = TextEditingController();
  TextEditingController _textFieldPhone = TextEditingController();
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  // @override
  // initState() {
  //   super.initState();
  //   refreshContacts();

  // }

  refreshContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      // Load without thumbnails initially.
      var contacts =
          (await ContactsService.getContacts(withThumbnails: false)).toList();
//      var contacts = (await ContactsService.getContactsForPhone("8554964652"))
//          .toList();
      setState(() {
        _contacts = contacts;
      });

      // Lazy load thumbnails after rendering initial contacts.
      for (final contact in contacts) {
        ContactsService.getAvatar(contact).then((avatar) {
          if (avatar == null) return; // Don't redraw if no change.
          setState(() => contact.avatar = avatar);
        });
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  updateContact() async {
    Contact ninja = _contacts
        .toList()
        .firstWhere((contact) => contact.familyName.startsWith("Ninja"));
    ninja.avatar = null;
    await ContactsService.updateContact(ninja);

    refreshContacts();
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.restricted) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.restricted) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Immediately trigger the event
    BlocProvider.of<GroupBloc>(context).add(LoadGroupPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupBloc, GroupState>(
      listener: (context, state) {
        if (state is AddFriendLoaded) {
          if (state.message == 'User does not exist. Click below to invite') {
            // set up the buttons
            Widget cancelButton = FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
              },
            );
            Widget continueButton = FlatButton(
              child: Text("Yes"),
              onPressed: () {
                _service.sendInviteSms(state.phone);
              },
            );

            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text("AlertDialog"),
              content: Text("User does not exist. Click below to invite?"),
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
          } else if (state.message == 'User added successfully!') {
            // set up the button
            Widget okButton = FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            );

            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text("Successful!"),
              content: Text("User added successfully!"),
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
        }
      },
      child: BlocBuilder<GroupBloc, GroupState>(
        builder: (context, state) {
          if (state is GroupInitial) {
            return Loading();
          } else if (state is GroupLoaded) {
            print(state.userId);
            return Scaffold(
                resizeToAvoidBottomPadding: false,
                backgroundColor: HexColor("#d1e9ea"),
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: HexColor("#d1e9ea"),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Friends', style: TextStyle(color: Colors.black)),
                      DropdownButton<String>(
                        items: _dropdownValues
                            .map((data) => DropdownMenuItem<String>(
                                  child: Text(data),
                                  value: data,
                                ))
                            .toList(),
                        onChanged: (String value) {
                          setState(() => _selectedValue = value);
                          if (value == 'Add from contacts') {
                            print('Herw');
                            refreshContacts();
                            Future.delayed(const Duration(milliseconds: 3000),
                                () {
                              print(_contacts);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => GroupBloc(),
                                      child:
                                          AddContactPage(contacts: _contacts),
                                    ),
                                  ));
                            });
                          } else if (value == 'Add manually') {
                            // set up the buttons
                            Widget cancelButton = FlatButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            );
                            Widget continueButton = FlatButton(
                              child: Text("Add"),
                              onPressed: () {
                                Navigator.pop(context);
                                BlocProvider.of<GroupBloc>(context).add(
                                    AddContact(_textFieldName.text,
                                        _textFieldPhone.text));
                                _textFieldName.clear();
                                _textFieldPhone.clear();
                              },
                            );

                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              title: Text(
                                  "Input the following details to add your friend"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    controller: _textFieldName,
                                    decoration:
                                        InputDecoration(hintText: "name"),
                                  ),
                                  TextField(
                                    controller: _textFieldPhone,
                                    decoration: InputDecoration(
                                        hintText: "phone number"),
                                  ),
                                ],
                              ),
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
                          }
                        },
                        hint: Icon(Icons.add, color: Colors.black),
                      )
                    ],
                  ),
                ),
                body: state.userhasFriends == null
                    ? NoFriends()
                    : Friends(userid: state.userId)
                // body: Friends(),
                );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}

class NoFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
            child: Icon(
          Icons.person,
          size: 350.0,
        )),
        Text(
          'You have no friends',
          style: TextStyle(fontSize: 25.0),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Click the + button to add friends',
          style: TextStyle(fontSize: 23.0),
        ),
      ],
    );
  }
}

class Friends extends StatefulWidget {
  final String userid;

  const Friends({Key key, this.userid}) : super(key: key);
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  DatabaseReference _firebaseRef =
      FirebaseDatabase().reference().child('users');
  DatabaseReference _baseFirebaseRef = FirebaseDatabase().reference();
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firebaseRef.child(widget.userid).child('friends').onValue,
        builder: (context, snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            DataSnapshot snapshot = snap.data.snapshot;
            Map item = {};
            Map data = {};
            item = snapshot.value;
            // item.forEach((f) {
            //   if (f != null) {
            //     data.add(item[f]);
            //   }
            // });
            // print(item);
            data = item;
            // print(data);
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  // String last_wash_date = ' ';
                  String key = data.keys.elementAt(index);
                  // _baseFirebaseRef
                  //     .child('user_info')
                  //     .child(data[key]['phone'])
                  //     .child('last_wash_date')
                  //     .once()
                  //     .then((DataSnapshot data) {
                  //   setState(() {
                  //     last_wash_date = data.value;
                  //   });
                  // });
                  // Future.delayed(const Duration(milliseconds: 3000));
                  return StreamBuilder(
                      stream: _baseFirebaseRef
                          .child('user_info')
                          .child(data[key]['phone'])
                          .child('number_of_missed_washes')
                          .onValue,
                      builder: (context, snap) {
                        if (snap.hasData &&
                            !snap.hasError &&
                            snap.data.snapshot.value != null) {
                          DataSnapshot snapshot = snap.data.snapshot;
                          String value;
                          // Map data = {};
                          if ((DateTime.now().hour == 21) ||
                              (DateTime.now().hour == 6) ||
                              ((DateTime.now().hour > 0) &&
                                  (DateTime.now().hour < 7))) {
                            value = "Probably Asleep";
                          } else {
                            value = snapshot.value.toString();
                          }

                          // print(value);

                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            elevation: 2,
                            margin: EdgeInsets.all(12.0),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: ExpansionTile(
                                backgroundColor: Colors.white,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 20.0),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 27.0),
                                      child: Text(data[key]["name"],
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25.0)),
                                    ),
                                    SizedBox(height: 20.0)
                                  ],
                                ),
                                trailing: SizedBox(),
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 47.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text("Number of missed Washes: "),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(value,
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 47.0),
                                  //   child: Row(
                                  //     children: <Widget>[
                                  //       Text("Number of wash today: "),
                                  //       SizedBox(
                                  //         width: 10.0,
                                  //       ),
                                  //       Text("12-34-2002"),
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(height: 20.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 47.0),
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                            onTap: () {
                                              _service.call(data[key]["phone"]);
                                            },
                                            child: Icon(
                                              Icons.call,
                                              color: Colors.blue,
                                            )),
                                        SizedBox(
                                          width: 30.0,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              _service
                                                  .sendSms(data[key]["phone"]);
                                            },
                                            child: Icon(
                                              Icons.message,
                                              color: Colors.red,
                                            )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Center(
                              //   child: CircularProgressIndicator(),
                              );
                        }
                      });
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  // _getLastWashDate(String phone, String user) async {
  //   DateTime lastWashDate;
  //   _firebaseRef
  //       .child()
  //       .child('friends')
  //       .orderByChild("phone")
  //       .equalTo(phone)
  //       .once()
  //       .then((DataSnapshot data) {
  //     if (data.value != null) {
  //       lastWashDate = data.value[0]["last_wash_date"];
  //     }
  //   });
  // }
}

class AddContactPage extends StatefulWidget {
  final List<Contact> contacts;

  const AddContactPage({Key key, this.contacts}) : super(key: key);
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final CallsAndMessagesService _service = locator<CallsAndMessagesService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#d1e9ea"),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: HexColor("#d1e9ea"),
        title: Text('Friends', style: TextStyle(color: Colors.black)),
      ),
      body: BlocListener<GroupBloc, GroupState>(listener: (context, state) {
        if (state is AddFriendLoaded) {
          if (state.message == 'User does not exist. Click below to invite') {
            // set up the buttons
            Widget cancelButton = FlatButton(
              child: Text("No"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
            Widget continueButton = FlatButton(
              child: Text("Yes"),
              onPressed: () {
                _service.sendInviteSms(state.phone);
              },
            );

            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text("Error"),
              content: Text("User does not exist. Click below to invite?"),
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
          } else if (state.message == 'User added successfully!') {
            // set up the button
            Widget okButton = FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );

            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text("Successful!"),
              content: Text("User added successfully!"),
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
        }
      }, child: BlocBuilder<GroupBloc, GroupState>(builder: (context, state) {
        return widget.contacts != null
            ? ListView.builder(
                itemCount: widget.contacts?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Contact c = widget.contacts?.elementAt(index);
                  String phone;
                  try {
                    phone = c.phones?.elementAt(0)?.value ?? 0;
                    // ...
                  } on RangeError catch (e) {
                    phone = '0';
                  }
                  print(phone);
                  return ListTile(
                    onTap: () {
                      showAlertDialog(context, c.displayName, phone);
                    },
                    leading: (c.avatar != null && c.avatar.length > 0)
                        ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                        : CircleAvatar(child: Text(c.initials())),
                    title: Text(c.displayName ?? ""),
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      })),
    );
  }

  showAlertDialog(BuildContext context, String name, String phone) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
        BlocProvider.of<GroupBloc>(context).add(AddContact(name, phone));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add Contact"),
      content: Text("Would you like to add this contact to your friends?"),
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
  }
}
