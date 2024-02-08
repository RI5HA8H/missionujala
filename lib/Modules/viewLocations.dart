
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
import 'package:missionujala/Modules/updateLocation.dart';
import 'package:missionujala/Modules/viewLocationFullDetails.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/venderLoginScreen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shape_maker/shape_maker.dart';
import 'package:shape_maker/shape_maker_painter.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool scroll=false;
  bool showFilter=false;
  Position? currentPosition;
  final Set<Marker> markerr={};
  var allApiMarker=[];
  double lat= 26.830000;
  double long= 80.91999;
  var districtTypeItem = [];
  var blockTypeItem = [];
  var districtDropdownValue;
  var blockDropdownValue;

  List<LatLng> latlng=[
    LatLng(26.830000,80.91999),
    LatLng(26.810000,80.96999),
    LatLng(26.820000,80.98999),
  ];

  StreamSubscription? internetconnection;
  bool isoffline = false;
  bool ActiveConnection = false;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
          print(T);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        setState(() {
          isoffline = true;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => checkInternet()));
        });
      });
    }
  }



  @override
  void initState()  {
    super.initState();
    getLocation();
    getUserToken();
    CheckUserConnection();
    _checkVersion();
    internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if(result == ConnectivityResult.none){
        //there is no any connection
        setState(() {
          isoffline = true;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => checkInternet()));
        });
      }else if(result == ConnectivityResult.mobile){
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      }else if(result == ConnectivityResult.wifi){
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
      super.initState();
    });
    setState(() {});
  }

  @override
  void dispose() {
    markerr.clear();
    customInfoWindowController.dispose();
    internetconnection!.cancel();
    super.dispose();
  }

  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('vendorToken')!;
    companyKey = prefs.getString('vendorCompanyKey')!;
    double latitude=await getCurrentLatitude();
    double longitude=await getCurrentLongitude();
    getRadiousLatlong(latitude,longitude);
    getDistrict();
  }

  void _checkVersion() async {

    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          //Perform flexible update
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
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
          preferredSize: Size.fromHeight(showFilter ? MediaQuery.of(context).size.height/3 : MediaQuery.of(context).size.height/12),
          child: Container(
            color: Colors.transparent,
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
                        setState(() {showFilter=false;});
                        double latitude=await getCurrentLatitude();
                        double longitude=await getCurrentLongitude();
                        getRadiousLatlong(latitude,longitude);
                      },
                    ),
                    InkWell(
                      child: normalButton(name: 'Choose Location',width:MediaQuery.of(context).size.width/2.5,height:40,bordeRadious: 10,fontSize:14,textColor: Colors.white,bckColor: appcolors.primaryColor,),
                      onTap: (){
                        setState(() {showFilter=true;});
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
                                blockTypeItem.isEmpty;
                                blockDropdownValue=null;
                                getBlock();
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
                        child: normalButton(name: 'Search',height:45,bordeRadious: 20,fontSize:14,textColor: Colors.white,bckColor: appcolors.greenTextColor,),
                        onTap: () async {
                          if(districtDropdownValue==null || blockDropdownValue==null){
                            toasts().redToastShort('Proper fill the details');
                          }else{
                            setState(() {showFilter=false;});
                            lat= 26.830000;
                            long= 80.91999;
                            getUidByDistrictBlock();
                          }
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
      body:scroll ? Center(child: CircularProgressIndicator()) : Stack(
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
            height: 150,
            width: 250,
            offset: 50,
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
                                child: Image.network('${allApiMarker[0]['installedSystemList'][i]['photoPath']}',width: 60,height: 60,fit: BoxFit.fill,),
                              ),
                              SizedBox(width: 5,),
                              Container(
                                width: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('UID-${allApiMarker[0]['installedSystemList'][i]['uidNo']}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,),),
                                    SizedBox(height: 2,),
                                    Text('${allApiMarker[0]['installedSystemList'][i]['schemeName']}',style: TextStyle(fontSize: 10,),),
                                    SizedBox(height: 2,),
                                    Text('${allApiMarker[0]['installedSystemList'][i]['villageName']}, ${allApiMarker[0]['installedSystemList'][i]['blockName']}, ${allApiMarker[0]['installedSystemList'][i]['districtName']}',style: TextStyle(fontSize: 10,),),

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
                          )));
                          print('uuuuuuuuuuuuuuu-->$updateUid');

                          if(updateUid == true){
                            double latitude=await getCurrentLatitude();
                            double longitude=await getCurrentLongitude();
                            getRadiousLatlong(latitude,longitude);
                            getDistrict();
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
    setState(() {});
  }

  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }


  Future<void> getRadiousLatlong(double lati,double longi) async {
    setState(() {scroll=true;});
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
      setState(() {scroll=false;});

    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }

  Future<void> getDistrict() async {
    //progressDialog2=nDialog.nProgressDialog(context);
    //progressDialog2.show();

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().disctrictURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      districtTypeItem=results;
      //progressDialog2.dismiss();
    }
    else {
      toasts().redToastLong('Server Error');
      //progressDialog2.dismiss();
    }
  }

  Future<void> getBlock() async {
    progressDialog3=nDialog.nProgressDialog(context);
    progressDialog3.show();

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().blockURL+'/$districtDropdownValue/$companyKey'));
    request.headers.addAll(headers);
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
  }


  Future<void> getUidByDistrictBlock() async {
    setState(() {scroll=true;});
    markerr.clear();

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getUidByDistrictBlockURL+'/$districtDropdownValue/$blockDropdownValue'));
    print(await 'aaaaaaaaa-----${urls().base_url + allAPI().getUidByDistrictBlockURL+'/$districtDropdownValue/$blockDropdownValue'}');
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      allApiMarker=results;
      showMarkers();
      setState(() {scroll=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }


}

