
import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:missionujala/Modules/updateLocation.dart';
import 'package:missionujala/Modules/viewLocationFullDetails.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/venderLoginScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shape_maker/shape_maker.dart';
import 'package:shape_maker/shape_maker_painter.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/normalButton.dart';
import '../homeScreen.dart';
import '../userProfile.dart';


class viewLocations extends StatefulWidget {
  const viewLocations({super.key});

  @override
  State<viewLocations> createState() => _viewLocationsState();
}

class _viewLocationsState extends State<viewLocations> {

  CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.850000,80.94999), zoom: 10,);

  bool scroll=false;
  bool showFilter=false;
  Position? currentPosition;
  final Set<Marker> markerr={};
  final Set<Polyline> pilylinee={};
  double lat=0.0;
  double long=0.0;
  var districtTypeItem = [];
  var blockTypeItem = [];
  var districtDropdownValue;
  var blockDropdownValue;

  List<LatLng> latlng=[
    LatLng(26.830000,80.91999),
    LatLng(26.810000,80.96999),
    LatLng(26.820000,80.98999),
  ];



  @override
  void initState()  {
    super.initState();
    getLocation();
    showMarkers();
    setState(() {});
  }

  @override
  void dispose() {
    customInfoWindowController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 40,
        title: Text(allTitle.appName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(Icons.person_pin,size: 40,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(showFilter ? MediaQuery.of(context).size.height/3 : MediaQuery.of(context).size.height/12),
          child: Container(
            color: Colors.grey[100],
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child:Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      child: normalButton(name: 'My Location',width:MediaQuery.of(context).size.width/2.5,height:40,bordeRadious: 10,fontSize:14,textColor: Colors.white,bckColor: appcolors.primaryColor,),
                      onTap: (){

                      },
                    ),
                    InkWell(
                      child: normalButton(name: 'Select Location',width:MediaQuery.of(context).size.width/2.5,height:40,bordeRadious: 10,fontSize:14,textColor: Colors.white,bckColor: appcolors.primaryColor,),
                      onTap: (){
                        setState(() {
                          showFilter=true;
                        });
                      },
                    ),
                  ],
                ),
                showFilter ? Container(
                  child: Column(
                    children: [
                      SizedBox(height: 15,),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xffC5C5C5),
                            width: 0.5,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Text('Select District',style: TextStyle(fontSize: 12,),),
                            iconStyleData: IconStyleData(
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              elevation: 1,
                              maxHeight: MediaQuery.of(context).size.height/2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[50],
                              ),
                            ),
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                            ),
                            items: districtTypeItem.map((item1) {
                              return DropdownMenuItem(
                                value: item1['id'],
                                child: Container(width: MediaQuery.of(context).size.width/2,child: Text(item1['name'],style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                              );
                            }).toList(),
                            onChanged: (newVal1) {
                              setState(() {
                                districtDropdownValue = newVal1;
                                print('llllllllll----$districtDropdownValue');
                              });
                            },
                            value: districtDropdownValue,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xffC5C5C5),
                            width: 0.5,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Text('Select Block',style: TextStyle(fontSize: 12,),),
                            iconStyleData: IconStyleData(
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(Icons.keyboard_arrow_down),
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              elevation: 1,
                              maxHeight: MediaQuery.of(context).size.height/2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[50],
                              ),
                            ),
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                              ),
                            ),
                            items: blockTypeItem.map((item1) {
                              return DropdownMenuItem(
                                value: item1['id'],
                                child: Container(width: MediaQuery.of(context).size.width/2,child: Text(item1['name'],style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                              );
                            }).toList(),
                            onChanged: (newVal1) {
                              setState(() {
                                blockDropdownValue = newVal1;
                                print('llllllllll----$blockDropdownValue');
                              });
                            },
                            value: blockDropdownValue,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        child: normalButton(name: 'Search',height:45,bordeRadious: 20,fontSize:14,textColor: Colors.black,bckColor: appcolors.primaryTextColor,),
                        onTap: (){
                          setState(() {
                            showFilter=false;
                          });
                        },
                      ),
                    ],
                  ),
                ) : Container(),

              ],
            ),
          ),
        ),
      ),
      drawer: drawer(),
      body:Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(markerr),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              customInfoWindowController.googleMapController = controller;
            },
            onTap: (position) {
              customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              customInfoWindowController.onCameraMove!();
            },
          ),
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 135,
            width: 200,
            offset: 50,
          ),
        ],
      ),
    );
  }



  Future<void> getLocation() async {
    var status = await Permission.location.request();

    if (status == PermissionStatus.granted) {
      // Permission granted, get the current location
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          currentPosition = position;
        });
      } catch (e) {
        showPermissionDeniedDialog();
      }
    } else if (status == PermissionStatus.denied) {
      showPermissionDeniedDialog();
    }
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => venderLoginScreen()), (Route<dynamic> route) => false);
          return false;
        },
        child: AlertDialog(
          title: Text('Location Permission Denied',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
          content: Text('Please enable location services. The feature will not be accessible otherwise.',style: TextStyle(fontSize: 12,color: Colors.black),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => venderLoginScreen()), (Route<dynamic> route) => false);
              },
              child: Text('OK',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
            ),
          ],
        ),
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

  showMarkers(){
    for(int i=0;i<latlng.length;i++)
    {
      markerr.add(
        Marker(markerId:MarkerId(i.toString()),
          position: latlng[i],
          onTap: () {
            customInfoWindowController.addInfoWindow!(
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  width: 300,
                  height: 490,
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text('UID-1074',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                      SizedBox(height: 5,),
                      Text('In this video i will teach you how we can can multiple marker, once marker is added then how we can add marker custom info window.',style: TextStyle(fontSize: 10,),),
                      SizedBox(height: 8,),
                      InkWell(
                        child: normalButton(name: 'View Details',height:25,bordeRadious: 10,fontSize:10,textColor: Colors.black,bckColor: appcolors.primaryTextColor,),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocationFullDetails(
                            '',
                            '',
                            '',
                            '',
                            '',
                            '',
                            '',

                            '',
                            '',
                            '',
                            '',
                            '',
                            '',
                            '',
                            '',
                            '',
                          )));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              latlng[i],
            );
          },
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }
  }


  /*Future<void> getRadiousLatlong() async {
    setState(() {scroll = true;});

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().getRadiousLocationURL));
    request.fields.addAll({
      'AMCVisitLatitude': latController.text.toString(),
      'AMCVisitLongitude': longController.text.toString(),
    });
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      getUidRefresh();
      //setState(() {scroll = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll = false;});
    }
  }*/
}
