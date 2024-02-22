
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:missionujala/Modules/viewLocations.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/userLoginScreen.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Resource/StringLocalization/allAPI.dart';
import 'Resource/StringLocalization/baseUrl.dart';
import 'Resource/Utiles/editText.dart';
import 'Resource/Utiles/nProgressDialog.dart';
import 'Resource/Utiles/normalButton.dart';
import 'Resource/Utiles/notificationservices.dart';
import 'Resource/Utiles/simpleEditText.dart';
import 'Resource/Utiles/toasts.dart';
import 'homeScreen.dart';



class userRegistrationScreen extends StatefulWidget {
  const userRegistrationScreen({super.key});

  @override
  State<userRegistrationScreen> createState() => _userRegistrationScreenState();
}

class _userRegistrationScreenState extends State<userRegistrationScreen> {

  late ProgressDialog progressDialog;
  bool halfUI = true;
  bool? check1 = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  int apiOTP=0;

  var token;
  notificationservices notiservices = notificationservices();


  @override
  void initState() {
    super.initState();
    debugPrint("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
    notiservices.requestNotificationPermissions();
    notiservices.firebaseinit(context);
    FirebaseMessaging.onMessage.listen((message) {
      print("Tittle---${message.notification!.title.toString()}");
      print("Bodyeee---${message.notification!.body.toString()}");
      getAutoOTPMatch(message.notification!.body.toString().split(':').last);
    });
    notiservices.getifDeviceTokenRefresh();
    notiservices.getDeviceToken().then((value) {
      debugPrint("device token --- $value");
      token=value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [appcolors.l1GradColor,appcolors.l2GradColor,appcolors.l3GradColor,appcolors.l4GradColor,],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50,),
                    Text('User Singup',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
                    SizedBox(height: 10,),
                    Text('Participate in the awareness campaign and encourage others to join!',style: TextStyle(fontSize: 12,color: appcolors.primaryColor),),

                    SizedBox(height: 50,),
                    editTextSimple(
                      controllers: nameController,
                      focusNode: nameFocusNode,
                      hint: 'Enter User Name',
                      keyboardTypes: TextInputType.text,
                      readOnly: !halfUI,
                      maxlength: 30,),

                    SizedBox(height: 10,),
                    editTextSimple(
                      controllers: mobileController,
                      focusNode: mobileFocusNode,
                      hint: 'Enter Mobile Number',
                      keyboardTypes: TextInputType.number,
                      readOnly: !halfUI,
                      maxlength: 10,),

                    SizedBox(height: 10,),
                    halfUI ? GestureDetector(
                      child: normalButton(name: 'Send OTP',bordeRadious: 25,bckColor: appcolors.primaryColor,),
                      onTap: (){
                        if (nameController.text.isEmpty == true || mobileController.text.isEmpty == true) {
                          toasts().redToastLong('Proper Fill the Details');
                        } else {
                          mobileFocusNode.unfocus();
                          otpFocusNode.unfocus();
                          setState(() {halfUI = false;});
                          sendOtpAPI();
                        }
                      },
                    ) :

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        editTextSimple(
                          controllers: otpController,
                          focusNode: otpFocusNode,
                          hint: 'Enter OTP',
                          keyboardTypes: TextInputType.number,
                          maxlength: 6,),

                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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

                        SizedBox(height: 10,),
                        GestureDetector(
                          child: normalButton(name: 'Login',bordeRadious: 25,bckColor: appcolors.primaryColor,),
                          onTap: (){
                            if (nameController.text.isEmpty == true || mobileController.text.isEmpty == true || otpController.text.isEmpty == true) {
                              toasts().redToastLong('Proper Fill the Details');
                            } else {
                              nameFocusNode.unfocus();
                              mobileFocusNode.unfocus();
                              otpFocusNode.unfocus();
                              if(otpController.text.toString()==apiOTP.toString()){
                                toasts().greenToastShort('User Login Successfull');
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => homeScreen()), (Route<dynamic> route) => false);
                              }else{
                                toasts().redToastLong('OTP does not match');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('If you are already singup then click ',style: TextStyle(fontSize: 12,color:Colors.blueGrey),),
                        InkWell(
                          child: Text(' User Singin',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.blue),),
                          onTap: (){
                            nameFocusNode.unfocus();
                            mobileFocusNode.unfocus();
                            otpFocusNode.unfocus();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => userLoginScreen()));
                          },
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: MediaQuery.of(context).size.height*0.25,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/loginFooter.png"),
                fit: BoxFit.fill,
              ),),
          ),
        ),
      ),);
  }

  Future<void> sendOtpAPI() async {
    progressDialog=nDialog.nProgressDialog(context);
    progressDialog.show();

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().userLoginURL));
    request.fields.addAll({
      'UserName': nameController.text.toString(),
      'MobileNo': mobileController.text.toString(),
      'PNRKey': token.toString(),
    });
    print(await 'tttttttttttttttttttttttt-----${token}');

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
        apiOTP=int.parse('${results['otp']}');
        toasts().greenToastShort('OTP - ${results['otp']}');
        progressDialog.dismiss();

      }else{
        toasts().redToastLong('Something is wrong');
        progressDialog.dismiss();
      }
    }
    else {
      toasts().redToastLong('Server Error');
      progressDialog.dismiss();
    }
  }

  void getAutoOTPMatch(String otp){
    print('ooooooo->${otp.trim()}');
    otpController.text=otp.trim();

    mobileFocusNode.unfocus();
    otpFocusNode.unfocus();

    if(otpController.text.toString()==apiOTP.toString()){
      toasts().greenToastShort('User Registration Successfull');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => homeScreen()), (Route<dynamic> route) => false);
    }else{
      toasts().redToastLong('OTP does not match');
    }

  }
}
