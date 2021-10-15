import 'dart:math';

import 'package:agelgil_lounge_end/services/database.dart';
import 'package:agelgil_lounge_end/shared/concave_decoration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../toggle_button.dart';

class AddCategorySettingPopup extends StatefulWidget {
  String documentId;

  AddCategorySettingPopup({
    this.documentId,
  });
  @override
  _AddCategorySettingPopupState createState() =>
      _AddCategorySettingPopupState();
}

class _AddCategorySettingPopupState extends State<AddCategorySettingPopup> {
  final _formKey = GlobalKey<FormState>();
  String newName;
  int newIndex;
  String documentId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    documentId = widget.documentId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add category",
                    style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Divider(
                color: Colors.grey,
                height: 4.0,
              ),
              SizedBox(
                height: 35.0,
              ),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ? 'Category can\'t be empty' : null,
                onChanged: (val) {
                  newName = val;
                },
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                    // decorationColor: Colors.white,
                    ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20),

                  //Label Text/////////////////////////////////////////////////////////

                  focusColor: Colors.orange[900],
                  labelText: 'Name of new category',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                      color: Colors.grey[800]),
                  /* hintStyle: TextStyle(
                                    color: Colors.orange[900]
                                    ) */
                  ///////////////////////////////////////////////

                  //when it's not selected////////////////////////////
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.grey[400])),
                  ////////////////////////////////

                  ///when textfield is selected//////////////////////////
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.orange[200])),
                  ////////////////////////////////////////
                ),
              ),
              SizedBox(height: 35),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    child: Center(
                      child: Text('Cancel',
                          style: TextStyle(
                              fontSize: 21.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w100)),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(35.0))),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    DatabaseService(id: documentId, index: newIndex)
                        .addNewCategory(newName);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                },
                child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    child: Center(
                      child: Text('Add',
                          style: TextStyle(
                              fontSize: 21.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w100)),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(35.0))),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
