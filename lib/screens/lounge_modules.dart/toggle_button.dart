import 'dart:ui';

import 'package:agelgil_lounge_end/shared/concave_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToggleButton extends StatefulWidget {
  bool isAvaliable;
 

  ToggleButton({
    this.isAvaliable,
  });
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool toggleValue;
void methodA() {}
  @override
  Widget build(BuildContext context) {
    toggleValue = widget.isAvaliable;
    return Stack(
      children: <Widget>[
        Container(
          height: 75.0,
          width: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[600],
                blurRadius: 10.0, //effect of softening the shadow
                spreadRadius: 1.0, //effecet of extending the shadow
                offset: Offset(
                  -7.0, //horizontal
                  -7.0, //vertical
                ),
              ),
              BoxShadow(
                color: Colors.grey[100],
                blurRadius: 10.0, //effect of softening the shadow
                spreadRadius: 1.0, //effecet of extending the shadow
                offset: Offset(
                  7.0, //horizontal
                  7.0, //vertical
                ),
              ),
            ],
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 75.0,
          width: 40.0,
          decoration: BoxDecoration(
            color: toggleValue ? Colors.orange[200] : Colors.grey[350],
            borderRadius: BorderRadius.circular(13.0),
          ),
        ),
        AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: 75.0,
            width: 40.0,
            decoration: ConcaveDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                colors: [
                  Colors.white,
                  Colors.grey[600],
                  
                ],
                depression: 3.0)),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 75.0,
          width: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                right: 0.0,
                bottom: toggleValue ? 35.0 : 0.0,
                top: toggleValue ? 0.0 : 35.0,
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return RotationTransition(
                      child: child,
                      turns: animation,
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[500],
                              blurRadius:
                                  4.0, //effect of softening the shadow
                              spreadRadius:
                                  0.2, //effecet of extending the shadow
                              offset: Offset(
                                0.0, //horizontal
                                3.0, //vertical
                              ),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              toggleValue
                                  ? Colors.orange[400]
                                  : Colors.grey[400],
                              toggleValue
                                  ? Colors.orange[500]
                                  : Colors.grey[500],
                              toggleValue
                                  ? Colors.orange[900]
                                  : Colors.grey[600]
                            ],
                          ),
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                      ),
                      Container(
                        height: 75.0,
                        width: 40.0,
                        decoration: ConcaveDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            colors: [
                              toggleValue ? Colors.white : Colors.grey[200],
                              Colors.grey[600],
                            ],
                            depression: 3.0),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  toggleButton() {
    // setState(() {
    //   toggleValue = !toggleValue;
    // });
  }
}
