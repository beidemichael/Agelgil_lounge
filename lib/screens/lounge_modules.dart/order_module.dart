import 'package:agelgil_lounge_end/screens/lounge_modules.dart/orders/my_orders_screen.dart';
import 'package:flutter/material.dart';
class OrderModule extends StatefulWidget {
  @override
  _OrderModuleState createState() => _OrderModuleState();
}

class _OrderModuleState extends State<OrderModule> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: MyOrdersScreen(),
    );
  }
}