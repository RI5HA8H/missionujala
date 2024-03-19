
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:missionujala/Modules/viewLocations.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/userRegistrationScreen.dart';
import 'package:missionujala/venderLoginScreen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Resource/StringLocalization/allAPI.dart';
import 'Resource/StringLocalization/baseUrl.dart';
import 'Resource/Utiles/allFunctions.dart';
import 'Resource/Utiles/checkInternet.dart';
import 'Resource/Utiles/editText.dart';
import 'Resource/Utiles/nProgressDialog.dart';
import 'Resource/Utiles/normalButton.dart';
import 'Resource/Utiles/notificationservices.dart';
import 'Resource/Utiles/simpleEditText.dart';
import 'Resource/Utiles/toasts.dart';
import 'package:http/http.dart' as http;

import 'homeScreen.dart';
import 'loginDashboard.dart';


class userLoginScreen extends StatefulWidget {
  const userLoginScreen({super.key});

  @override
  State<userLoginScreen> createState() => _userLoginScreenState();
}

class _userLoginScreenState extends State<userLoginScreen> {

  late ProgressDialog progressDialog;
  bool halfUI = true;
  bool? check1 = true;
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode otpFocusNode = FocusNode();
  int apiOTP=0;

  StreamSubscription? internetconnection;
  bool isoffline = false;
  bool ActiveConnection = false;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          T = "Turn off the data and repress again";
          //debugPrint(T);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        setState(() {
          isoffline = true;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => checkInternet()));
        });
      });
    }
  }

  var token;
  notificationservices notiservices = notificationservices();


  @override
  void initState() {
    super.initState();
    CheckUserConnection();
    _checkVersion();
    internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if(result == ConnectivityResult.none){
        //there is no any connection
        setState(() {
          isoffline = true;
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => checkInternet()));
        });
      }else if(result == ConnectivityResult.mobile){
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      }else if(result == ConnectivityResult.wifi){
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
      super.initState();
    });
    //debugPrint("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
    notiservices.requestNotificationPermissions();
    notiservices.firebaseinit(context);

    notiservices.getifDeviceTokenRefresh();
    notiservices.getDeviceToken().then((value) {
      //debugPrint("device token --- $value");
      token=value;
    });
  }

  @override
  void dispose() {
    internetconnection!.cancel();
    super.dispose();
  }

  void _checkVersion() async {

    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          //Perform flexible update
          InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              //App Update successful
              InAppUpdate.completeFlexibleUpdate();
            }
          });
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => loginDashboard()), (Route<dynamic> route) => false);
        return false;
      },
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
                  Text('Login',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
                  SizedBox(height: 10,),
                  Text('Participate in the awareness campaign and encourage others to join!',style: TextStyle(fontSize: 12,color: appcolors.primaryColor),),

                  SizedBox(height: MediaQuery.of(context).size.height/8,),

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
                      if (mobileController.text.isEmpty == true) {
                        toasts().redToastLong('Please fill all the details');
                      } else {
                        mobileFocusNode.unfocus();
                        otpFocusNode.unfocus();
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

                      SizedBox(height: 20,),
                      GestureDetector(
                        child: normalButton(name: 'Login',bordeRadious: 25,bckColor: appcolors.primaryColor,),
                        onTap: (){
                          if (mobileController.text.isEmpty == true || otpController.text.isEmpty == true) {
                            toasts().redToastLong('Please fill all the details');
                          } else {
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
                      Text('If you are new user then click ',style: TextStyle(fontSize: 12,color:Colors.blueGrey),),
                      GestureDetector(
                        child: Text('Registeration',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blue),),
                        onTap: (){
                          mobileFocusNode.unfocus();
                          otpFocusNode.unfocus();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => userRegistrationScreen()));
                        },
                      ),
                    ],
                  ),
                  /*SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('If you are vendor then click',style: TextStyle(fontSize: 12,color:Colors.blueGrey),),
                      InkWell(
                        child: Text(' Vendor Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.blue),),
                        onTap: (){
                          mobileFocusNode.unfocus();
                          otpFocusNode.unfocus();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => venderLoginScreen()));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),*/
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
          ),
    );
  }

  Future<void> sendOtpAPI() async {
    progressDialog=nDialog.nProgressDialog(context);
    progressDialog.show();

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().userLoginURL));
    request.fields.addAll({
      'UserName': '',
      'MobileNo': allFunctions().encryptToBase64(mobileController.text.toString()),
      'PNRKey': token.toString(),
    });
    //debugPrint(await 'tttttttttttttttttttttttt-----${token}');

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      //debugPrint(await 'aaaaaaaaa-----${results}');
      if(results['userKey'].runtimeType==int){
        setState(() {halfUI = false;});
        toasts().greenToastShort('OTP Send Successfull');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userKey', '${results['userKey']}');
        prefs.setString('userName', '${results['userContactName']}');
        prefs.setString('userMobile', '${results['mobileNo']}');
        prefs.setString('userType', '${results['uType']}');
        prefs.setString('userDistrictKey', '${results['districtKey']}');
        prefs.setString('userCompanyKey', '${results['companyKey']}');
        prefs.setString('userToken', results['userToken']);
        prefs.setString('loginType', 'user');
        apiOTP=int.parse('${allFunctions().decryptStringFromBase64(results['otp'])}');
        //debugPrint('aaaaaaaaaaaaa-->$apiOTP');
        progressDialog.dismiss();

      }else{
        toasts().redToastLong('Something is wrong');
        progressDialog.dismiss();
      }
    }
    else {
     if(results['statusCode']=='MU501'){
       toasts().redToastLong(results['statusMsg']);
       progressDialog.dismiss();
     }else{
       toasts().redToastLong('Server Error');
       progressDialog.dismiss();
     }
    }
  }


}
