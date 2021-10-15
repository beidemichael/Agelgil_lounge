import 'package:agelgil_lounge_end/screens/lounge_modules.dart/setting/radiusMap/radiusMapWidgets/back_button.dart';
import 'package:agelgil_lounge_end/screens/lounge_modules.dart/setting/radiusMap/radiusMapWidgets/radius_input.dart';
import 'package:agelgil_lounge_end/services/database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RadiusMap extends StatefulWidget {
  String documentId;
  double radius;
  double latitude;
  double longitude;
  RadiusMap({this.radius, this.latitude, this.longitude, this.documentId});
  @override
  _RadiusMapState createState() => _RadiusMapState();
}

class _RadiusMapState extends State<RadiusMap> {
  
  GoogleMapController _controller;
  static LatLng _initialPosition;
  Map<MarkerId, Marker> loungeMarkers = <MarkerId, Marker>{};
  Map<MarkerId, Circle> circleA = <MarkerId, Circle>{};
  double zoomLevel;
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialPosition = LatLng(widget.latitude, widget.longitude);
  
  }

  getZoomLevel() {
    double zoomLevel = 11;

    double radius = widget.radius + widget.radius / 2;
    double scale = radius / 500;

    zoomLevel = (16 - log(scale) / log(2));

    return zoomLevel;
  }

  void updateZoom() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        bearing: 0,
        target: LatLng(widget.latitude, widget.longitude),
        tilt: 0,
        zoom: getZoomLevel())));

    circleA[MarkerId('a')] = Circle(
        circleId: CircleId("A"),
        center: LatLng(widget.latitude, widget.longitude),
        radius: widget.radius,
        fillColor: Colors.orange.withOpacity(0.5),
        strokeColor: Colors.orange[200].withOpacity(0.5),
        strokeWidth: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,

            tiltGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
              tilt: 0,
              bearing: 0,
              target: _initialPosition,
              zoom: getZoomLevel(),
            ),
            markers: Set<Marker>.of(loungeMarkers.values),
            circles: Set<Circle>.of(circleA.values),
            // _markers,
            compassEnabled: false,
            // onCameraMove: _onCameraMove,
            zoomControlsEnabled: false,

            // rotateGesturesEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;

              setState(() {
                loungeMarkers[MarkerId('me')] = Marker(
                  markerId: MarkerId('me'),
                  position: _initialPosition,
                );

                circleA[MarkerId('a')] = Circle(
                    circleId: CircleId("A"),
                    center: LatLng(widget.latitude, widget.longitude),
                    radius: widget.radius,
                    fillColor: Colors.orange.withOpacity(0.5),
                    strokeColor: Colors.orange[200].withOpacity(0.5),
                    strokeWidth: 10);
              });
            },
          ),
          Positioned(
            top: 40,
            left: 20,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: BackButtonn()
            ),
          ),
          Positioned(
            bottom: -40,
            right: 0,
            left: 0,
            child: RadiusInput(newRadius: widget.radius,updateZoom: updateZoom,documentId: widget.documentId,)
          )
        ],
      ),
    );
  }
}
