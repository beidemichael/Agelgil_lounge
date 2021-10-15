import 'dart:math';

import 'package:agelgil_lounge_end/models/Models.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/complete%20orders/complete_orders.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/order_module.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/complete_module.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/setting_module.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/toggle_button.dart';
import 'package:agelgil_lounge_end/services/database.dart';
import 'package:agelgil_lounge_end/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/menu_module.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'lounge_modules.dart/menu/menus.dart';
import 'lounge_modules.dart/update/forced_update.dart';
import 'lounge_modules.dart/update/optional_update.dart';

class LoungeScreen extends StatefulWidget {
  String userUid = '';
  int netVersion;

  LoungeScreen({this.userUid, this.netVersion});
  @override
  _LoungeScreenState createState() => _LoungeScreenState();
}

class _LoungeScreenState extends State<LoungeScreen> {
  List category = [];
  String name = '';
  String id = '';
  String images = '';
  double longitude = 0.0;
  double latitude = 0.0;
  int categoryItems = 0;
  double rating = 0.0;
  bool weAreOpen = true;
  String documentId = '';
  double radius = 0.0;
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  String moduleType = 'orders';
  List<Carriers> carrierList = [];
  int netVersion = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      optionalUpdateActivator(context);
      setState(() {
        netVersion = widget.netVersion;
      });
     
      print(netVersion);
    });
  }

  optionalUpdateActivator(BuildContext context) {
    if (widget.netVersion == 3 || widget.netVersion == 4) {
      OptionalUpdate alert = OptionalUpdate();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lounges = Provider.of<List<Lounges>>(context);
    final orders = Provider.of<List<Orders>>(context);

    if (lounges != null) {
      if (lounges.isNotEmpty) {
        category = lounges[0].category;
        name = lounges[0].name;
        id = lounges[0].id;
        images = lounges[0].images;
        longitude = lounges[0].longitude;
        latitude = lounges[0].latitude;
        categoryItems = lounges[0].category.length;
        rating = lounges[0].rating;
        documentId = lounges[0].documentId;
        weAreOpen = lounges[0].weAreOpen;
        radius = lounges[0].radius;
      }
    }

    return lounges == null
        ? Loading()
        : Scaffold(
            drawer: Drawer(
              child: Container(
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 220,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.orange[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  bottom: 4,
                                  right: 0,
                                  left: 0,
                                  child: Icon(FontAwesomeIcons.building,
                                      size: 80, color: Colors.orange[500]),
                                ),
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Image.network(
                                      images.toString(),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(name,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.orange[800],
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            width: 190,
                            decoration: BoxDecoration(
                              color: Colors.orange[200],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25.0),
                                  bottomRight: Radius.circular(25.0)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(height: 1, color: Colors.orange[800]),
                                Container(
                                  height: 48,
                                  child: Center(
                                    child: Text(
                                        weAreOpen == true
                                            ? 'We are open'
                                            : 'We are closed',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: weAreOpen
                                                ? Colors.orange[800]
                                                : Colors.grey[600],
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Transform.rotate(
                          //   angle: 90 * (pi / 180),
                          //   child: ToggleButton(),
                          // ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10.0),
                          // color: Colors.grey[350],
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            moduleType = 'menu';
                            _scaffoldState.currentState.openEndDrawer();
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[350],
                          ),
                          child: Center(
                            child: Text('Menu',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            moduleType = 'orders';
                            _scaffoldState.currentState.openEndDrawer();
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[350],
                          ),
                          child: Center(
                            child: Text('Orders',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            moduleType = 'setting';
                            _scaffoldState.currentState.openEndDrawer();
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[350],
                          ),
                          child: Center(
                            child: Text('Setting',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          setState(() {
                            moduleType = 'complete';
                            _scaffoldState.currentState.openEndDrawer();
                          });
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[350],
                          ),
                          child: Center(
                            child: Text('Complete Orders',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            key: _scaffoldState,
            body: Container(
                child: lounges.length == 0
                    ? Container(
                        child: Center(
                            child: Text('You are not registered.',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600))),
                      )
                    : Stack(
                        children: [
                          Container(
                            child: moduleType == 'menu'
                                ? MenuModule(
                                    category: category,
                                    name: name,
                                    categoryItems: categoryItems,
                                    userUid: widget.userUid)
                                : moduleType == 'setting'
                                    ? SettingModule(
                                        name: name,
                                        images: images,
                                        rating: rating,
                                        categoryItems: categoryItems,
                                        userUid: widget.userUid,
                                        documentId: documentId,
                                        weAreNowOpen: weAreOpen,
                                        category: category,
                                        radius: radius,
                                        latitude: latitude,
                                        longitude: longitude,
                                        carriers: carrierList,
                                      )
                                    : moduleType == 'complete'
                                        ? CompleteModule(
                                            userUid: widget.userUid,
                                          )
                                        : orders == null
                                            ? Loading()
                                            : OrderModule(),
                          ),
                          Positioned(top: 30, left: -16, child: DrawerButton()),
                          Visibility(
                            visible: netVersion > 4,
                            child: ForcedUpdate(),
                          ),
                        ],
                      )),
          );
  }

  DrawerButton() {
    return GestureDetector(
      onTap: () {
        _scaffoldState.currentState.openDrawer();
      },
      child: Container(
        height: 55,
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.menu, color: Colors.orange, size: 30),
            SizedBox(
              width: 10,
            )
          ],
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey[400],
              blurRadius: 2.0, //effect of softening the shadow
              spreadRadius: 0.1, //effecet of extending the shadow
              offset: Offset(
                  4.0, //horizontal
                  10.0 //vertical
                  ),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
