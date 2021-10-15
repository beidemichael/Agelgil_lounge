import 'package:agelgil_lounge_end/models/Models.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/complete%20orders/complete_orders.dart';
import 'package:agelgil_lounge_end/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompleteModule extends StatelessWidget {
  String userUid;
  CompleteModule({this.userUid});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Orders>>.value(
      value: DatabaseService(loungeId: userUid).completeOrders,
      child: CompleteOrders(),
    );
  }
}
