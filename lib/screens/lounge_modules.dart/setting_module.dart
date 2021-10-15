import 'dart:async';
import 'dart:math';

import 'package:agelgil_lounge_end/screens/lounge_modules.dart/setting/category/category_list_dialog.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/setting/radiusMap/radius_map.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/toggle_button.dart';
import 'package:agelgil_lounge_end/shared/background_blur.dart';
import 'package:agelgil_lounge_end/shared/internet_connection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/setting/name/setting_edit_name.dart';

import 'package:agelgil_lounge_end/services/database.dart';
import 'package:agelgil_lounge_end/models/Models.dart';

class SettingModule extends StatefulWidget {
  List category = [];
  String userUid;
  String name;
  double rating;
  String images;
  int categoryItems;
  String documentId;
  bool weAreNowOpen;
  double radius;
  double latitude;
  double longitude;
  List<Carriers> carriers = [];
  SettingModule(
      {this.images,
      this.name,
      this.rating,
      this.categoryItems,
      this.userUid,
      this.documentId,
      this.weAreNowOpen,
      this.category,
      this.radius,
      this.latitude,
      this.longitude,
      this.carriers});
  @override
  _SettingModuleState createState() => _SettingModuleState();
}

class _SettingModuleState extends State<SettingModule> {
  bool weAreOpen;
  bool categoryMoreThanOne;
  List<Carriers> carrierListVariable = [];
  StreamSubscription subscription;
  bool isInternetConnected = true;

  @override
  void initState() {
    // TODO: implement initState
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

    if (widget.weAreNowOpen == true) {
      weAreOpen = true;
    } else {
      weAreOpen = false;
    }
  }

  categoryList(BuildContext context, List category, String documentId,
      bool categoryMoreThanOne) {
    CategoryListBlurDialog alert =
        CategoryListBlurDialog(category, documentId, categoryMoreThanOne);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

 

  @override
  Widget build(BuildContext context) {
    if (widget.carriers != null) {
      carrierListVariable = widget.carriers;
    }
    setState(() {
      ////////////////so that eatery opertators can't delete the only left category item in the category list.
      if (widget.category.length > 1) {
        categoryMoreThanOne = true;
      } else {
        categoryMoreThanOne = false;
      }
    });
    void editNameTapped() {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: FractionallySizedBox(
                heightFactor: 0.6,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: EditName(
                    userUid: widget.userUid,
                    name: widget.name,
                    documentId: widget.documentId,
                    images: widget.images,
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
      body: Stack(
        children: [
          BackgroundBlur(),

          Padding(
            padding: const EdgeInsets.only(top: 90.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              // color: Colors.red,
              child: ListView(
                children: [
                  //////////////////////We are now open toggle button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[400],
                            blurRadius: 5.0, //effect of softening the shadow
                            spreadRadius: 0.5, //effecet of extending the shadow
                            offset: Offset(
                                0.0, //horizontal
                                0.0 //vertical
                                ),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      weAreOpen
                                          ? 'We are open'
                                          : 'We are closed',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600)),
                                  Transform.rotate(
                                    angle: 180 * (pi / 180),
                                    child: InkWell(
                                      onTap: () {
                                        if (weAreOpen == false) {
                                          setState(() {
                                            weAreOpen = true;
                                          });
                                        } else {
                                          setState(() {
                                            weAreOpen = false;
                                          });
                                        }
                                        DatabaseService(id: widget.documentId)
                                            .updateLoungeWeAreOpen(weAreOpen);
                                      },
                                      child: ToggleButton(
                                        isAvaliable: weAreOpen,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  ////////////////////name and rating container
                  InkWell(
                    onTap: () {
                      editNameTapped();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400],
                              blurRadius: 5.0, //effect of softening the shadow
                              spreadRadius:
                                  0.5, //effecet of extending the shadow
                              offset: Offset(
                                  0.0, //horizontal
                                  0.0 //vertical
                                  ),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Name',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600)),
                                    Text(widget.name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.orange[500],
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  /////////////////delivery radius
                  // SizedBox(height: 15),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (_) => RadiusMap(
                  //                 documentId: widget.documentId,
                  //                 radius: widget.radius,
                  //                 latitude: widget.latitude,
                  //                 longitude: widget.longitude,
                  //               )),
                  //     );
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.grey[400],
                  //             blurRadius: 5.0, //effect of softening the shadow
                  //             spreadRadius:
                  //                 0.5, //effecet of extending the shadow
                  //             offset: Offset(
                  //                 0.0, //horizontal
                  //                 0.0 //vertical
                  //                 ),
                  //           ),
                  //         ],
                  //         borderRadius: BorderRadius.circular(10.0),
                  //         color: Colors.white,
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 13.0),
                  //         child: Column(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 15.0),
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text('Delivery radius',
                  //                       style: TextStyle(
                  //                           fontSize: 20,
                  //                           color: Colors.grey[600],
                  //                           fontWeight: FontWeight.w600)),
                  //                   Text(widget.radius.toString() + 'm',
                  //                       style: TextStyle(
                  //                           fontSize: 20,
                  //                           color: Colors.orange[500],
                  //                           fontWeight: FontWeight.w600)),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  ////////////catergory
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      categoryList(context, widget.category, widget.documentId,
                          categoryMoreThanOne);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400],
                              blurRadius: 5.0, //effect of softening the shadow
                              spreadRadius:
                                  0.5, //effecet of extending the shadow
                              offset: Offset(
                                  0.0, //horizontal
                                  0.0 //vertical
                                  ),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Category',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600)),
                                    Text(widget.categoryItems.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.orange[500],
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ///////////carriers
                  SizedBox(height: 15),
                  // InkWell(
                  //   onTap: () {
                  //     carrierList(context, carrierListVariable);
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.grey[400],
                  //             blurRadius: 5.0, //effect of softening the shadow
                  //             spreadRadius:
                  //                 0.5, //effecet of extending the shadow
                  //             offset: Offset(
                  //                 0.0, //horizontal
                  //                 0.0 //vertical
                  //                 ),
                  //           ),
                  //         ],
                  //         borderRadius: BorderRadius.circular(10.0),
                  //         color: Colors.white,
                  //       ),
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 13.0),
                  //         child: Column(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 15.0),
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Text('Carriers',
                  //                       style: TextStyle(
                  //                           fontSize: 20,
                  //                           color: Colors.grey[600],
                  //                           fontWeight: FontWeight.w600)),
                  //                   Text(carrierListVariable.length.toString(),
                  //                       style: TextStyle(
                  //                           fontSize: 20,
                  //                           color: Colors.orange[500],
                  //                           fontWeight: FontWeight.w600)),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
////////////////////top setting container
          Padding(
            padding: const EdgeInsets.only(right: 75.0, left: 60),
            child: Container(
              height: 85,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0, left: 10, right: 10),
                child: Center(
                  child: Text(
                    'Setting',
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
