import 'dart:async';

import 'package:agelgil_lounge_end/models/Models.dart';
import 'package:agelgil_lounge_end/shared/background_blur.dart';
import 'package:agelgil_lounge_end/shared/internet_connection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:provider/provider.dart';

import 'add_food_popup copy.dart';
import 'edit_food_popup.dart';

class Menus extends StatefulWidget {
  List categoryItems;
  String loungeName;
  int categoryList;
  String userUid;
  Menus({this.loungeName, this.categoryList, this.categoryItems, this.userUid});
  @override
  _MenusState createState() => _MenusState();
}

class _MenusState extends State<Menus> with TickerProviderStateMixin {
  final PageController ctrl = PageController(viewportFraction: 0.8);
  StreamSubscription subscription;
  bool isInternetConnected = true;
  // Keep track of current page to avoid unnecessary renders
  int currentPage = 0;
  int currentIndex = 0;
  // for keeping track of the number page indicators like carousel
  double paddingWidth, n;

  int colorNumber = 0;

  @override
  void initState() {
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


    // Set state when page changes
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
          if (colorNumber == 10) {
            colorNumber = 0;
          }
          if (colorNumber < 10) {
            ++colorNumber;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    void whenAddNewItemTapped(String category, String userUid) {
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
                  child: AddFoodPopup(category: category, userUid: userUid),
                ),
              ),
            );
          });
    }

    void whenUpDateTapped(String name, double price, String images,
        bool isAvaliable, String documentId) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: FractionallySizedBox(
                heightFactor: 0.8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: EditFoodPopup(
                    name: name,
                    price: price,
                    images: images,
                    isAvaliable: isAvaliable,
                    documentId: documentId,
                  ),
                ),
              ),
            );
          });
    }

    paddingWidth = MediaQuery.of(context).size.width - (155);
    n = widget.categoryItems.length.toDouble();

    final menu = Provider.of<List<Menu>>(context) ?? [];

    return Scaffold(
      body: Stack(
        children: <Widget>[
          BackgroundBlur(),
          Positioned(
            //////////////////////////////////////top color changing container containing category name
            child: Padding(
              padding: const EdgeInsets.only(right: 75.0, left: 60),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: 85,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 18.0, left: 10, right: 10),
                  child: Center(
                    child: Marquee(
                      backDuration: Duration(milliseconds: 500),
                      directionMarguee: DirectionMarguee.oneDirection,
                      child: Text(
                        widget.categoryItems[currentPage].toUpperCase(),
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
          ),
          Positioned(
            ///////////////////////////////top carousel type page locating circles
            top: 70,
            child: Padding(
              padding: const EdgeInsets.only(right: 85.0, left: 70),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 10,
                    width: ((paddingWidth - (7 * n)) / (n + 1)),
                    // color: Colors.yellow,
                  ),
                  Container(
                    height: 10,
                    // color: Colors.blue,
                    width: (((paddingWidth - (7 * n)) / (n + 1)) + 7) * n,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: n.toInt(),
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              height: 7,
                              width: 7,
                              decoration: BoxDecoration(
                                color: index == currentPage
                                    ? Colors.grey[600]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            Container(
                              height: 10,
                              width: ((paddingWidth - (7 * n)) / (n + 1)),
                              // color: Colors.yellow,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            //////////////////////////////center animated container
            // Animated Properties

            child: PageView.builder(
              controller: ctrl,
              itemCount: widget.categoryList,
              itemBuilder: (context, int currentIdx) {
                // Active page

                currentIndex = currentIdx;
                bool active = currentIdx == currentPage;
                final double blur = active ? 7 : 0;
                final double offset = active ? 23 : 0;
                final double top = active ? 100 : 300;
                final double bottom = active ? 0 : 60;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                  margin: EdgeInsets.only(top: top, bottom: bottom, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: currentPage == currentIndex
                        ? BorderRadius.circular(10)
                        : BorderRadius.circular(10),
                    color: currentPage == currentIndex
                        ? Colors.white
                        : Colors.grey[200],
                    // image: DecorationImage(
                    //   fit: BoxFit.cover,
                    //   image: NetworkImage(data['img']),
                    // ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[400],
                          blurRadius: blur,
                          offset: Offset(offset, offset)),
                      BoxShadow(
                        color: Colors.grey[600],
                        blurRadius: 0.2,
                      )
                    ],
                  ),
                  child: Visibility(
                    visible: currentPage == currentIndex,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      child: ListView.builder(
                        itemCount: menu.length,
                        itemBuilder: (context, index) {
                          return menu[index].category ==
                                  widget.categoryItems[currentPage]
                              ? GestureDetector(
                                  onTap: () {
                                    whenUpDateTapped(
                                        menu[index].name,
                                        menu[index].price,
                                        menu[index].images,
                                        menu[index].isAvaliable,
                                        menu[index].documentId);
                                  },
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey[400],
                                                  blurRadius:
                                                      5.0, //effect of softening the shadow
                                                  spreadRadius:
                                                      0.1, //effecet of extending the shadow
                                                  offset: Offset(
                                                      8.0, //horizontal
                                                      10.0 //vertical
                                                      ),
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),

                                            // padding: EdgeInsets.all(10),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 15.0, left: 15.0, top: 23),
                                        child: Container(
                                          height: 60.0,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[400],
                                                blurRadius:
                                                    5.0, //effect of softening the shadow
                                                spreadRadius:
                                                    0.1, //effecet of extending the shadow
                                                offset: Offset(
                                                    8.0, //horizontal
                                                    10.0 //vertical
                                                    ),
                                              ),
                                            ],
                                            color: menu[index].isAvaliable
                                                ? Colors.orange[100]
                                                : Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0, left: 15.0, top: 23),
                                          child: Container(
                                            padding: EdgeInsets.only(left: 20),
                                            height: 60.0,
                                            width: 180.0,
                                            decoration: BoxDecoration(
                                              color: menu[index].isAvaliable
                                                  ? Colors.orange[100]
                                                  : Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Marquee(
                                                        // scrollAxis: Axis.horizontal,
                                                        // textDirection:
                                                        //     TextDirection.rtl,
                                                        // animationDuration:
                                                        //     Duration(
                                                        //         seconds: 1),
                                                        backDuration: Duration(
                                                            milliseconds: 500),
                                                        // pauseDuration: Duration(
                                                        //     milliseconds: 0),
                                                        directionMarguee:
                                                            DirectionMarguee
                                                                .oneDirection,
                                                        child: Text(
                                                          menu[index].name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17.0,
                                                              color: Colors
                                                                  .grey[600]
                                                              // fontWeight: FontWeight.w700,
                                                              // fontStyle: FontStyle.italic,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        menu[index]
                                                                .price
                                                                .toDouble()
                                                                .toString() +
                                                            '0 Birr',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 17.0,
                                                          // fontWeight: FontWeight.w700,
                                                          // fontStyle: FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: menu[index].images != ''
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    child: Image.network(
                                                      menu[index]
                                                          .images
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                  )
                                                : Center(
                                                    child: Image(
                                                      height: 60,
                                                      width: 60,
                                                      image: AssetImage(
                                                          "images/Cart.png"),
                                                      color: Color(0xffe4e4e4),
                                                    ),
                                                  ),
                                            // padding: EdgeInsets.all(10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: .01,
                                );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: InkWell(
              onTap: () {
                whenAddNewItemTapped(
                    widget.categoryItems[currentPage], widget.userUid);
              },
              child: Container(
                height: 60,
                width: 60,
                child: Icon(Icons.add, color: Colors.orange[500], size: 40),
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  borderRadius: BorderRadius.circular(45.0),
                ),
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
