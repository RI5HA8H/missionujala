
import 'dart:async';
import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:missionujala/Modules/updateLocation.dart';
import 'package:missionujala/Modules/viewLocationFullDetails.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/userLoginScreen.dart';
import 'package:missionujala/venderLoginScreen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shape_maker/shape_maker.dart';
import 'package:shape_maker/shape_maker_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/bottomNavigationBar.dart';
import '../Resource/Utiles/checkInternet.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/nProgressDialog.dart';
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
  static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.439602610044293, 82.58186811379103), zoom: 20,);

  late ProgressDialog progressDialog1;
  late ProgressDialog progressDialog2;
  late ProgressDialog progressDialog3;
  late ProgressDialog progressDialog4;
  String userToken='';
  String companyKey='';
  bool scroll1=true;
  bool scroll2=true;
  bool showFilter=false;
  bool showFilterButtonColor=false;
  Position? currentPosition;
  final Set<Marker> markerr={};
  var allApiMarker=[];
  double lat= 26.830000;
  double long= 80.91999;
  var districtTypeItem = [];
  var allServiceCenterItem = [];
  var districtDropdownValue;

  List<LatLng> latlng=[
    LatLng(26.830000,80.91999),
    LatLng(26.810000,80.96999),
    LatLng(26.820000,80.98999),
  ];




  @override
  void initState(){
    super.initState();
    getLocation();
    getUserToken();
  }

  @override
  void dispose() {
    markerr.clear();
    customInfoWindowController.dispose();
    super.dispose();
  }

  getUserToken() async {
    getDistrict();
    //getServiceCenterList();
    double latitude=await getCurrentLatitude();
    double longitude=await getCurrentLongitude();
    getRadiousLatlong(latitude,longitude);
  }




  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            preferredSize: Size.fromHeight(showFilterButtonColor ? MediaQuery.of(context).size.height/3.6 : MediaQuery.of(context).size.height/5.5),
            child: Container(
              //padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child:Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                             showFilter ? Container() : RotatedBox(
                                quarterTurns: 2,
                                child: ShapeMaker(
                                  width: 100,
                                  height: 42,
                                  shapeType: ShapeType.triangle,
                                  bgColor: appcolors.greenTextColor,
                                ),
                              ),
                              Positioned(
                                child: InkWell(
                                  child: normalButton(name: 'Near by',width:MediaQuery.of(context).size.width/2.5,height:35,bordeRadious: 5,fontSize:14,textColor: showFilter ? Colors.black : Colors.white,bckColor: showFilter ? appcolors.whiteColor : appcolors.greenTextColor,),
                                  onTap: () async {
                                    districtDropdownValue=null;
                                    setState(() {showFilter=false;showFilterButtonColor=false;});
                                    double latitude=await getCurrentLatitude();
                                    double longitude=await getCurrentLongitude();
                                    getRadiousLatlong(latitude,longitude);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              showFilter ? RotatedBox(
                                quarterTurns: 2,
                                child: ShapeMaker(
                                  width: 100,
                                  height: 42,
                                  shapeType: ShapeType.triangle,
                                  bgColor: appcolors.greenTextColor,
                                ),
                              ) : Container(),
                              Positioned(
                                child: InkWell(
                                  child: normalButton(name: 'Choose Location',width:MediaQuery.of(context).size.width/2.5,height:35,bordeRadious: 5,fontSize:14,textColor: showFilter ? Colors.white : Colors.black,bckColor: showFilter ? appcolors.greenTextColor : Colors.white,),
                                  onTap: (){
                                    setState(() {showFilter=true;showFilterButtonColor=true;});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  showFilterButtonColor ? ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Column(
                        children: [
                          SizedBox(height: 5,),
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
                                menuItemStyleData: MenuItemStyleData(
                                  height: 30,
                                ),
                                items: districtTypeItem.map((item11) {
                                  return DropdownMenuItem(
                                    value: item11['districtKey'],
                                    child: Container(width: MediaQuery.of(context).size.width/2,child: Text(item11['districtName'],style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                  );
                                }).toList(),
                                onChanged: (newVal11) {
                                  setState(() {
                                    districtDropdownValue = newVal11;
                                    print('llllllllll----$districtDropdownValue');
                                    setState(() {showFilterButtonColor=false;});
                                    getUidByDistrictBlock();
                                  });
                                },
                                value: districtDropdownValue,
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                         /* Container(
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
                                hint: Text('Select Area',style: TextStyle(fontSize: 12,),),
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
                                menuItemStyleData: MenuItemStyleData(
                                  height: 30,
                                ),
                                items: blockTypeItem.map((item12) {
                                  return DropdownMenuItem(
                                    value: item12['blockKey'],
                                    child: Container(width: MediaQuery.of(context).size.width/2,child: Text(item12['blockName'],style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                  );
                                }).toList(),
                                onChanged: (newVal12) {
                                  setState(() {
                                    blockDropdownValue = newVal12;
                                    print('llllllllll----$blockDropdownValue');
                                  });
                                },
                                value: blockDropdownValue,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            child: normalButton(name: 'Search',height:45,bordeRadious: 25,fontSize:14,textColor: Colors.white,bckColor: appcolors.greenTextColor,),
                            onTap: () async {
                              if(districtDropdownValue==null || blockDropdownValue==null){
                                toasts().redToastShort('Proper fill the details');
                              }else{
                                setState(() {showFilterButtonColor=false;});
                                lat= 26.830000;
                                long= 80.91999;
                                getUidByDistrictBlock();
                              }
                            },
                          ),*/
                        ],
                      ),
                    ),
                  ) : Container(),
                  SizedBox(height: 5,),
                  Container(
                    color: appcolors.whiteColor,
                    child: TabBar(
                      labelColor: appcolors.primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),
                      tabs: [
                        Tab(text: 'View Map'),
                        Tab(text: 'View List'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: drawer(),
        body:scroll1 || scroll2 ? Center(child: CircularProgressIndicator()) : TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  markers: Set<Marker>.of(markerr),
                  onMapCreated: (GoogleMapController controller) {
                    //_controller.complete(controller);
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: LatLng(lat,long), zoom: 12,)
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
                  height: 180,
                  width: 280,
                  offset: 50,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: ListView.builder(
                  itemCount: allApiMarker[0]['installedSystemList'].length,
                  itemBuilder: (BuildContext context, int index) => getRow(index, context)
              ),
            ),
          ],
        ),
        //bottomNavigationBar: bottomNavigationBar(0),
      ),
    );
  }


  Widget getRow(int index,var snapshot) {
    return  Container(
      padding: EdgeInsets.fromLTRB(10,0,10,5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: allApiMarker[0]['installedSystemList'][index]['isCorrect_LatLong']==true ? Colors.green[100] : Colors.grey[100],
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                child: ListTile(
                  title: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text('UID No.: ${allApiMarker[0]['installedSystemList'][index]['uidNo']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
                          Text('Installation Date : ${allApiMarker[0]['installedSystemList'][index]['installationDate']}',style: TextStyle(fontSize: 14,color: Colors.black)),
                          Text('${allApiMarker[0]['installedSystemList'][index]['placeName']},${allApiMarker[0]['installedSystemList'][index]['villageName']}',style: TextStyle(fontSize: 12,color: Colors.black)),

                        ],
                      )
                  ),
                  onTap: () async {
                    bool updateUid= false;
                    updateUid=await Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocationFullDetails(
                      allApiMarker[0]['installedSystemList'][index]['uidKey'],
                      allApiMarker[0]['installedSystemList'][index]['uidNo'],
                      allApiMarker[0]['installedSystemList'][index]['mobileNo'],
                      allApiMarker[0]['installedSystemList'][index]['villageName'],
                      allApiMarker[0]['installedSystemList'][index]['placeName'],
                      allApiMarker[0]['installedSystemList'][index]['blockName'],
                      allApiMarker[0]['installedSystemList'][index]['districtName'],
                      allApiMarker[0]['installedSystemList'][index]['installationDate'],

                      allApiMarker[0]['installedSystemList'][index]['status'],
                      allApiMarker[0]['installedSystemList'][index]['beneficiaryName'],
                      allApiMarker[0]['installedSystemList'][index]['fatherName'],
                      allApiMarker[0]['installedSystemList'][index]['gramPanchayat'],
                      allApiMarker[0]['installedSystemList'][index]['latitude'],
                      allApiMarker[0]['installedSystemList'][index]['longitude'],
                      allApiMarker[0]['installedSystemList'][index]['photoPath'],
                      allApiMarker[0]['installedSystemList'][index]['formatPath1'],
                      allApiMarker[0]['installedSystemList'][index]['formatPath1Extn'],
                      allApiMarker[0]['installedSystemList'][index]['schemeName'],
                      allApiMarker[0]['installedSystemList'][index]['serviceValidTill'],
                    )));
                    print('uuuuuuuuuuuuuuu-->$updateUid');

                    if(updateUid == true){
                      if(districtDropdownValue!=null){
                        getUidByDistrictBlock();
                      }else{
                        double latitude=await getCurrentLatitude();
                        double longitude=await getCurrentLongitude();
                        getRadiousLatlong(latitude,longitude);
                      }
                    }

                  },
                ),
              ),
              Positioned(
                child: '${allApiMarker[0]['installedSystemList'][index]['latitude']}' == 'null' ? Container() : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/icons/isMapMarker.png',width: 20,height: 20,),
                ),
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
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => userLoginScreen()), (Route<dynamic> route) => false);
          return false;
        },
        child: AlertDialog(
          title: Text('Location Permission Denied',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
          content: Text('Please enable location services. The feature will not be accessible otherwise.',style: TextStyle(fontSize: 12,color: Colors.black),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => userLoginScreen()), (Route<dynamic> route) => false);
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
    //final Uint8List? scmarkerIcon = await getBytesFromAsset('assets/icons/serviceCenterMarkerIcon.png', 150);

    for(int i=0;i<allApiMarker[0]['installedSystemList'].length;i++)
    {
      print('ggggggg${i}');
      if(allApiMarker[0]['installedSystemList'][i]['latitude'].toString()!='null'){
        print('hhhhhhhh${i}');
        lat=double.parse('${allApiMarker[0]['installedSystemList'][i]['latitude']}');
        long=double.parse('${allApiMarker[0]['installedSystemList'][i]['longitude']}');
        markerr.add(
          Marker(markerId:MarkerId(i.toString()),
            position: LatLng(double.parse('${allApiMarker[0]['installedSystemList'][i]['latitude']}'),double.parse('${allApiMarker[0]['installedSystemList'][i]['longitude']}')),
            onTap: () {
              print('${allApiMarker[0]['installedSystemList'][i]['latitude']}');
              customInfoWindowController.addInfoWindow!(
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
                                child: Image.network('${allApiMarker[0]['installedSystemList'][i]['photoPath']}',width: 60,height: 80,fit: BoxFit.fill,),
                              ),
                              SizedBox(width: 5,),
                              Container(
                                width: 190,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('UID No.: ${allApiMarker[0]['installedSystemList'][i]['uidNo']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                                    SizedBox(height: 2,),
                                    Text('${allApiMarker[0]['installedSystemList'][i]['placeName']}, ${allApiMarker[0]['installedSystemList'][i]['villageName']}, ${allApiMarker[0]['installedSystemList'][i]['blockName']}, ${allApiMarker[0]['installedSystemList'][i]['districtName']}',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 4,overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 5,),
                                    Text('Service Valid till: ${convertDateFormat(allApiMarker[0]['installedSystemList'][i]['serviceValidTill'])}',style: TextStyle(fontSize: 12,color: Colors.black,),),
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
                          bool updateUid= false;
                          updateUid=await Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocationFullDetails(
                            '${allApiMarker[0]['installedSystemList'][i]['uidKey']}',
                            '${allApiMarker[0]['installedSystemList'][i]['uidNo']}',
                            '${allApiMarker[0]['installedSystemList'][i]['mobileNo']}',
                            '${allApiMarker[0]['installedSystemList'][i]['villageName']}',
                            '${allApiMarker[0]['installedSystemList'][i]['placeName']}',
                            '${allApiMarker[0]['installedSystemList'][i]['blockName']}',
                            '${allApiMarker[0]['installedSystemList'][i]['districtName']}',
                            '${allApiMarker[0]['installedSystemList'][i]['installationDate']}',

                            '${allApiMarker[0]['installedSystemList'][i]['status']}',
                            '${allApiMarker[0]['installedSystemList'][i]['beneficiaryName']}',
                            '${allApiMarker[0]['installedSystemList'][i]['fatherName']}',
                            '${allApiMarker[0]['installedSystemList'][i]['gramPanchayat']}',
                            '${allApiMarker[0]['installedSystemList'][i]['latitude']}',
                            '${allApiMarker[0]['installedSystemList'][i]['longitude']}',
                            '${allApiMarker[0]['installedSystemList'][i]['photoPath']}',
                            '${allApiMarker[0]['installedSystemList'][i]['formatPath1']}',
                            '${allApiMarker[0]['installedSystemList'][i]['formatPath1Extn']}',
                            '${allApiMarker[0]['installedSystemList'][i]['schemeName']}',
                            '${allApiMarker[0]['installedSystemList'][i]['serviceValidTill']}',
                          )));
                          print('uuuuuuuuuuuuuuu-->$updateUid');

                          if(updateUid == true){
                            if(districtDropdownValue!=null){
                              getUidByDistrictBlock();
                            }else{
                              double latitude=await getCurrentLatitude();
                              double longitude=await getCurrentLongitude();
                              getRadiousLatlong(latitude,longitude);
                            }
                          }

                        },
                      ),
                    ),
                  ),
                ),
                LatLng(double.parse('${allApiMarker[0]['installedSystemList'][i]['latitude']}'),double.parse('${allApiMarker[0]['installedSystemList'][i]['longitude']}')),
              );
            },
            icon: BitmapDescriptor.fromBytes(markerIcon!),
          ),
        );
      }
    }

    /*for(int i=0;i<allServiceCenterItem.length;i++)
    {
      print('ssssssssss${i}');
      if(allServiceCenterItem[i]['latitude'].toString()!='null'){
        print('hhhhhhhh${i}');
        //lat=double.parse('${allServiceCenterItem[i]['latitude']}');
        //long=double.parse('${allServiceCenterItem[i]['longitude']}');
        markerr.add(
          Marker(markerId:MarkerId(i.toString()),
            position: LatLng(double.parse('${allServiceCenterItem[i]['latitude']}'),double.parse('${allServiceCenterItem[i]['longitude']}')),
            onTap: () {
              print('${allServiceCenterItem[i]['latitude']}');
              customInfoWindowController.addInfoWindow!(
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
                                child: Image.network('https://i.pinimg.com/736x/44/27/2d/44272df32b1b832c9ea8f596fb4d76b2.jpg',width: 60,height: 60,fit: BoxFit.fill,),
                              ),
                              SizedBox(width: 5,),
                              Container(
                                width: 190,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${allServiceCenterItem[i]['scName']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                                    SizedBox(height: 2,),
                                    Text('${allServiceCenterItem[i]['districtName']}',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 4,overflow: TextOverflow.ellipsis,),
                                    SizedBox(height: 5,),
                                    Text('${allServiceCenterItem[i]['scContactNo']}',style: TextStyle(fontSize: 12,color: Colors.black,),),
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
                        child: normalButton(name: 'Call Now',height:35,width: 100,bordeRadious: 10,fontSize:10,textColor: Colors.white,bckColor: appcolors.greenTextColor,),
                        onTap: () async {
                          final call = Uri.parse('tel:+91 ${allServiceCenterItem[i]['scContactNo']}');
                          if (await canLaunchUrl(call)) {
                            launchUrl(call);
                          } else {
                            throw 'Could not launch $call';
                          }
                        },
                      ),
                    ),
                  ),
                ),
                LatLng(double.parse('${allServiceCenterItem[i]['latitude']}'),double.parse('${allServiceCenterItem[i]['longitude']}')),
              );
            },
            icon: BitmapDescriptor.fromBytes(scmarkerIcon!),
          ),
        );
      }
    }*/
    setState(() {});
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }

  String convertDateFormat(String inputDate) {
    // Parse the input date
    DateTime dateTime = DateFormat("dd-MM-yyyy").parse(inputDate);

    // Format the date in the desired format
    String formattedDate = DateFormat("dd-MMM-yy").format(dateTime);

    return formattedDate;
  }


  Future<void> getRadiousLatlong(double lati,double longi) async {
    setState(() {scroll1=true;});
    lat=lati;
    long=longi;
    markerr.clear();

    print(await 'aaaaaaaaa-----${urls().base_url + allAPI().getRadiousLocationURL}');
    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().getRadiousLocationURL));
    request.fields.addAll({
      'AMCVisitLatitude': '$lati',//26.822184
      'AMCVisitLongitude': '$longi',//80.663987
    });
    //var response = await request.send();
    http.StreamedResponse response = await request.send();
    print(await 'ffffffffffffffff-----${response}');
    var results = jsonDecode(await response.stream.bytesToString());
    if (response.statusCode == 200) {
      print(await 'ffffffffffffffff-----${results}');
      allApiMarker=results;
      print('llllllllll--->${results.length}');
      showMarkers();
      setState(() {scroll1=false;});

    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll1=false;});
    }
  }

  Future<void> getDistrict() async {
    setState(() {scroll2=true;});

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().disctrictURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      districtTypeItem=results;
      setState(() {scroll2=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll2=false;});
    }
  }

  /*Future<void> getBlock() async {
    progressDialog3=nDialog.nProgressDialog(context);
    progressDialog3.show();


    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().blockURL+'/$districtDropdownValue'));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      blockTypeItem=results;
      progressDialog3.dismiss();
      setState(() {});
    }
    else {
      toasts().redToastLong('Server Error');
      progressDialog3.dismiss();
    }
  }*/


  Future<void> getUidByDistrictBlock() async {
    setState(() {scroll1=true;});
    markerr.clear();

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getUidByDistrictBlockURL+'/$districtDropdownValue/0'));
    print(await 'aaaaaaaaa-----${urls().base_url + allAPI().getUidByDistrictBlockURL+'/$districtDropdownValue/0'}');


    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      allApiMarker=results;
      showMarkers();
      setState(() {scroll1=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll1=false;});
    }
  }

  /*Future<void> getServiceCenterList() async {
    setState(() {scroll2=true;});
    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getServiceCenterListURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      allServiceCenterItem=results;
      setState(() {scroll2=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll2=false;});
    }
  }*/

}

