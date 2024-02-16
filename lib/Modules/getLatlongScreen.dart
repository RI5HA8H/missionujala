



import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class getLatlongScreen extends StatefulWidget {
  const getLatlongScreen({super.key});

  @override
  State<getLatlongScreen> createState() => _getLatlongScreenState();
}

class _getLatlongScreenState extends State<getLatlongScreen> {

  Completer<GoogleMapController> _controller = Completer();
  static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.439602610044293, 82.58186811379103), zoom: 20,);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) async {
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(await getCurrentLatitude(), await getCurrentLongitude()), zoom: 18,)
          ));
          setState(() {});
        },
      ),
    );
  }

  Future<double> getCurrentLatitude() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return double.parse(position.latitude.toStringAsFixed(8));
  }

  Future<double> getCurrentLongitude() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return double.parse(position.longitude.toStringAsFixed(8));
  }
}
