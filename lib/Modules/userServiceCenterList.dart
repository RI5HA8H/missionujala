


import 'dart:async';
import 'dart:convert';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:missionujala/Modules/addServiceCenter.dart';
import 'package:missionujala/Modules/updateServiceCenter.dart';
import 'package:missionujala/Modules/userServiceCenterDetailedPage.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:missionujala/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';
import '../generated/assets.dart';



class userServiceCenterList extends StatefulWidget {
  const userServiceCenterList({super.key});

  @override
  State<userServiceCenterList> createState() => _userServiceCenterListState();
}

class _userServiceCenterListState extends State<userServiceCenterList> {

  CustomInfoWindowController customInfoWindowController = CustomInfoWindowController();
  Completer<GoogleMapController> _controller = Completer();
  static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.439602610044293, 82.58186811379103), zoom: 20,);


  bool scroll=true;

  double lat= 26.830000;
  double long= 80.91999;
  final Set<Marker> markerr={};

  var districtTypeItem = [];
  var districtDropdownValue;

  var allServiceCenterItem = [];
  var serviceCenterTypeItem = [];
  var serviceCenterDropdownValue;

  @override
  void initState() {
    getUserToken();
    super.initState();
  }
  @override
  void dispose() {
    markerr.clear();
    customInfoWindowController.dispose();
    super.dispose();
  }


  getUserToken() async {
    getDistrict();
    getServiceCenterList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => homeScreen()));
        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: appBar(),
          drawer: drawer(),
          body: Container(
            color: appcolors.screenBckColor,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Color(0xffC5C5C5),
                          width: 0.5,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            isExpanded: true,
                            hint: Text('Select District For Service Center',style: TextStyle(fontSize: 12,),),
                            iconStyleData: IconStyleData(
                              icon: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Icon(Icons.search),
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
                                //debugPrint('llllllllll----$districtDropdownValue');
                                var newDistrictWiseServiceCenterList=[];
                                for(int i=0;i<allServiceCenterItem.length;i++){
                                  if(allServiceCenterItem[i]['districtkey']==districtDropdownValue){
                                    newDistrictWiseServiceCenterList.add(allServiceCenterItem[i]);
                                  }
                                }
                                serviceCenterTypeItem=newDistrictWiseServiceCenterList;
                                markerr.clear();
                                showMarkers();
                              });
                            },
                            value: districtDropdownValue,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),
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
                  SizedBox(height: 5,),
                  Expanded(
                    child: scroll ? Center(child: CircularProgressIndicator()) : Container(
                      child: TabBarView(
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
                                height: 175,
                                width: 250,
                                offset: 50,
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                color: Colors.white,
                                child: ListView.builder(
                                    itemCount: serviceCenterTypeItem.length,
                                    itemBuilder: (BuildContext context, int index) => getRow(index, context)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getRow(int index,var snapshot) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    width: double.infinity,
                    child: Text("${serviceCenterTypeItem[index]['scName']} (${serviceCenterTypeItem[index]['districtName']})",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor),
                      maxLines: 2,overflow: TextOverflow.ellipsis,),
                  ),

                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(Assets.iconsCallCirculerIcon,width: 20,height: 20,),
                          SizedBox(width: 10,),
                          GestureDetector(
                           child: Text("${serviceCenterTypeItem[index]['scContactNo']}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: appcolors.blackColor)),
                            onTap: () async {
                              final call = Uri.parse('tel:+91 ${serviceCenterTypeItem[index]['scContactNo']}');
                              if (await canLaunchUrl(call)) {
                                launchUrl(call);
                              } else {
                                throw 'Could not launch $call';
                              }
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        child:  Image.asset(Assets.iconsLocationViewIcon,width: 25,height: 25,),
                        onTap: () async {
                          lat=serviceCenterTypeItem[index]['latitude'];
                          long=serviceCenterTypeItem[index]['longitude'];
                          String url = 'https://www.google.com/maps/search/?api=1&query=${lat},${long}';
                          if (await canLaunch(url)) {
                          await launch(url);
                          } else {
                          //debugPrint('Could not launch $url');
                          }
                        },
                      ),

                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(Assets.iconsEmailCirculerIcon,width: 20,height: 20,),
                      SizedBox(width: 10,),
                      GestureDetector(
                        child: Text("${serviceCenterTypeItem[index]['scEmailId']}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: appcolors.blackColor)),
                        onTap: () async {
                          String url = 'mailto:${serviceCenterTypeItem[index]['scEmailId']}';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            //debugPrint('Could not launch $url');
                          }
                        },
                      ),
                    ],
                  ),

                ],

              ),
            ),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => userServiceCenterDetailedPage(serviceCenterTypeItem[index])));
            },
          ),

          Container(
            padding: EdgeInsets.only(left: 5,right: 5),
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  showMarkers() async {
    final Uint8List? scmarkerIcon = await getBytesFromAsset(Assets.iconsServiceCenterMarkerIconNew, 100);

    for(int i=0;i<serviceCenterTypeItem.length;i++)
    {
      //debugPrint('ssssssssss${i}');
      if(serviceCenterTypeItem[i]['latitude'].toString()!='null'){
        //debugPrint('hhhhhhhh${i}');
        lat=double.parse('${serviceCenterTypeItem[i]['latitude']}');
        long=double.parse('${serviceCenterTypeItem[i]['longitude']}');
        markerr.add(
          Marker(markerId:MarkerId(i.toString()),
            position: LatLng(double.parse('${serviceCenterTypeItem[i]['latitude']}'),double.parse('${serviceCenterTypeItem[i]['longitude']}')),
            onTap: () {
              //debugPrint('${serviceCenterTypeItem[i]['latitude']}');
              customInfoWindowController.addInfoWindow!(
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black54,
                      width: 0.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Scaffold(
                      body: Container(
                        width: 250,
                        height: 350,
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${serviceCenterTypeItem[i]['scName']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),maxLines: 2,overflow: TextOverflow.ellipsis,),
                              SizedBox(height: 2,),
                              //Text('${serviceCenterTypeItem[i]['districtName']}',style: TextStyle(fontSize: 12,color: Colors.black),maxLines: 2,overflow: TextOverflow.ellipsis,),
                              //SizedBox(height: 5,),
                              Text('${serviceCenterTypeItem[i]['scContactNo']}',style: TextStyle(fontSize: 12,color: Colors.black,),),
                              SizedBox(height: 2,),
                              Text('${serviceCenterTypeItem[i]['scFullAdress']} ${serviceCenterTypeItem[i]['districtName']}',style: TextStyle(fontSize: 12,color: Colors.black,),maxLines: 3,overflow: TextOverflow.ellipsis,),
                              SizedBox(height: 2,),
                            ],
                          ),
                        ),
                      ),
                      bottomNavigationBar: Padding(
                        padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                        child: InkWell(
                          child: normalButton(name: 'Show More',height:30,width: 100,bordeRadious: 10,fontSize:10,textColor: Colors.white,bckColor: appcolors.greenTextColor,),
                          onTap: () async {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => userServiceCenterDetailedPage(serviceCenterTypeItem[i])));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                LatLng(double.parse('${serviceCenterTypeItem[i]['latitude']}'),double.parse('${serviceCenterTypeItem[i]['longitude']}')),
              );
            },
            icon: BitmapDescriptor.fromBytes(scmarkerIcon!),
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


  Future<void> getDistrict() async {
    setState(() {scroll=true;});

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().disctrictURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      //debugPrint(await 'aaaaaaaaa-----${results}');
      districtTypeItem=results;
      setState(() {scroll=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }


  Future<void> getServiceCenterList() async {
    setState(() {scroll=true;});
    markerr.clear();

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getServiceCenterListURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      //debugPrint(await 'aaaaaaaaa-----${results}');
      serviceCenterTypeItem=results;
      allServiceCenterItem=results;
      showMarkers();
      setState(() {scroll=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }

}
