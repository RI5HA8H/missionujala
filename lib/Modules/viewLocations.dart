
import 'dart:async';
import 'dart:convert';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
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
import 'package:shared_preferences/shared_preferences.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/bottomNavigationBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';
import '../generated/assets.dart';
import '../homeScreen.dart';
import '../userProfile.dart';
import 'complainScreen.dart';


class viewLocations extends StatefulWidget {
  const viewLocations({super.key});

  @override
  State<viewLocations> createState() => _viewLocationsState();
}

class _viewLocationsState extends State<viewLocations> {

  CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();

  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.850000,80.94999), zoom: 10,);

  String userToken='';
  bool scroll=false;
  bool showFilter=false;
  Position? currentPosition;
  final Set<Marker> markerr={};
  var allApiMarker=[];
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
    getUserToken();
    setState(() {});
  }

  @override
  void dispose() {
    markerr.clear();
    customInfoWindowController.dispose();
    super.dispose();
  }

  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('vendorToken')!;
    double latitude=await getCurrentLatitude();
    double longitude=await getCurrentLongitude();
    getRadiousLatlong(latitude,longitude);
    getDistrict();
    getBlock();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(10),
            color: appcolors.screenBckColor,
            child: Text(allTitle.viewLocationModule,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
          ),
        ),
      ),
      drawer: drawer(),
      body:scroll ? Center(child: CircularProgressIndicator()) : Stack(
        children: [
          GoogleMap(
            mapType: MapType.none,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(markerr),
            onMapCreated: (GoogleMapController controller) {
              //_controller.complete(controller);
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: LatLng(lat,long), zoom: 15,)
              ));
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
            height: 150,
            width: 250,
            offset: 50,
          ),
          Positioned(
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
                        onTap: () async {
                          double latitude=await getCurrentLatitude();
                          double longitude=await getCurrentLongitude();
                          getRadiousLatlong(latitude,longitude);
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
                                  value: item1['districtKey'],
                                  child: Container(width: MediaQuery.of(context).size.width/2,child: Text(item1['districtName'],style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
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
                                  value: item1['blockKey'],
                                  child: Container(width: MediaQuery.of(context).size.width/2,child: Text(item1['blockName'],style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
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
                            setState(() async {
                              showFilter=false;
                              double latitude=await getCurrentLatitude();
                              double longitude=await getCurrentLongitude();
                              getRadiousLatlong(latitude,longitude);
                            });
                          },
                        ),
                      ],
                    ),
                  ) : Container(),

                ],
              ),
            )
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar(0),
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

  showMarkers() async {
    final Uint8List? markerIcon = await getBytesFromAsset('assets/icons/markerIcon.png', 150);

    for(int i=0;i<allApiMarker.length;i++)
    {
      print('ggggggg${i}');
      markerr.add(
        Marker(markerId:MarkerId(i.toString()),
          position: LatLng(double.parse('${allApiMarker[i]['installedSystemList'][0]['latitude']}'),double.parse('${allApiMarker[i]['installedSystemList'][0]['longitude']}')),
          onTap: () {
          print('${allApiMarker[i]['installedSystemList'][0]['latitude']}');
            customInfoWindowController.addInfoWindow!(
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Scaffold(
                    body: Container(
                      width: 300,
                      height: 460,
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
                                child: Image.network('${allApiMarker[i]['installedSystemList'][0]['photoPath']}',width: 60,height: 60,fit: BoxFit.fill,),
                              ),
                              SizedBox(width: 5,),
                              Container(
                                width: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('UID-${allApiMarker[i]['installedSystemList'][0]['uidNo']}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
                                    SizedBox(height: 2,),
                                    Text('${allApiMarker[i]['installedSystemList'][0]['latitude']},${allApiMarker[i]['installedSystemList'][0]['longitude']}',style: TextStyle(fontSize: 12,),),
                                    SizedBox(height: 2,),
                                    Text('${allApiMarker[i]['installedSystemList'][0]['villageName']}, ${allApiMarker[i]['installedSystemList'][0]['blockName']}, ${allApiMarker[i]['installedSystemList'][0]['districtName']}',style: TextStyle(fontSize: 10,),),

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
                        child: normalButton(name: 'View Details',height:35,width: 100,bordeRadious: 10,fontSize:10,textColor: Colors.black,bckColor: appcolors.primaryTextColor,),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocationFullDetails(
                            '${allApiMarker[i]['installedSystemList'][0]['uidKey']}',
                            '${allApiMarker[i]['installedSystemList'][0]['uidNo']}',
                            '${allApiMarker[i]['installedSystemList'][0]['mobileNo']}',
                            '${allApiMarker[i]['installedSystemList'][0]['villageName']}',
                            '${allApiMarker[i]['installedSystemList'][0]['placeName']}',
                            '${allApiMarker[i]['installedSystemList'][0]['blockName']}',
                            '${allApiMarker[i]['installedSystemList'][0]['districtName']}',
                            '${allApiMarker[i]['installedSystemList'][0]['installationDate']}',

                            '${allApiMarker[i]['installedSystemList'][0]['status']}',
                            '${allApiMarker[i]['installedSystemList'][0]['beneficiaryName']}',
                            '${allApiMarker[i]['installedSystemList'][0]['fatherName']}',
                            '${allApiMarker[i]['installedSystemList'][0]['gramPanchayat']}',
                            '${allApiMarker[i]['installedSystemList'][0]['latitude']}',
                            '${allApiMarker[i]['installedSystemList'][0]['longitude']}',
                            '${allApiMarker[i]['installedSystemList'][0]['photoPath']}',
                            '${allApiMarker[i]['installedSystemList'][0]['formatPath1']}',
                          )));
                        },
                      ),
                    ),
                  ),
                ),
              LatLng(double.parse('${allApiMarker[i]['installedSystemList'][0]['latitude']}'),double.parse('${allApiMarker[i]['installedSystemList'][0]['longitude']}')),
            );
          },
          icon: BitmapDescriptor.fromBytes(markerIcon!),
        ),
      );
    }
    setState(() {

    });
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }


  Future<void> getRadiousLatlong(double lati,double longi) async {
    setState(() {scroll = true;});
    lat=lati;
    long=longi;
    markerr.clear();

    var headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJSRVNJTVNTZXJ2aWNlQWNjZXNzVG9rZW4iLCJqdGkiOiJkMTdhZmMyNi04NGM3LTQyMjgtOTg5OS1iMDE4NDRhZTY1N2UiLCJpYXQiOiIwNi0wMi0yMDI0IDExOjIwOjUzIiwiZXhwIjoxNzA3ODIzMjUzLCJpc3MiOiJSRVNJTVNBdXRoZW50aWNhdGlvblNlcnZlciIsImF1ZCI6IlJFU0lNU1NlcnZpY2VQb3N0bWFuQ2xpZW50In0.s19hJH90K9Z8h9wpLOIb9KyRoXzQsn27MDmo92i_bhw'
    };
    print(await 'aaaaaaaaa-----${urls().base_url + allAPI().getRadiousLocationURL}');
    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().getRadiousLocationURL));
    request.fields.addAll({
      'AMCVisitLatitude': '$lati',//26.822184
      'AMCVisitLongitude': '$longi',//80.663987
    });
    request.headers.addAll(headers);
    //var response = await request.send();
    http.StreamedResponse response = await request.send();
    print(await 'ffffffffffffffff-----${response}');
    var results = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      print(await 'ffffffffffffffff-----${results}');
      allApiMarker=results;
      showMarkers();
      setState(() {scroll = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll = false;});
    }
  }

  Future<void> getDistrict() async {
    setState(() {scroll = true;});

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().disctrictURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      districtTypeItem=results;
      setState(() {scroll = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll = false;});
    }
  }


  Future<void> getBlock() async {
    setState(() {scroll = true;});

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().blockURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      blockTypeItem=results;
      setState(() {scroll = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll = false;});
    }
  }

}
