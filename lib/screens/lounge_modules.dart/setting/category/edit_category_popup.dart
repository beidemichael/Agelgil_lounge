import 'dart:math';

import 'package:agelgil_lounge_end/services/database.dart';
import 'package:agelgil_lounge_end/shared/concave_decoration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../toggle_button.dart';
import 'are_you_sure_you_want_to_delete.dart';

class EditCategorySettingPopup extends StatefulWidget {
  String name;
  int index;
  String documentId;
  bool categoryMoreThanOne;
  EditCategorySettingPopup(
      {this.name, this.documentId, this.index, this.categoryMoreThanOne});
  @override
  _EditCategorySettingPopupState createState() =>
      _EditCategorySettingPopupState();
}

class _EditCategorySettingPopupState extends State<EditCategorySettingPopup> {
  String newName;
  int newIndex;
  String documentId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newName = widget.name;
    newIndex = widget.index;
    documentId = widget.documentId;
  }

  areYouSureYouWantToDelete(BuildContext context, String newName, int index) {
    CatagoryDeleteBlurDialog alert = CatagoryDeleteBlurDialog(
      documentId: documentId,
      newName: newName,
      index: index,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Edit category",
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
                labelText: widget.name,
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
                if (newName == null) {
                  newName = widget.name;
                }

                DatabaseService(id: documentId, index: newIndex)
                    .updateCategory(newName);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  child: Center(
                    child: Text('Update',
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
            Visibility(
              visible: widget.categoryMoreThanOne,
              child: InkWell(
                onTap: () {
                  areYouSureYouWantToDelete(context, newName, newIndex);
                },
                child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    child: Center(
                      child: Text('Delete',
                          style: TextStyle(
                              fontSize: 21.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w100)),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(35.0))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
