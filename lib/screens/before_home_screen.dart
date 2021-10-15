import 'dart:async';

import 'package:agelgil_lounge_end/screens/home_screen.dart';
import 'package:agelgil_lounge_end/services/database.dart';
import 'package:agelgil_lounge_end/shared/background_blur.dart';
import 'package:agelgil_lounge_end/shared/internet_connection.dart';
import 'package:agelgil_lounge_end/signin/signIn.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agelgil_lounge_end/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agelgil_lounge_end/models/Models.dart';

class BeforeHomeScreen extends StatefulWidget {
  String userType = '';
  String userUid = '';
  BeforeHomeScreen({this.userType, this.userUid});
  @override
  _BeforeHomeScreenState createState() => _BeforeHomeScreenState();
}

class _BeforeHomeScreenState extends State<BeforeHomeScreen> {
  // String userUid = '';
  StreamSubscription subscription;
  bool isInternetConnected = true;

  @override
  void initState() {
    super.initState();
    // userId();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isInternetConnected = true;
        });
      } else {
        setState(() {
          isInternetConnected = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lounges = Provider.of<List<Lounges>>(context);

    return Scaffold(
      body: Stack(
        children: [
          BackgroundBlur(),
          lounges == null
              ? Loading()
              : Container(
                  child: MultiProvider(
                    providers: [
                      StreamProvider<List<Controller>>.value(
                        value: DatabaseService().controllerInfo,
                      ),
                    ],
                    child: HomeScreen(
                      documentUid: lounges[0].documentId,
                      userType: widget.userType,
                      userUid: widget.userUid,
                    ),
                  ),
                ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Visibility(
                visible: !isInternetConnected, child: InternetConnectivity()),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    subscription.cancel();
  }
}
