
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class inline extends StatefulWidget{
  @override
  State<inline> createState() => _inlineState();
}

class _inlineState extends State<inline> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(33.42796133580664, 73.085749655962), zoom: 14.4746,);

  final Set<Marker> markerr={};
  final Set<Polyline> pilylinee={};

  List<LatLng> latlng=[
    LatLng(33.738045, 73.084488),
    LatLng(33.7008, 72.9682),
    LatLng(33.6941, 73.9734),
  ];



  @override
  void initState() {
    super.initState();
    for(int i=0;i<latlng.length;i++)
    {
      markerr.add(
        Marker(markerId:MarkerId(i.toString()),
          position: latlng[i],
          infoWindow: InfoWindow(
              title: 'Stop id...$i',
              snippet: 'Welcome to Route'
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Routes"),
      ),
      body:GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        polylines: pilylinee,
        markers: Set<Marker>.of(markerr),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },

      ),
    );
  }
}