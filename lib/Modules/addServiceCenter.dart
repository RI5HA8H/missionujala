

import 'dart:async';
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/StringLocalization/titles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/editText.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';
import 'package:http/http.dart' as http;


class addServiceCenter extends StatefulWidget {
  const addServiceCenter({super.key});

  @override
  State<addServiceCenter> createState() => _addServiceCenterState();
}

class _addServiceCenterState extends State<addServiceCenter> {

  Completer<GoogleMapController> _controller = Completer();
  static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.439602610044293, 82.58186811379103), zoom: 20,);

  bool scroll=true;
  String userToken='';

  var districtTypeItem = [];
  var districtDropdownValue;


  FocusNode centerNameFocusNode = FocusNode();
  FocusNode contactNoFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  FocusNode wevUrlFocusNode = FocusNode();
  FocusNode mapUrlFocusNode = FocusNode();

  TextEditingController centerNameController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController wevUrlController = TextEditingController();
  TextEditingController mapUrlController = TextEditingController();

  double lat= 1.1;
  double long= 1.1;
  String vendorId='';

  @override
  void initState() {
    getUserToken();
    getLatLong();
    super.initState();
  }

  getLatLong() async {
     lat=await getCurrentLatitude();
     long=await getCurrentLongitude();
     debugPrint('lattttt-->$lat');
    setState(() {});
  }

  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('vendorToken')!;
    vendorId = prefs.getString('vendorKey')!;
    getDistrict();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: Container(
        width: double.infinity,
        color: appcolors.screenBckColor,
        padding: EdgeInsets.only(left: 20,right: 20),
        child: scroll ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Text(allTitle.addServiceCenterModule,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
          
              SizedBox(height: 30,),
              Container(
                height: 50,
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
                        debugPrint('llllllllll----$districtDropdownValue');
                      });
                    },
                    value: districtDropdownValue,
                  ),
                ),
              ),

              SizedBox(height: 10,),
              editTextSimple(
                controllers: centerNameController,
                focusNode: centerNameFocusNode,
                hint: 'Enter Name of Center',
               // label: 'Name of Center',
                fontSize: 14,
                keyboardTypes: TextInputType.text,
                maxlength: 30,
              ),
          
              SizedBox(height: 10,),
              editTextSimple(
                controllers: contactNoController,
                focusNode: contactNoFocusNode,
                hint: 'Enter Contact No',
               // label: 'Contact No',
                fontSize: 14,
                keyboardTypes: TextInputType.number,
                maxlength: 10,
              ),
          
              SizedBox(height: 10,),
              editTextSimple(
                controllers: emailController,
                focusNode: emailFocusNode,
                hint: 'Enter Email Address',
               // label: 'Email Address',
                fontSize: 14,
                keyboardTypes: TextInputType.emailAddress,
                maxlength: 40,
              ),
          
              SizedBox(height: 10,),
              editTextSimple(
                cHeight: 60,
                controllers: addressController,
                focusNode: addressFocusNode,
                hint: 'Enter Full Address',
              //  label: 'Full Address',
                fontSize: 14,
                keyboardTypes: TextInputType.text,
                maxlength: 100,
              ),
          
              SizedBox(height: 10,),
              editTextSimple(
                cHeight: 60,
                controllers: wevUrlController,
                focusNode: wevUrlFocusNode,
                hint: 'Enter Website Url',
               // label: 'Website Url(If Any)',
                fontSize: 14,
                keyboardTypes: TextInputType.text,
                maxlength: 100,
              ),

          
              SizedBox(height: 10,),
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextField(
                  maxLines: 3,
                  maxLength: 200,
                  keyboardType:TextInputType.text,
                  controller: mapUrlController,
                  focusNode: mapUrlFocusNode,
                  readOnly: true,
                  style: TextStyle(fontSize: 12,color: Colors.black),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Color(0xffC5C5C5),
                          width: 0.5,
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      counterText: '',
                    //  labelText: 'Geo Location',
                      hintText:'Enter Geo Location',
                      hintStyle: TextStyle(fontSize: 14)
                  ),
                  onTap: (){
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, newSetState) {
                        return AlertDialog(
                          titlePadding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                          contentPadding: EdgeInsets.all(5),
                          //buttonPadding: EdgeInsets.fromLTRB(5, 50, 10, 5),
                          title: const Text('Select Location'),
                          content: Container(
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
                                  lat= latLng.latitude;
                                  long= latLng.longitude;
                                  debugPrint('${lat}, ${long}');
                                  newSetState(() {});
                                }
                            ),
                          ),
                          actions: <Widget>[
                            SizedBox(height: 10,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             crossAxisAlignment: CrossAxisAlignment.center,
                             children: [
                               GestureDetector(
                                 child: normalButton(name: 'Cancel',height:45,bordeRadious: 5,fontSize:12,textColor: Colors.white,bckColor: appcolors.primaryColor,width: MediaQuery.of(context).size.width/3.5,),
                                 onTap: (){
                                   Navigator.of(context).pop();
                                 },
                               ),

                               GestureDetector(
                                 child: normalButton(name: 'Submit',height:45,bordeRadious: 5,fontSize:12,textColor: Colors.white,bckColor: appcolors.primaryColor,width: MediaQuery.of(context).size.width/3.5,),
                                 onTap: (){
                                   mapUrlController.text='https://www.google.com/maps?q=$lat,$long';
                                   Navigator.of(context).pop();
                                 },
                               ),
                             ],
                           ),
                          ],
                        );
                      });
                      },
                    );
                    setState(() {});
                  },
                ),
              ),
          
          
              SizedBox(height: 30,),
              InkWell(
                child: normalButton(name: 'Submit',height:45,bordeRadious: 25,fontSize:14,textColor: Colors.white,bckColor: appcolors.buttonColor,),
                onTap: (){
                  centerNameFocusNode.unfocus();
                  contactNoFocusNode.unfocus();
                  emailFocusNode.unfocus();
                  addressFocusNode.unfocus();
                  wevUrlFocusNode.unfocus();
                  mapUrlFocusNode.unfocus();
                  if(centerNameController.text.isEmpty || contactNoController.text.isEmpty || emailController.text.isEmpty || addressController.text.isEmpty ||  mapUrlController.text.isEmpty){
                    toasts().redToastLong('Proper fill the details');
                  }else{
                    addServiceCenter();
                  }
                },
              ),
              SizedBox(height: 50,),
          
            ],
          ),
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

  Future<void> getDistrict() async {
    setState(() {scroll=true;});
    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().disctrictURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      debugPrint(await 'aaaaaaaaa-----${results}');
      districtTypeItem=results;
      setState(() {scroll=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }

  Future<void> addServiceCenter() async {
    setState(() {scroll=true;});

    var headers = {
      'Authorization': '$userToken'
    };

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().addUpdateServiceCenter));
    request.fields.addAll({
      'SCKey': '0',
      'SCName': '${centerNameController.text}',
      'SCContactNo': '${contactNoController.text}',
      'SCEmailId': '${emailController.text}',
      'SCFullAdress': '${addressController.text}',
      'SCWebsiteUrl': '${wevUrlController.text}',
      'SCGoogleMapUrl': '${mapUrlController.text}',
      'Latitude': '${lat}',
      'Longitude': '${long}',
      'CreatedBy': '${vendorId}',
      'IsActive': 'true',
      'Districtkey': '${districtDropdownValue}'
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      debugPrint(await 'ffffffffffffffff-----${results}');
      centerNameController.clear();
      contactNoController.clear();
      emailController.clear();
      addressController.clear();
      wevUrlController.clear();
      mapUrlController.clear();
      districtDropdownValue=null;
      setState(() {scroll=false;});
      toasts().greenToastLong('Successfully add service center');
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }



}
