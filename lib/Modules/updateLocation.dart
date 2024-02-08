

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:missionujala/Modules/allUIDScreen.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/Utiles/appBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';
import '../generated/assets.dart';
import '../userProfile.dart';
import '../venderLoginScreen.dart';


class updateLocation extends StatefulWidget {
 var uIdNo;
 var uIdLat;
 var uIdLong;

 updateLocation(this.uIdNo,this.uIdLat,this.uIdLong);

  @override
  State<updateLocation> createState() => _updateLocationState(uIdNo,uIdLat,uIdLong);
}

class _updateLocationState extends State<updateLocation> {
  _updateLocationState(uIdNo,uIdLat,uIdLong);

  Completer<GoogleMapController> _controller = Completer();
  static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.439602610044293, 82.58186811379103), zoom: 20,);

  bool scroll=false;
  String userToken='';
  bool scrollLatLong=false;
  bool isLatLong=false;
  bool notShowMarker=false;
  Position? currentPosition;
  late final Uint8List? markerIcon;
  //final Set<Marker> markerr={};

  double lat= 1.1;
  double long= 1.1;
  //final LatLng cameraLocation = LatLng(26.850000, 80.94999);

  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();

  @override
  void initState()  {
    super.initState();
    getUserToken();
    getLocation();

  }

  @override
  void dispose() {
    _controller.isCompleted;
    super.dispose();
  }



  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('vendorToken')!;
    markerIcon = await getBytesFromAsset('assets/icons/markerIcon.png', 200);

    print('kkkkkkkkkkkkkkkk$lat');
    if(widget.uIdLat.toString() != 'null'){
      lat=double.parse(widget.uIdLat);
      long=double.parse(widget.uIdLong);
      latController.text='$lat';
      longController.text='$long';
      setState(() {});
    }else{
      latController.text='${await getCurrentLatitude()}';
      longController.text='${await getCurrentLongitude()}';
      setState(() {});
    }
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => allUIDScreen()), (Route<dynamic> route) => false);
        return false;
      },

      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 50,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Image.asset(Assets.iconsMenuIcon,color: appcolors.primaryColor,width: 50,height: 50,),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          title: Image.asset(Assets.imagesMuAppbarLogo,height: 50,),
          actions: [
            IconButton(
              icon: Image.asset(Assets.imagesDepartmentLogo,width: 50,height: 50,),
              onPressed: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
              },
            ),
            IconButton(
              icon: Image.asset(Assets.imagesProfileLogo,width: 50,height: 50,),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height/15),
            child: Container(
              alignment: Alignment.centerLeft,
              color: appcolors.screenBckColor,
              padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
              child: Text(allTitle.updateLocationModule,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
            ),
          ),
        ),
        drawer: drawer(),
        body: scroll ? Center(child: CircularProgressIndicator()) : Stack(
          children: [

            lat.toString() == '1.1' ? GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) async {
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(await getCurrentLatitude(), await getCurrentLongitude()), zoom: 18,)
                ));
                setState(() {});
              },
             ) : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: <Marker>[
                Marker(markerId:MarkerId('1'),
                    position: LatLng(lat, long),
                    icon: BitmapDescriptor.fromBytes(markerIcon!),
                    infoWindow: InfoWindow(
                      title: 'UID NO : ${widget.uIdNo}',
                    ))
              ].toSet(),
              onMapCreated: (GoogleMapController controller) async {
                //_controller = Completer();
                //_controller.complete(controller);
                //GoogleMapController controller = await _controller.future;
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(lat,long), zoom: 18,)
                ));
                setState(() {});
              },
            )
          ],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height/4.5,
          color: appcolors.screenBckColor,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child:Column(
            children: [

              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                    ),
                    child: TextFormField(
                      readOnly: true,
                      controller: latController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color(0xffC5C5C5), // Border color
                            width: 0.5,         // Border width
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Latitude',
                        hintStyle: TextStyle(fontSize: 12),
                      ),
                      style: TextStyle(fontSize: 12,),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                    ),
                    child: TextFormField(
                      readOnly: true,
                      controller: longController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color(0xffC5C5C5), // Border color
                            width: 0.5,         // Border width
                          ),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Longitude',
                        hintStyle: TextStyle(fontSize: 12),
                      ),
                      style: TextStyle(fontSize: 12,),
                    ),
                  ),
                  /*Container(
                    child: GestureDetector(
                        child: normalButton(name: 'Get LatLong',bckColor: Colors.orangeAccent,height: 50,width: MediaQuery.of(context).size.width*0.25,bordeRadious: 10,fontSize: 10,scroll: scrollLatLong,),
                        onTap: () async {
                          setState(() {scrollLatLong=true;});
                          double lat= await getCurrentLatitude();
                          double long=await getCurrentLongitude();
                          latController.text='$lat';
                          longController.text='$long';
                          setState(() {isLatLong=true;scrollLatLong=false;});
                        }
                    ),
                  ),*/
                ],
              ) ,
              SizedBox(height: 20,),
              InkWell(
                child: normalButton(name: 'Update Current Location',height:45,bordeRadious: 10,fontSize:14,textColor: Colors.white,bckColor: appcolors.primaryColor,),
                onTap: (){
                  updateLatlong();
                },
              ),
            ],
          ),
        ),
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



  Future<void> updateLatlong() async {
    setState(() {scroll = true;});

    String cLat='${await getCurrentLatitude()}';
    String cLong='${await getCurrentLongitude()}';


    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().updateLocationURL));
    request.fields.addAll({
      'AMCVisitLatitude': cLat.toString(),
      'AMCVisitLongitude': cLong.toString(),
      'UIDNo':'${widget.uIdNo}',
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
  }

  Future<void> getUidRefresh() async {
    setState(() {scroll = true;});

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getUidDetailesURL+'/${widget.uIdNo}'));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      toasts().greenToastShort('Current Lantlong Updated');
      lat=results['installedSystemList'][0]['latitude'];
      long=results['installedSystemList'][0]['longitude']!;

      latController.text='$lat';
      longController.text='$long';

      print('lattttttttttttttttttttttttttttt--${lat}');
      setState(() {scroll = false; });
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll = false;});
    }
  }

}
