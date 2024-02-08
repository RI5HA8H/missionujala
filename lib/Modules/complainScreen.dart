

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/editText.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/simpleEditText.dart';
import '../Resource/Utiles/toasts.dart';


class complaintScreen extends StatefulWidget {
  var uIdNo;

  complaintScreen(this.uIdNo,);

  @override
  State<complaintScreen> createState() => _complaintScreenState(uIdNo);
}

class _complaintScreenState extends State<complaintScreen> {
  _complaintScreenState(uIdNo);

  bool scroll=false;
  bool scrollLatLong=false;
  bool isLatLong=false;
  bool isImgOne=false;
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode reportLatFocusNode = FocusNode();
  FocusNode reportLongFocusNode = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reportLatController = TextEditingController();
  TextEditingController reportLongController = TextEditingController();
  File? galleryFile1;
  File? galleryFile2;
  final picker1 = ImagePicker();
  final picker2 = ImagePicker();


  @override
  void initState() {
    super.initState();
    titleController.text=widget.uIdNo;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 30,
        title: Text('${allTitle.userComplaint}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: appcolors.screenBckColor,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 30,),
        
                ToggleSwitch(
                  minWidth: 100.0,
                  cornerRadius: 20.0,
                  activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: 1,
                  totalSwitches: 2,
                  labels: ['ON', 'OFF'],
                  radiusStyle: true,
                  onToggle: (index) {
                    print('switched to: $index');
                  },
                ),
        
                SizedBox(height: 20,),
        
                editTextSimple(
                  controllers: titleController,
                  focusNode: titleFocusNode,
                  hint: 'Enter UID',
                  label: 'UID',
                  keyboardTypes: TextInputType.text,
                  maxlength: 50,
                  fontSize: 14,
                  readOnly: true,
                ),

                SizedBox(height: 10,),
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                  ),
                  child: TextField(
                    maxLines: 3,
                    maxLength: 200,
                    keyboardType:TextInputType.text,
                    controller: descriptionController,
                    focusNode: descriptionFocusNode,
                    style: TextStyle(fontSize: 12,color: Colors.black),
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
                        counterText: '',
                        labelText: '',
                        hintText:'Enter Details Here',
                        hintStyle: TextStyle(fontSize: 14)
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                  ),
                  child:Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              color: Colors.grey[200],
                              child: galleryFile1 == null ?  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo,color: Colors.black,size: 40,),
                                  Text('Upload',style: TextStyle(fontSize: 10),),
                                ],
                              ) : Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Center(child: Image.file(galleryFile1!)),
                                  Positioned(
                                      child: Icon(Icons.change_circle_outlined,size: 30,color: appcolors.primaryColor,)
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            _showPicker1(context: context);
                          },
                        ),
                        InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              color: Colors.grey[200],
                                child: galleryFile2 == null ?  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_a_photo,color: Colors.black,size: 40,),
                                    Text('Upload',style: TextStyle(fontSize: 10),),
                                  ],
                                ) : Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Center(child: Image.file(galleryFile2!)),
                                    Positioned(
                                        child: Icon(Icons.change_circle_outlined,size: 30,color: appcolors.primaryColor,)
                                    ),
                                  ],
                                ),
                            ),
                          ),
                          onTap: (){
                            _showPicker2(context: context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                Container(
                  child: GestureDetector(
                      child: normalButton(name: 'Get Latitude & Longitude',bckColor: Colors.grey,height: 40,bordeRadious: 5,),
                      onTap: () async {
                        setState(() {scrollLatLong=true;});
                        double lat=await getCurrentLatitude();
                        double long=await getCurrentLongitude();
                        reportLatController.text='$lat';
                        reportLongController.text='$long';
                        setState(() {isLatLong=true;scrollLatLong=false;});
                      }
                  ),
                ),


                SizedBox(height: 15,),
                scrollLatLong ? Center(child: CircularProgressIndicator()) : isLatLong ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    editTextSimple(
                      cWidth: MediaQuery.of(context).size.width*0.4,
                      controllers: reportLatController,
                      focusNode: reportLatFocusNode,
                      hint: 'Enter Latitude',
                      label: 'Latitude',
                      keyboardTypes: TextInputType.text,
                      maxlength: 50,
                      fontSize: 14,
                      readOnly: true,
                    ),
                    editTextSimple(
                      cWidth: MediaQuery.of(context).size.width*0.4,
                      controllers: reportLongController,
                      focusNode: reportLongFocusNode,
                      hint: 'Enter Longitude',
                      label: 'Longitude',
                      keyboardTypes: TextInputType.text,
                      maxlength: 50,
                      fontSize: 14,
                      readOnly: true,
                    ),
                  ],
                ) : Container(),


                SizedBox(height: 30,),
                InkWell(
                  child: normalButton(name: 'Send',height:45,bordeRadious: 25,fontSize:14,textColor: Colors.black,bckColor: appcolors.primaryTextColor,),
                  onTap: (){
                    titleFocusNode.unfocus();
                    descriptionFocusNode.unfocus();
                    reportLatFocusNode.unfocus();
                    reportLongFocusNode.unfocus();
                    if(titleController.text.isEmpty || descriptionController.text.isEmpty){
                      toasts().redToastLong('Proper fill the details');
                    }else{
                      titleController.clear();
                      descriptionController.clear();
                      toasts().greenToastLong('Send SMS to Related Vendor for the Issue Registered #413827');
                    }
                  },
                ),
                SizedBox(height: 50,),
        
              ],
            ),
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

  void _showPicker1({required BuildContext context,}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  getImage1(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage1(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPicker2({required BuildContext context,}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  getImage2(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage2(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage1(ImageSource img1,) async {
    final pickedFile1 = await picker1.pickImage(source: img1);
    XFile? xfilePick1 = pickedFile1;
    if (xfilePick1 != null) {
      galleryFile1 = File(pickedFile1!.path);
      setState(() {isImgOne=false;});
    } else {
      toasts().redToastLong('Nothing is selected');
    }
  }
  Future getImage2(ImageSource img2,) async {
    final pickedFile2 = await picker2.pickImage(source: img2);
    XFile? xfilePick2 = pickedFile2;
    if (xfilePick2 != null) {
      galleryFile2 = File(pickedFile2!.path);
      setState(() {isImgOne=false;});
    } else {
    toasts().redToastLong('Nothing is selected');
    }
  }

}
