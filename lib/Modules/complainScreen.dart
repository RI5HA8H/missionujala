

import 'dart:convert';
import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  String userToken='';
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
  String isLight='true';
  String isBattery='true';
  String isPanel='true';


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
    userToken = prefs.getString('userToken')!;
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
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5,bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Is Light Working?',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),),
                            Text(' *',style: TextStyle(fontSize: 18,color: Colors.red),),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Yes'),
                                value: "true",
                                groupValue: isLight,
                                onChanged: (value) {
                                  setState(() {
                                    isLight = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('No'),
                                value: "false",
                                groupValue: isLight,
                                onChanged: (value) {
                                  setState(() {
                                    isLight = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),),
                    ]),

                SizedBox(height: 10,),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5,bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Is Battery OK?',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),),
                            Text(' *',style: TextStyle(fontSize: 18,color: Colors.red),),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Yes'),
                                value: "true",
                                groupValue: isBattery,
                                onChanged: (value) {
                                  setState(() {
                                    isBattery = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('No'),
                                value: "false",
                                groupValue: isBattery,
                                onChanged: (value) {
                                  setState(() {
                                    isBattery = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),),
                    ]),

                SizedBox(height: 10,),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5,bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Is Solar panel OK?',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),),
                            Text(' *',style: TextStyle(fontSize: 18,color: Colors.red),),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('Yes'),
                                value: "true",
                                groupValue: isPanel,
                                onChanged: (value) {
                                  setState(() {
                                    isPanel = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text('No'),
                                value: "false",
                                groupValue: isPanel,
                                onChanged: (value) {
                                  setState(() {
                                    isPanel = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),),
                    ]),


                SizedBox(height: 20,),

               /* editTextSimple(
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
*/

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Take a photo',style: TextStyle(fontSize: 14,color: Colors.black),),
                        Text(' *',style: TextStyle(fontSize: 18,color: Colors.red),),
                      ],
                    ),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            width: double.infinity,
                            color: Colors.grey[100],
                            child: galleryFile == null ?  GestureDetector(
                                child: Icon(Icons.add_a_photo,color: Colors.black,size: 50,),
                              onTap: (){
                                if(galleryFile!=null){
                                  Alert(
                                    context: context,
                                    style: AlertStyle(
                                        descStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                        descPadding: EdgeInsets.all(5)
                                    ),
                                    image: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(5),
                                          child: ExtendedImage.file(
                                            galleryFile!,
                                            fit: BoxFit.contain,
                                            //enableLoadState: false,
                                            mode: ExtendedImageMode.gesture,
                                            initGestureConfigHandler: (state) {
                                              return GestureConfig(
                                                minScale: 0.9,
                                                animationMinScale: 0.7,
                                                maxScale: 3.0,
                                                animationMaxScale: 3.5,
                                                speed: 1.0,
                                                inertialSpeed: 100.0,
                                                initialScale: 1.0,
                                                inPageView: false,
                                                initialAlignment: InitialAlignment.center,
                                              );
                                            },
                                          )
                                      ),
                                    ),
                                    buttons: [
                                      DialogButton(
                                        gradient: LinearGradient(colors: [
                                          Color.fromRGBO(116, 116, 191, 1.0),
                                          Color.fromRGBO(52, 138, 199, 1.0)]),
                                        child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 16),),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ).show();
                                }else{
                                  titleFocusNode.unfocus();
                                  addressFocusNode.unfocus();
                                  descriptionFocusNode.unfocus();
                                  _showPicker(context: context);
                                }
                              },
                            ) : Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GestureDetector(
                                    child: Center(child: Image.file(galleryFile!)),
                                  onTap: (){
                                    if(galleryFile!=null){
                                      Alert(
                                        context: context,
                                        style: AlertStyle(
                                            descStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                            descPadding: EdgeInsets.all(5)
                                        ),
                                        image: Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(5),
                                              child: ExtendedImage.file(
                                                galleryFile!,
                                                fit: BoxFit.contain,
                                                //enableLoadState: false,
                                                mode: ExtendedImageMode.gesture,
                                                initGestureConfigHandler: (state) {
                                                  return GestureConfig(
                                                    minScale: 0.9,
                                                    animationMinScale: 0.7,
                                                    maxScale: 3.0,
                                                    animationMaxScale: 3.5,
                                                    speed: 1.0,
                                                    inertialSpeed: 100.0,
                                                    initialScale: 1.0,
                                                    inPageView: false,
                                                    initialAlignment: InitialAlignment.center,
                                                  );
                                                },
                                              )
                                          ),
                                        ),
                                        buttons: [
                                          DialogButton(
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(116, 116, 191, 1.0),
                                              Color.fromRGBO(52, 138, 199, 1.0)]),
                                            child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 16),),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      ).show();
                                    }else{
                                      titleFocusNode.unfocus();
                                      addressFocusNode.unfocus();
                                      descriptionFocusNode.unfocus();
                                      _showPicker(context: context);
                                    }
                                  },
                                ),
                                Positioned(
                                  child: GestureDetector(
                                      child: Icon(Icons.change_circle_outlined,size: 30,color: appcolors.primaryColor,),
                                    onTap: (){
                                      titleFocusNode.unfocus();
                                      addressFocusNode.unfocus();
                                      descriptionFocusNode.unfocus();
                                      _showPicker(context: context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Comments',style: TextStyle(fontSize: 14,color: Colors.black),),
                        Text(' (optional)',style: TextStyle(fontSize: 14,color: Colors.red),),
                      ],
                    ),
                    SizedBox(height: 5,),
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
                            hintText:'Enter your comment (optional)',
                            hintStyle: TextStyle(fontSize: 14)
                        ),
                      ),
                    ),
                  ],
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
                    if(titleController.text.isEmpty || galleryFile==null){
                      toasts().redToastLong('Please fill all the details');
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
             /* ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),*/
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

   var headers = {
     'Authorization': 'Bearer $userToken'
   };


   var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().reportIssueApiURL));
    request.fields.addAll({
      'UIDNo': '${widget.uIdNo}',
      'Remarks': '${descriptionController.text}',
      'Latitude': '$lat',
      'Longitude': '$long',
      'CreatedBy': '$userId',
      'Status': 'Progress',
      'IsSSLWorking': '$isLight',
      'IsBatteryWorking': '$isLight',
      'IsPannelOk': '$isLight',
    });

   galleryFile == null ?  print('gggggg---${galleryFile.toString()}') : request.files.add(await http.MultipartFile.fromPath('FilePhoto','${await compressImage(galleryFile!)}'),);

    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      toasts().greenToastShort('${results['statusMsg']}');
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
