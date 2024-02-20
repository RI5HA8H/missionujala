

import 'dart:convert';
import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/editText.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/simpleEditText.dart';
import '../Resource/Utiles/toasts.dart';
import 'package:http/http.dart' as http;


class complaintScreen extends StatefulWidget {
  var uIdNo;
  var uIdPlace;
  var uIdVillage;
  var uIdBlock;
  var uIdDist;

  complaintScreen(this.uIdNo,this.uIdPlace,this.uIdVillage,this.uIdBlock,this.uIdDist,);

  @override
  State<complaintScreen> createState() => _complaintScreenState(uIdNo,uIdPlace,uIdVillage,uIdBlock,uIdDist,);
}

class _complaintScreenState extends State<complaintScreen> {
  _complaintScreenState(uIdNo,uIdPlace,uIdVillage,uIdBlock,uIdDist,);

  bool scroll=false;
  bool scrollLatLong=false;
  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode reportLatFocusNode = FocusNode();
  FocusNode reportLongFocusNode = FocusNode();
  FocusNode addressFocusNode = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController reportLatController = TextEditingController();
  TextEditingController reportLongController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  File? galleryFile;
  final picker = ImagePicker();
  String userId='';
  var isLight=true;


  @override
  void initState() {
    super.initState();
    titleController.text=widget.uIdNo;
    addressController.text='${widget.uIdPlace+widget.uIdVillage+widget.uIdBlock+widget.uIdDist}';
    getUserId();
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userKey')!;
    print('uuu--${userId}');

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: scroll ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Container(
          color: appcolors.screenBckColor,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),

                Text('Is Light Working ?',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black54),),

                SizedBox(height: 10,),

                ToggleSwitch(
                  minWidth: 100.0,
                  cornerRadius: 20.0,
                  activeBgColors: [[Colors.green[800]!], [Colors.red[800]!]],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: 0,
                  totalSwitches: 2,
                  labels: ['Yes', 'No'],
                  radiusStyle: true,
                  onToggle: (index) {
                    if(index==0){
                      isLight=true;
                    }else{
                      isLight=true;
                    }
                    print('switched to: $index');
                    print('switched to: $isLight');
                  },
                ),

                SizedBox(height: 30,),

                editTextSimple(
                  controllers: titleController,
                  focusNode: titleFocusNode,
                  hint: 'Enter UID',
                  label: 'UID',
                  keyboardTypes: TextInputType.text,
                  maxlength: 50,
                  fontSize: 14,
                  readOnly: true,
                  etBckgoundColor: appcolors.editTextBckColor,
                ),

                SizedBox(height: 10,),
                Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                  ),
                  child: TextField(
                    maxLines: 3,
                    maxLength: 200,
                    readOnly: true,
                    keyboardType:TextInputType.text,
                    controller: addressController,
                    focusNode: addressFocusNode,
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
                        labelText: 'Address',
                        hintText:'Enter Address',
                        hintStyle: TextStyle(fontSize: 14)
                    ),
                  ),
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
                        hintText:'Enter your comment',
                        hintStyle: TextStyle(fontSize: 14)
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child:Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey[100],
                          child: galleryFile == null ?  Icon(Icons.add_a_photo,color: Colors.black,size: 50,) : Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Center(child: Image.file(galleryFile!)),
                              Positioned(
                                  child: Icon(Icons.change_circle_outlined,size: 30,color: appcolors.primaryColor,)
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        titleFocusNode.unfocus();
                        addressFocusNode.unfocus();
                        descriptionFocusNode.unfocus();
                        _showPicker(context: context);
                      },
                    ),
                  ),
                ),


                SizedBox(height: 30,),
                InkWell(
                  child: normalButton(name: 'Submit',height:45,bordeRadious: 25,fontSize:14,textColor: Colors.white,bckColor: appcolors.buttonColor,),
                  onTap: () async {
                    titleFocusNode.unfocus();
                    addressFocusNode.unfocus();
                    descriptionFocusNode.unfocus();
                    reportLatFocusNode.unfocus();
                    reportLongFocusNode.unfocus();
                    if(titleController.text.isEmpty || descriptionController.text.isEmpty || galleryFile==null){
                      toasts().redToastLong('Proper fill the details');
                    }else{
                      double lat= await getCurrentLatitude();
                      double lng= await getCurrentLongitude();
                      sendReportIssueAPI(lat.toString(),lng.toString());
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

  void _showPicker({required BuildContext context,}) {
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
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img,) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    if (xfilePick != null) {
      galleryFile = File(pickedFile!.path);
      setState(() {});
    } else {
      toasts().redToastLong('Nothing is selected');
    }
  }

  Future<String?> compressImage(File file) async {
    try {
      final compressedFile = await FlutterNativeImage.compressImage(
          file.path,
          quality: 50,
          percentage: 50
      );
      return compressedFile.path;
    } catch (e) {
      return null;
    }
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


  Future<void> sendReportIssueAPI(String lat,String long) async {
   setState(() {scroll=true;});

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().reportIssueApiURL));
    request.fields.addAll({
      'UIDNo': '${widget.uIdNo}',
      'Remarks': '${descriptionController.text}',
      'Latitude': '$lat',
      'Longitude': '$long',
      'CreatedBy': '$userId',
      'Status': 'Pending',
      'IsSSLWorking': '$isLight'
    });

   galleryFile == null ?  print('gggggg---${galleryFile.toString()}') : request.files.add(await http.MultipartFile.fromPath('FilePhoto','${await compressImage(galleryFile!)}'),);

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      toasts().greenToastShort('${results['status']}');
      descriptionController.clear();
      galleryFile=null;
      setState(() {scroll=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }
}
