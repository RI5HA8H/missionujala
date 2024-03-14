

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
import 'package:intl/intl.dart';
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
import '../loginDashboard.dart';
import '../userProfile.dart';
import '../venderLoginScreen.dart';


class updateLocation extends StatefulWidget {
  var uIdNo;
  var uIdLat;
  var uIdLong;

  var uIdPlace;
  var uIdVillage;
  var uIdBlock;
  var uIdDist;
  var uIdLVTill;
  var uIdPhotoPath;


  updateLocation(this.uIdNo,this.uIdLat,this.uIdLong,this.uIdPlace,this.uIdVillage,this.uIdBlock,this.uIdDist,this.uIdLVTill,this.uIdPhotoPath);

  @override
  State<updateLocation> createState() => _updateLocationState(uIdNo,uIdLat,uIdLong,uIdPlace,uIdVillage,uIdBlock,uIdDist,uIdLVTill,uIdPhotoPath);
}

class _updateLocationState extends State<updateLocation> {
  _updateLocationState(uIdNo,uIdLat,uIdLong,uIdPlace,uIdVillage,uIdBlock,uIdDist,uIdLVTill,uIdPhotoPath);

  CustomInfoWindowController customInfoWindowController2 = CustomInfoWindowController();

  Completer<GoogleMapController> _controller = Completer();
  static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.439602610044293, 82.58186811379103), zoom: 20,);

  bool scroll=false;
  bool buttonView=false;
  bool latlonfUpdated=false;
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
    customInfoWindowController2.dispose();
    super.dispose();
  }



  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('vendorToken')!;
    markerIcon = await getBytesFromAsset(Assets.iconsMarkerIconNew, 100);

    debugPrint('kkkkkkkkkkkkkkkk$lat');
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
        Navigator.pop(context);
        Navigator.pop(context,latlonfUpdated);
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
              onTap: (position) {
                buttonView=true;
                lat= position.latitude;
                long= position.longitude;
                debugPrint('${lat}, ${long}');
                setState(() {});
                customInfoWindowController2.hideInfoWindow!();
              },
              myLocationEnabled: true, // Enable showing the user's location
              myLocationButtonEnabled: true, // Enable the "My Location" button
            ) : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              markers: <Marker>[
                Marker(markerId:MarkerId('1'),
                  position: LatLng(lat, long),
                  icon: BitmapDescriptor.fromBytes(markerIcon!),
                  onTap: () {
                    customInfoWindowController2.addInfoWindow!(
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Scaffold(
                          body: Container(
                            width: 350,
                            height: 480,
                            color: Colors.white,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 60,
                                      color: Colors.grey[200],
                                      child: Image.network('${widget.uIdPhotoPath}',width: 60,height: 80,fit: BoxFit.fill,),
                                    ),
                                    SizedBox(width: 5,),
                                    Container(
                                      width: 190,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('UID No.: ${widget.uIdNo}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                                          SizedBox(height: 2,),
                                          Text('${widget.uIdPlace}, ${widget.uIdVillage}, ${widget.uIdBlock}, ${widget.uIdDist}',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 4,overflow: TextOverflow.ellipsis,),
                                          SizedBox(height: 5,),
                                          Text('Service Valid till: ${convertDateFormat(widget.uIdLVTill)}',style: TextStyle(fontSize: 12,color: Colors.black,),),
                                          SizedBox(height: 2,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                          bottomNavigationBar: Padding(
                            padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                            child: InkWell(
                              child: normalButton(name: 'SHOW MORE',height:35,width: 100,bordeRadious: 10,fontSize:10,textColor: Colors.white,bckColor: appcolors.greenTextColor,),
                              onTap: () async {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                      LatLng(double.parse('${lat}'),double.parse('${long}')),
                    );
                  },
                )
              ].toSet(),
              onMapCreated: (GoogleMapController controller) async {
                //_controller = Completer();
                //_controller.complete(controller);
                //GoogleMapController controller = await _controller.future;
                controller.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: LatLng(lat,long), zoom: 18,)
                ));
                customInfoWindowController2.googleMapController = controller;
                setState(() {});
              },
              onTap: (position) {
                buttonView=true;
                lat= position.latitude;
                long= position.longitude;
                debugPrint('${lat}, ${long}');
                setState(() {});
                customInfoWindowController2.hideInfoWindow!();
              },
              onCameraMove: (position) {
                customInfoWindowController2.onCameraMove!();
              },
              myLocationEnabled: true, // Enable showing the user's location
              myLocationButtonEnabled: true, // Enable the "My Location" button
            ),
            CustomInfoWindow(
              controller: customInfoWindowController2,
              height: 180,
              width: 280,
              offset: 50,
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height/6,
          color: appcolors.screenBckColor,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child:Column(
            children: [
              Text('कृपया map पर touch कर light/system की location चिंहित करें',style: TextStyle(fontSize: 14,color: Colors.black),),
              SizedBox(height: 10,),
              InkWell(
                child: normalButton(name: 'Save',height:40,bordeRadious: 10,fontSize:14,textColor: Colors.white,bckColor: buttonView ? appcolors.primaryColor : Colors.grey,),
                onTap: (){
                  if(buttonView){
                    updateLatlong();
                  }else{
                    toasts().redToastLong('Please Select Location');
                  }

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
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => loginDashboard()), (Route<dynamic> route) => false);
          return false;
        },
        child: AlertDialog(
          title: Text('Location Permission Denied',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
          content: Text('Please enable location services. The feature will not be accessible otherwise.',style: TextStyle(fontSize: 12,color: Colors.black),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => loginDashboard()), (Route<dynamic> route) => false);
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

  String convertDateFormat(String inputDate) {
    // Parse the input date
    DateTime dateTime = DateFormat("dd-MM-yyyy").parse(inputDate);

    // Format the date in the desired format
    String formattedDate = DateFormat("dd-MMM-yy").format(dateTime);

    return formattedDate;
  }




  Future<void> updateLatlong() async {
    setState(() {scroll = true;});

   // String cLat='${await getCurrentLatitude()}';
  //  String cLong='${await getCurrentLongitude()}';


    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().updateLocationURL));
    request.fields.addAll({
      'AMCVisitLatitude': lat.toString(),
      'AMCVisitLongitude': long.toString(),
      'UIDNo':'${widget.uIdNo}',
    });
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      latlonfUpdated=true;
      debugPrint(await 'aaaaaaaaa-----${results}');
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
      debugPrint(await 'aaaaaaaaa-----${results}');
      toasts().greenToastShort('Geo coordinates updated successfully');
      lat=results['installedSystemList'][0]['latitude'];
      long=results['installedSystemList'][0]['longitude']!;

      latController.text='$lat';
      longController.text='$long';

      debugPrint('lattttttttttttttttttttttttttttt--${lat}');
      setState(() {scroll = false; });
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll = false;});
    }
  }

}
