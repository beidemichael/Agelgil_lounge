import 'package:agelgil_lounge_end/models/Models.dart';
import 'package:agelgil_lounge_end/services/auth.dart';
import 'package:agelgil_lounge_end/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'lounge_screen.dart';

class HomeScreen extends StatefulWidget {
  String userUid = '';
  String userType = '';
  String documentUid = '';
  HomeScreen({this.userType, this.userUid, this.documentUid});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthServices _auth = AuthServices();
  String token = '';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  int controllerVersion = 0;
  int netVersion;
  /////////////////////////// App version
  int appVersion = 7;
  //////////////////////////  App version

  void getToken() async {
    token = await firebaseMessaging.getToken();
    DatabaseService(
            loungeId: widget.userUid,
            messagingToken: token,
            documentUid: widget.documentUid)
        .newLoungeMessagingToken();
  }

  void getKushnaSub() async {
    await firebaseMessaging.subscribeToTopic('KushnaNotification');
  }

  @override
  void initState() {
    super.initState();
    getToken();

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            alert: true, badge: true, provisional: true, sound: true));

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
    getKushnaSub();
  }

  @override
  Widget build(BuildContext context) {
    final controllerInfo = Provider.of<List<Controller>>(context);
    if (controllerInfo != null) {
      if (controllerInfo.isNotEmpty) {
        controllerVersion = controllerInfo[0].version;
      }
    }
    netVersion = controllerVersion - appVersion;
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Yes, exit',
                      style: TextStyle(color: Colors.orange),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: Container(
        child:  MultiProvider(
                providers: [
                  StreamProvider<List<Orders>>.value(
                    value: DatabaseService(loungeId: widget.userUid).orders,
                  ),
                  StreamProvider<List<Lounges>>.value(
                    value: DatabaseService(
                      userUid: widget.userUid,
                    ).lounges,
                  )
                ],
                child: LoungeScreen(
                  userUid: widget.userUid,
                  netVersion: netVersion,
                ),
              ),
      ),
    );
  }
}
