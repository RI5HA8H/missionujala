


import 'package:flutter/material.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/Utiles/normalButton.dart';
import 'package:missionujala/userLoginScreen.dart';
import 'package:missionujala/venderLoginScreen.dart';

import 'Resource/Utiles/toasts.dart';

class loginDashboard extends StatefulWidget {
  const loginDashboard({super.key});

  @override
  State<loginDashboard> createState() => _loginDashboardState();
}

class _loginDashboardState extends State<loginDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 50,),

              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text('Login',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text('Participate in the awareness campaign and encourage others to join!',style: TextStyle(fontSize: 12,color: appcolors.primaryColor),),
              ),

              SizedBox(height: 20,),

              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: normalButton(name: 'User',bckColor: appcolors.greenTextColor,textColor: Colors.white,height: 75,width: MediaQuery.of(context).size.width/2.35,),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => userLoginScreen()));
                      },
                    ),
                    GestureDetector(
                      child: normalButton(name: 'Vendor',bckColor: appcolors.greenTextColor,textColor: Colors.white,height: 75,width: MediaQuery.of(context).size.width/2.35,),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => venderLoginScreen()));
                      },
                    ),
                  ],
                ),
              ),


              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: normalButton(name: 'Vendor\nEmployee',bckColor: appcolors.greenTextColor,textColor: Colors.white,height: 75,width: MediaQuery.of(context).size.width/2.35,),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => venderLoginScreen()));
                      },
                    ),
                    GestureDetector(
                      child: normalButton(name: 'Administrator',bckColor: appcolors.greenTextColor,textColor: Colors.white,height: 75,width: MediaQuery.of(context).size.width/2.35,),
                      onTap: (){
                        toasts().redToastLong('Coming Soon');
                      },
                    ),
                  ],
                ),
              ),


            ],
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
    );
  }
}
