import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class BackButtonn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Center(
                  child: Icon(FontAwesomeIcons.arrowLeft,
                      size: 25.0, color: Colors.grey[700]),
                ),
              );
  }
}