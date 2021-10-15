import 'package:flutter/material.dart';
import 'package:agelgil_lounge_end/models/Models.dart';
import 'package:agelgil_lounge_end/services/database.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/menu/menus.dart';
import 'package:provider/provider.dart';

class MenuModule extends StatefulWidget {
  List category = [];
  String name;
  int categoryItems;
  String userUid;
  MenuModule({this.category, this.categoryItems, this.name, this.userUid});
  @override
  _MenuModuleState createState() => _MenuModuleState();
}

class _MenuModuleState extends State<MenuModule> {
  @override
  Widget build(BuildContext context) {
    return Container(
     
      child: StreamProvider<List<Menu>>.value(
        value: DatabaseService(userUid: widget.userUid).menu,
        child: Menus(
          categoryItems: widget.category,
          loungeName: widget.name,
          categoryList: widget.categoryItems,
          userUid: widget.userUid,
        ),
      ),
    );
  }
}
