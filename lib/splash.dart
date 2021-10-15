import 'dart:async';

import 'package:after_layout/after_layout.dart';

import 'package:agelgil_lounge_end/shared/loading.dart';
import 'package:agelgil_lounge_end/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'first_choose.dart';


class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     String userType =  prefs.getString('userType');
    bool _seen = (prefs.getBool('seen') ?? false);
   

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Wrapper(userType: userType,)));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new FirstChoose()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Loading(),
    );
  }
}