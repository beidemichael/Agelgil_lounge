import 'dart:async';

import 'package:agelgil_lounge_end/models/Models.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/orders/my_orders_card.dart';
import 'package:agelgil_lounge_end/shared/background_blur.dart';
import 'package:agelgil_lounge_end/shared/internet_connection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  StreamSubscription subscription;
  bool isInternetConnected = true;
  @override
  void initState() {
    super.initState();
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
    final orders = Provider.of<List<Orders>>(context) ?? [];

    return Scaffold(
      body: Stack(
        children: [
          BackgroundBlur(),
          Stack(
            children: [
              Container(
                  // color: Colors.green,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 90.0),
                    child: orders == null
                        ? Center(
                            child: SpinKitCircle(
                            color: Colors.orange,
                            size: 50.0,
                          ))
                        : Container(
                            child: orders.isEmpty
                                ? Center(
                                    child: Text(
                                        'You don\'t have any orders yet.',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[400],
                                            fontWeight: FontWeight.w600)),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: orders.length,
                                    itemBuilder: (context, index) {
                                      return MyOrdersCard(
                                        orders: orders[index],
                                      );

                                      // }
                                    }),
                          ),
                  )),
              Padding(
                padding: const EdgeInsets.only(right: 75.0, left: 60),
                child: Container(
                  height: 85,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 18.0, left: 10, right: 10),
                    child: Center(
                      child: Text(
                        'Orders',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            color: Colors.grey[600]
                            // fontWeight: FontWeight.w700,
                            // fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400],
                        blurRadius: 5.0, //effect of softening the shadow
                        spreadRadius: 0.5, //effecet of extending the shadow
                        offset: Offset(
                            8.0, //horizontal
                            10.0 //vertical
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
