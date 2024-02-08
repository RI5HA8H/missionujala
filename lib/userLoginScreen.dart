
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:missionujala/Modules/viewLocations.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/userRegistrationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Resource/StringLocalization/allAPI.dart';
import 'Resource/StringLocalization/baseUrl.dart';
import 'Resource/Utiles/normalButton.dart';
import 'Resource/Utiles/simpleEditText.dart';
import 'Resource/Utiles/toasts.dart';
import 'package:http/http.dart' as http;

import 'homeScreen.dart';


class userLoginScreen extends StatefulWidget {
  const userLoginScreen({super.key});

  @override
  State<userLoginScreen> createState() => _userLoginScreenState();
}

class _userLoginScreenState extends State<userLoginScreen> {

  bool scroll = false;
  bool halfUI = true;
  bool? check1 = true;
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  var token;
  int apiOTP=0;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Container(
                  color: appcolors.primaryColor,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('User Login',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: appcolors.primaryTextColor),),
                      SizedBox(height: 10,),
                      Text('Welcome! Sign in with your credentials',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white),),
                      SizedBox(height: 120,),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.45,
                  color: appcolors.screenBckColor,
                ),
              ],
            ),

            Positioned(
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height/1.85,
                      margin: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height/4, 20, 50),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          color: Colors.white,
                          child: scroll ? Center(child: LoadingAnimationWidget.waveDots(color: appcolors.primaryColor, size: 50)) : Column(
                            children: [
                              SizedBox(height: 30,),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: simpleEditText(
                                  controllers: mobileController,
                                  focusNode: mobileFocusNode,
                                  hint: 'Enter Mobile Number',
                                  label: 'Mobile Number',
                                  keyboardTypes: TextInputType.number,
                                  maxlength: 10,),
                              ),

                              halfUI ? Padding(
                                padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                                child: GestureDetector(
                                  child: normalButton(name: 'Send OTP',bordeRadious: 25,bckColor: appcolors.primaryTextColor,),
                                  onTap: (){
                                    if (mobileController.text.isEmpty == true) {
                                      toasts().redToastLong('Proper Fill the Details');
                                    } else {
                                      mobileFocusNode.unfocus();
                                      otpFocusNode.unfocus();
                                      setState(() {halfUI = false;});
                                      sendOtpAPI();
                                    }
                                  },
                                ),
                              ) :

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                    child: simpleEditText(controllers: otpController,
                                      focusNode: otpFocusNode,
                                      hint: 'Enter OTP',
                                      label: 'Recived OTP',
                                      keyboardTypes: TextInputType.number,
                                      maxlength: 6,),
                                  ),


                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        /* Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container( alignment: Alignment.centerLeft,
                                              child: Checkbox(
                                                activeColor:appcolors.primaryColor,
                                                value: check1,
                                                onChanged: (bool? value) {
                                                  if(value!=null){
                                                    setState(() {
                                                      check1 = value;
                                                    });
                                                  }
                                                },),),
                                            Container( alignment: Alignment.centerLeft,
                                                child: Text( 'Remember Me',style: TextStyle(fontWeight: FontWeight.bold,color: appcolors.primaryColor,fontSize: 12),)),

                                          ],
                                        ),*/
                                        Container(),
                                        InkWell(
                                          child: Text('Resend OTP?',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
                                          onTap: (){
                                            setState(() {
                                              otpController.clear();
                                              mobileFocusNode.unfocus();
                                              otpFocusNode.unfocus();
                                              halfUI=true;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),


                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                    child: GestureDetector(
                                      child: normalButton(name: 'Login',bordeRadious: 25,bckColor: appcolors.primaryTextColor,),
                                      onTap: (){
                                        if (mobileController.text.isEmpty == true || otpController.text.isEmpty == true) {
                                          toasts().redToastLong('Proper Fill the Details');
                                        } else {
                                          mobileFocusNode.unfocus();
                                          otpFocusNode.unfocus();
                                          setState(() {scroll = true;});
                                          if(otpController.text.toString()!=apiOTP){
                                            toasts().redToastLong('OTP does not match');
                                          }else{
                                            toasts().redToastLong('User Login Successfull');
                                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => viewLocations()), (Route<dynamic> route) => false);
                                          }
                                        }
                                      },
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 20,),
                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('New user click here',style: TextStyle(fontSize: 12,color:Colors.blueGrey),),
                                    Text(' User Singup',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.blue),),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => userRegistrationScreen()));
                                },
                              ),
                              SizedBox(height: 20,),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendOtpAPI() async {
    setState(() {scroll = true;});

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().userLoginURL));
    request.fields.addAll({
      'UserName': 'asas',
      'MobileNo': mobileController.text.toString(),
    });
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      if(results['userKey'].runtimeType==int){
        toasts().greenToastShort('OTP Send Successfull');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userKey', '${results['userKey']}');
        prefs.setString('userName', '${results['userName']}');
        prefs.setString('userMobile', '${results['mobileNo']}');
        prefs.setString('userType', '${results['uType']}');
        prefs.setString('userDistrictKey', '${results['districtKey']}');
        prefs.setString('userCompanyKey', '${results['companyKey']}');
        prefs.setString('loginType', 'user');
        apiOTP=results['otp'];
        setState(() {scroll = false;});

      }else{
        toasts().redToastLong(results['status']);
        setState(() {scroll = false;});
      }
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll = false;});
    }
  }
}
