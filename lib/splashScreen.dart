

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:missionujala/Modules/viewLocations.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/homeScreen.dart';
import 'package:missionujala/userLoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'venderLoginScreen.dart';


class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> with SingleTickerProviderStateMixin {


  void initState() {
    super.initState();

    Timer(Duration(seconds: 3),() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? loginType =prefs.getString('loginType');
      print('hhhhhhhhhhh$loginType');
      if(loginType=='vendor' || loginType=='user'){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>viewLocations()));
      }else
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>userLoginScreen()));
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/SplashBackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Mission',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: appcolors.screenBckColor),),
                    SizedBox(width: 5,),
                    Text('Ujala',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: appcolors.primaryTextColor),),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
