import 'package:agelgil_lounge_end/services/database.dart';
import 'package:agelgil_lounge_end/shared/concave_decoration.dart';
import 'package:agelgil_lounge_end/shared/orange_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../toggle_button.dart';

class AddFoodPopup extends StatefulWidget {
  String category;
  String userUid;
  AddFoodPopup({this.category, this.userUid});
  @override
  _AddFoodPopupState createState() => _AddFoodPopupState();
}

class _AddFoodPopupState extends State<AddFoodPopup> {
  String category;
  String newName;
  double newPrice;
  String userUid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category = widget.category;
    userUid = widget.userUid;
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
            
            SizedBox(height: 35),
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
                labelText: 'Food name',
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
            SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (val) => val.isEmpty ? 'Price cant be empty' : null,
              onChanged: (val) {
                newPrice = double.parse(val);
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
                labelText: 'Price',
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
                  newName = '';
                }
                if (newPrice == null) {
                  newPrice = 0;
                }

                DatabaseService()
                    .createNewMenuItem(newName, newPrice, userUid, category);
                Navigator.of(context).pop();
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
    );
  }
}
