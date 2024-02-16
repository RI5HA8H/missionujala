

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
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
  File? galleryFile;
  final picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    titleController.text=widget.uIdNo;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: SingleChildScrollView(
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
                    print('switched to: $index');
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
                          color: Colors.grey[200],
                          child: galleryFile == null ?  Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo,color: Colors.black,size: 40,),
                              Text('Upload',style: TextStyle(fontSize: 10),),
                            ],
                          ) : Stack(
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
                        _showPicker(context: context);
                      },
                    ),
                  ),
                ),


                SizedBox(height: 30,),
                InkWell(
                  child: normalButton(name: 'Submit',height:45,bordeRadious: 25,fontSize:14,textColor: Colors.white,bckColor: appcolors.buttonColor,),
                  onTap: (){
                    titleFocusNode.unfocus();
                    descriptionFocusNode.unfocus();
                    reportLatFocusNode.unfocus();
                    reportLongFocusNode.unfocus();
                    if(titleController.text.isEmpty || descriptionController.text.isEmpty){
                      toasts().redToastLong('Proper fill the details');
                    }else{
                      //titleController.clear();
                      descriptionController.clear();
                      galleryFile=null;

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
      setState(() {isImgOne=false;});
    } else {
      toasts().redToastLong('Nothing is selected');
    }
  }


}
