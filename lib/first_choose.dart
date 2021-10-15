import 'package:agelgil_lounge_end/shared/background_blur.dart';
import 'package:agelgil_lounge_end/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstChoose extends StatefulWidget {
  @override
  _FirstChooseState createState() => _FirstChooseState();
}

class _FirstChooseState extends State<FirstChoose> {
  String userType = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundBlur(),
          Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('userType', 'Lounge');

                          userType = 'Lounge';

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Wrapper(
                                        userType: userType,
                                      )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          child: Image(
                            image: AssetImage("images/Eatery.png"),
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[600],
                                blurRadius:
                                    5.0, //effect of softening the shadow
                                spreadRadius:
                                    0.1, //effecet of extending the shadow
                                offset: Offset(
                                    0.0, //horizontal
                                    0.0 //vertical
                                    ),
                              ),
                            ],
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width / 4),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width / 8),
                      InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('userType', 'Carrier');
                          userType = 'Carrier';

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Wrapper(
                                        userType: userType,
                                      )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          child: Image(
                            image: AssetImage("images/Carrier.png"),
                            fit: BoxFit.cover,
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[600],
                                blurRadius:
                                    5.0, //effect of softening the shadow
                                spreadRadius:
                                    0.1, //effecet of extending the shadow
                                offset: Offset(
                                    0.0, //horizontal
                                    0.0 //vertical
                                    ),
                              ),
                            ],
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width / 4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
