



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/editText.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';


class addServiceCenter extends StatefulWidget {
  const addServiceCenter({super.key});

  @override
  State<addServiceCenter> createState() => _addServiceCenterState();
}

class _addServiceCenterState extends State<addServiceCenter> {

  Completer<GoogleMapController> _controller = Completer();
  static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.439602610044293, 82.58186811379103), zoom: 20,);


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

  @override
  void initState() {
    getLatLong();
    super.initState();
  }

  getLatLong() async {
     lat=await getCurrentLatitude();
     long=await getCurrentLongitude();
     print('lattttt-->$lat');
    setState(() {});
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Text(allTitle.addServiceCenterModule,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
          
              SizedBox(height: 30,),
              editTextSimple(
                controllers: centerNameController,
                focusNode: centerNameFocusNode,
                hint: 'Enter Name of Center',
                label: 'Name of Center',
                fontSize: 14,
                keyboardTypes: TextInputType.text,
                maxlength: 30,
              ),
          
              SizedBox(height: 10,),
              editTextSimple(
                controllers: contactNoController,
                focusNode: contactNoFocusNode,
                hint: 'Enter Contact No',
                label: 'Contact No',
                fontSize: 14,
                keyboardTypes: TextInputType.number,
                maxlength: 10,
              ),
          
              SizedBox(height: 10,),
              editTextSimple(
                controllers: emailController,
                focusNode: emailFocusNode,
                hint: 'Enter Email Address',
                label: 'Email Address',
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
                label: 'Full Address',
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
                label: 'Website Url(If Any)',
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
                      labelText: 'Geo Location',
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
                                  print('${lat}, ${long}');
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
                  if(centerNameController.text.isEmpty || contactNoController.text.isEmpty || emailController.text.isEmpty || addressController.text.isEmpty || wevUrlController.text.isEmpty || mapUrlController.text.isEmpty){
                    toasts().redToastLong('Proper fill the details');
                  }else{
                    centerNameController.clear();
                    contactNoController.clear();
                    emailController.clear();
                    addressController.clear();
                    wevUrlController.clear();
                    mapUrlController.clear();
          
                    toasts().greenToastLong('Successfully add service center');
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




}
