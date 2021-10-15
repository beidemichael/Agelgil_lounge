import 'dart:async';

import 'package:agelgil_lounge_end/services/database.dart';
import 'package:agelgil_lounge_end/shared/background_blur.dart';
import 'package:agelgil_lounge_end/shared/internet_connection.dart';
import 'package:agelgil_lounge_end/signin/signIn.dart';
import 'package:connectivity/connectivity.dart';
import 'package:agelgil_lounge_end/screens/before_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/Models.dart';

class Wrapper extends StatefulWidget {
  String userType = '';
  Wrapper({this.userType});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
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
    final user = Provider.of<UserUid>(context);

    return Scaffold(
      body: Stack(
        children: [
          BackgroundBlur(),
          Container(
            child: user == null
                ? SignIn(
                    userType: widget.userType,
                  )
                : MultiProvider(
                    providers: [
                      StreamProvider<List<Lounges>>.value(
                        value: DatabaseService(
                          userUid: user.uid,
                        ).lounges,
                      )
                    ],
                    child: BeforeHomeScreen(
                      userType: widget.userType,
                      userUid: user.uid,
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
