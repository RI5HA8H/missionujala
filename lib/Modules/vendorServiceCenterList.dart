

import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:missionujala/Modules/addServiceCenter.dart';
import 'package:missionujala/Modules/updateServiceCenter.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:missionujala/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';
import '../generated/assets.dart';



class vendorServiceCenterList extends StatefulWidget {
  const vendorServiceCenterList({super.key});

  @override
  State<vendorServiceCenterList> createState() => _vendorServiceCenterListState();
}

class _vendorServiceCenterListState extends State<vendorServiceCenterList> {

  Completer<GoogleMapController> _controller = Completer();
  static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.439602610044293, 82.58186811379103), zoom: 20,);


  bool scroll=true;
  String userToken='';
  String vendorId='';

  double lat= 1.1;
  double long= 1.1;

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


  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('vendorToken')!;
    vendorId = prefs.getString('vendorKey')!;
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
      child: Scaffold(
        appBar: appBar(),
        drawer: drawer(),
        body: Container(
          color: appcolors.screenBckColor,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
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
                        hint: Text('Select District',style: TextStyle(fontSize: 12,),),
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
                            print('llllllllll----$districtDropdownValue');
                            var newDistrictWiseServiceCenterList=[];
                            for(int i=0;i<allServiceCenterItem.length;i++){
                              if(allServiceCenterItem[i]['districtkey']==districtDropdownValue){
                                newDistrictWiseServiceCenterList.add(allServiceCenterItem[i]);
                              }
                            }
                            serviceCenterTypeItem=newDistrictWiseServiceCenterList;

                          });
                        },
                        value: districtDropdownValue,
                      ),
                    ),
                  ),
                ),
            
                SizedBox(height: 20,),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Expanded(
                            child: scroll ? Center(child: CircularProgressIndicator()) : ListView.builder(
                                itemCount: serviceCenterTypeItem.length,
                                itemBuilder: (BuildContext context, int index) => getRow(index, context)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child:Icon(Icons.add,color: Colors.white,),
          backgroundColor: appcolors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => addServiceCenter()));
          },
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
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                          Text("${serviceCenterTypeItem[index]['scContactNo']}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: appcolors.blackColor)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              child: Image.asset(Assets.iconsEditIcon,width: 20,height: 20,),
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => updateServiceCenter(
                                serviceCenterTypeItem[index]['scKey'].toString(),
                                serviceCenterTypeItem[index]['latitude'],
                                serviceCenterTypeItem[index]['longitude'],
                                serviceCenterTypeItem[index]['districtkey'],
                                serviceCenterTypeItem[index]['scName'].toString(),
                                serviceCenterTypeItem[index]['scContactNo'].toString(),
                                serviceCenterTypeItem[index]['scEmailId'].toString(),
                                serviceCenterTypeItem[index]['scFullAdress'].toString(),
                                serviceCenterTypeItem[index]['scWebsiteUrl']==null ? '' : serviceCenterTypeItem[index]['scWebsiteUrl'].toString(),
                                serviceCenterTypeItem[index]['scGoogleMapUrl']==null ? '' : serviceCenterTypeItem[index]['scGoogleMapUrl'].toString(),
                              )));
                            },
                          ),
                          SizedBox(width: 20,),
                          GestureDetector(
                              child: Image.asset(Assets.iconsLocationViewIcon,width: 25,height: 25,),
                            onTap: (){
                                lat=serviceCenterTypeItem[index]['latitude'];
                                long=serviceCenterTypeItem[index]['longitude'];
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(builder: (context, newSetState) {
                                    return AlertDialog(
                                      titlePadding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                                      contentPadding: EdgeInsets.all(5),
                                      //buttonPadding: EdgeInsets.fromLTRB(5, 50, 10, 5),
                                     // title: const Text('View Location'),
                                      content: Container(
                                        padding: EdgeInsets.only(top: 25),
                                        height: MediaQuery.of(context).size.height/2,
                                        child: GoogleMap(
                                            mapType: MapType.normal,
                                            markers: <Marker>[
                                              Marker(markerId:MarkerId('1'),
                                                position: LatLng(lat, long),
                                                icon: BitmapDescriptor.defaultMarker,
                                              )
                                            ].toSet(),
                                            initialCameraPosition: _kGooglePlex,
                                            onMapCreated: (GoogleMapController controller) async {
                                              controller.animateCamera(CameraUpdate.newCameraPosition(
                                                  CameraPosition(target: LatLng(lat, long), zoom: 15,)
                                              ));
                                            },
                                            onTap: (latLng) {
                                              print('${lat}, ${long}');
                                            }
                                        ),
                                      ),
                                      actions: <Widget>[
                                        SizedBox(height: 10,),
                                        GestureDetector(
                                          child: normalButton(name: 'OK',height:45,bordeRadious: 5,fontSize:12,textColor: Colors.white,bckColor: appcolors.primaryColor,),
                                          onTap: (){
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                                },
                              );
                              setState(() {});
                            },
                          ),
                        ],
                      ),

                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(Assets.iconsEmailCirculerIcon,width: 20,height: 20,),
                      SizedBox(width: 10,),
                      Text("${serviceCenterTypeItem[index]['scEmailId']}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: appcolors.blackColor)),
                    ],
                  ),


              
                ],
              
              ),
            ),

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

  Future<void> getDistrict() async {
    setState(() {scroll=true;});

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().disctrictURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
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
    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getServiceCenterListURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      serviceCenterTypeItem=results;
      allServiceCenterItem=results;
      setState(() {scroll=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }

}
