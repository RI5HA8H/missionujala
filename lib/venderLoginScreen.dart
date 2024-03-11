

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
import 'package:missionujala/Resource/Utiles/allFunctions.dart';
import 'package:missionujala/Resource/Utiles/nProgressDialog.dart';
import 'package:missionujala/homeScreen.dart';
import 'package:missionujala/userLoginScreen.dart';
import 'package:ndialog/ndialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Resource/StringLocalization/allAPI.dart';
import 'Resource/StringLocalization/baseUrl.dart';
import 'Resource/Utiles/checkInternet.dart';
import 'Resource/Utiles/editText.dart';
import 'Resource/Utiles/normalButton.dart';
import 'Resource/Utiles/notificationservices.dart';
import 'Resource/Utiles/simpleEditText.dart';
import 'Resource/Utiles/toasts.dart';


class venderLoginScreen extends StatefulWidget {
  const venderLoginScreen({super.key});

  @override
  State<venderLoginScreen> createState() => _venderLoginScreenState();
}

class _venderLoginScreenState extends State<venderLoginScreen> {


  bool _isObscure = true;
  late ProgressDialog progressDialog;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  var token;
  notificationservices notiservices = notificationservices();

  @override
  void initState() {
    super.initState();
    debugPrint("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
    notiservices.requestNotificationPermissions();
    notiservices.firebaseinit(context);
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
                  Text('Login',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
                  SizedBox(height: 10,),
                  Text('Participate in the awareness campaign and encourage others to join!',style: TextStyle(fontSize: 12,color: appcolors.primaryColor),),


                  SizedBox(height: MediaQuery.of(context).size.height/8,),



                  editTextSimple(
                    controllers: userNameController,
                    focusNode: userNameFocusNode,
                    hint: 'Enter User Name',
                    keyboardTypes: TextInputType.text,
                    maxlength: 30,),

                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                    ),
                    child: TextField(
                      maxLength: 10,
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Color(0xffC5C5C5), // Border color
                            width: 0.5,         // Border width
                          ),
                        ),
                        counterText: "",
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

                  SizedBox(height: 20,),
                  GestureDetector(
                    child: normalButton(name: 'Verify',bordeRadious: 25,bckColor: appcolors.primaryColor,),
                    onTap: (){
                      if (userNameController.text.isEmpty == true || passwordController.text.isEmpty == true) {
                        toasts().redToastLong('Please fill all the details');
                      } else {
                        userNameFocusNode.unfocus();
                        passwordFocusNode.unfocus();
                        vendorLogin();
                      }
                    },
                  ),
                  SizedBox(height: 30,),

                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('If you are user then click',style: TextStyle(fontSize: 14,color:Colors.blueGrey),),
                      InkWell(
                        child: Text(' User Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.blue),),
                        onTap: (){
                          userNameFocusNode.unfocus();
                          passwordFocusNode.unfocus();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => userLoginScreen()));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),*/

                ],
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

  Future<void> vendorLogin() async {
    progressDialog=nDialog.nProgressDialog(context);
    progressDialog.show();

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().venderLoginURL));
    request.fields.addAll({
      'UserName': allFunctions().encryptToBase64(userNameController.text.toString()),
      'UserPassword': allFunctions().encryptToBase64(passwordController.text.toString()),
      'PNRKey': token.toString(),
    });
    debugPrint(await 'tttttttttttttttttttttttt-----${token}');
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      debugPrint(await 'aaaaaaaaa-----${results}');
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

        progressDialog.dismiss();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => homeScreen()), (Route<dynamic> route) => false);
      }else{
        toasts().redToastLong(results['status']);
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
