import 'package:agelgil_lounge_end/first_choose.dart';
import 'package:agelgil_lounge_end/screens/home_screen.dart';
import 'package:agelgil_lounge_end/shared/loading.dart';
import 'package:agelgil_lounge_end/splash.dart';
import 'package:agelgil_lounge_end/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/Models.dart';
import 'services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        // if (snapshot.hasError) {
        //   return SomethingWentWrong();
        // }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              StreamProvider<UserUid>.value(
                value: AuthServices().user,
              ),
             
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Wrapper(
                userType: 'Lounge',
              ),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(body: Loading()),
        );
      },
    );
  }
}
