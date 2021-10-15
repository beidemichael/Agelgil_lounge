import 'package:agelgil_lounge_end/services/database.dart';
import 'package:flutter/material.dart';

class RadiusInput extends StatefulWidget {
  double newRadius;
  String documentId;
  Function updateZoom;
  RadiusInput({this.newRadius,this.documentId,this.updateZoom});
  @override
  _RadiusInputState createState() => _RadiusInputState();
}

class _RadiusInputState extends State<RadiusInput> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[100].withOpacity(0.9),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  validator: (val) =>
                      val.isEmpty ? 'Radius can\'t be empty' : null,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    widget.newRadius = double.parse(val);
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
                    labelText: widget.newRadius.toString() + 'm',
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
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    DatabaseService(id: widget.documentId)
                        .updateRadius(widget.newRadius);

                    widget.updateZoom();
                  }
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
                        color: Colors.orange[400],
                        borderRadius: BorderRadius.circular(35.0))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
