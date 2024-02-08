

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:missionujala/Modules/viewLocations.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/homeScreen.dart';
import 'package:missionujala/userLoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Resource/StringLocalization/allAPI.dart';
import 'Resource/StringLocalization/baseUrl.dart';
import 'Resource/Utiles/checkInternet.dart';
import 'Resource/Utiles/normalButton.dart';
import 'Resource/Utiles/simpleEditText.dart';
import 'Resource/Utiles/toasts.dart';


class venderLoginScreen extends StatefulWidget {
  const venderLoginScreen({super.key});

  @override
  State<venderLoginScreen> createState() => _venderLoginScreenState();
}

class _venderLoginScreenState extends State<venderLoginScreen> {


  bool scroll = false;
  bool _isObscure = true;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  var token;

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
          print(T);
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
                      Text('Vendor Login',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: appcolors.primaryTextColor),),
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
                      height: MediaQuery.of(context).size.height/2,
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
                                  controllers: userNameController,
                                  focusNode: userNameFocusNode,
                                  hint: 'Enter User Name',
                                  label: 'User Name',
                                  keyboardTypes: TextInputType.text,
                                  maxlength: 30,),
                              ),

                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: TextField(
                                  maxLength: 10,
                                  controller: passwordController,
                                  focusNode: passwordFocusNode,
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                    counterText: "",
                                    labelText: 'Password',
                                    hintText: 'Enter Password',
                                    hintStyle: TextStyle(fontSize: 12,decoration: TextDecoration.none),
                                    labelStyle: TextStyle(decoration: TextDecoration.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                            _isObscure ? Icons.visibility : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        }),

                                  ),
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: GestureDetector(
                                  child: normalButton(name: 'Login',bordeRadious: 25,bckColor: appcolors.primaryTextColor,),
                                  onTap: (){
                                    if (userNameController.text.isEmpty == true || passwordController.text.isEmpty == true) {
                                      toasts().redToastLong('Proper Fill the Details');
                                    } else {
                                      userNameFocusNode.unfocus();
                                      passwordFocusNode.unfocus();
                                      setState(() {scroll = true;});
                                      vendorLogin();
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 20,),

                              InkWell(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('If you are user then click',style: TextStyle(fontSize: 12,color:Colors.blueGrey),),
                                    Text(' User Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.blue),),
                                  ],
                                ),
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => userLoginScreen()));
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

  Future<void> vendorLogin() async {

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().venderLoginURL));
    request.fields.addAll({
      'UserName': userNameController.text.toString(),
      'UserPassword': passwordController.text.toString(),
    });
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      if(results['userKey'].runtimeType==int){
        toasts().greenToastShort('Login Successfull');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('vendorKey', '${results['userKey']}');
        prefs.setString('vendorName', results['userName']);
        prefs.setString('vendorMobile', results['mobileNo']);
        prefs.setString('vendorType', '${results['userType']}');
        prefs.setString('vendorCompanyKey', '${results['companyKey']}');
        prefs.setString('vendorDistrictKey', '${results['districtKey']}');
        prefs.setString('vendorCompanyName', results['companyName']);
        prefs.setString('vendorDistrictName', results['districtName']);
        prefs.setString('vendorToken', results['userToken']);
        prefs.setString('loginType', 'vendor');
        setState(() {scroll = false;});
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => viewLocations()), (Route<dynamic> route) => false);
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
