



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
import 'getLatlongScreen.dart';

class addServiceCenter extends StatefulWidget {
  const addServiceCenter({super.key});

  @override
  State<addServiceCenter> createState() => _addServiceCenterState();
}

class _addServiceCenterState extends State<addServiceCenter> {



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
                  borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
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
                          color: Color(0xffC5C5C5), // Border color
                          width: 0.5,         // Border width
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      counterText: '',
                      labelText: 'Geo Location',
                      hintText:'Enter Geo Location',
                      hintStyle: TextStyle(fontSize: 14)
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>getLatlongScreen()));
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



}
