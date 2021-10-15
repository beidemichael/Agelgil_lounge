import 'dart:io';

import 'package:agelgil_lounge_end/shared/concave_decoration.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:agelgil_lounge_end/services/database.dart';
import 'package:image_picker/image_picker.dart';

class EditName extends StatefulWidget {
  String userUid;
  String name;
  String documentId;
  String images;
  EditName({this.userUid, this.name, this.documentId, this.images});
  @override
  _EditNameState createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  String newName;
  File imageFile;
  String newImage;
  bool loading = false;
  Future getImage() async {
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);

    setState(() {
      imageFile = File(pickedFile.path);
    });
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
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: imageFile != null
                      ? Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                imageFile,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Stack(
                            children: [
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.orange[100],
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[400],
                                      blurRadius:
                                          15.0, //effect of softening the shadow
                                      spreadRadius:
                                          1.5, //effecet of extending the shadow
                                      offset: Offset(
                                          0.0, //horizontal
                                          15.0 //vertical
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 5,
                                right: 0,
                                left: 0,
                                child: Icon(FontAwesomeIcons.building,
                                    size: 60, color: Colors.orange[500]),
                              ),
                              Container(
                                height: 100,
                                width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    widget.images.toString(),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(FontAwesomeIcons.camera,
                                      size: 15, color: Colors.grey[500]),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: ConcaveDecoration(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      colors: [
                                        Colors.white,
                                        Colors.grey[700],
                                      ],
                                      depression: 5.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                Positioned(
                  
                  child: Visibility(
                    visible: loading,
                    child: Center(
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Center(
                            child: SpinKitCircle(
                          color: Colors.orange,
                          size: 50.0,
                        )),
                      ),
                    ),
                  ),
                )
              ],
            ),
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
              onTap: () async {
                setState(() {
                  loading = true;
                });
                if (newName == null) {
                  newName = widget.name;
                }
                if (newImage == null) {
                  newImage = widget.images;
                }
                if (imageFile != null) {
                  StorageReference ref = FirebaseStorage.instance.ref();
                  StorageTaskSnapshot addImg = await ref
                      .child("Lounges/${widget.documentId}")
                      .putFile(imageFile)
                      .onComplete;
                  if (addImg.error == null) {
                    print("added to Firebase Storage");
                    final String downloadUrl =
                        await addImg.ref.getDownloadURL();
                    setState(() {
                      newImage = downloadUrl;
                    });
                  } else {
                    print(addImg.error);
                  }
                }

                DatabaseService(id: widget.documentId)
                    .updateLoungeName(newName, newImage);
                setState(() {
                  loading = false;
                });
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
          ],
        ),
      ),
    );
  }
}
