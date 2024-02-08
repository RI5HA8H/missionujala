

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:missionujala/Modules/updateLocation.dart';
import 'package:missionujala/Modules/viewLocations.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/generated/assets.dart';
import 'package:missionujala/userProfile.dart';

import 'Resource/StringLocalization/titles.dart';
import 'Resource/Utiles/checkInternet.dart';
import 'Resource/Utiles/drawer.dart';
import 'Resource/Utiles/moduleview.dart';


class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  bool scroll=false;
  String userName  = "MargSoft";

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
    //getUserToken();
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
    });
    super.initState();
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
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 40,
          title: Text(allTitle.appName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
          actions: [
            IconButton(
              icon: Icon(Icons.person_pin,size: 40,color: Colors.white,),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
              },
            ),
          ],
        ),
        drawer: drawer(),
        body: Container(
          color: appcolors.screenBckColor,
          child: Column(
            children: [
              Container(
                color: appcolors.primaryColor,
                padding: EdgeInsets.fromLTRB(15, 30, 15, 30),
                alignment: Alignment.centerLeft,
                child: Text('Welcome, $userName ',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: appcolors.whiteColor),),
              ),
              /*Container(
                child: Image.asset(Assets.imagesHomeBanner),
              ),*/
              Expanded(
                child: Container(
                  padding:  EdgeInsets.fromLTRB(10, 30, 10, 10),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      mainAxisExtent: 150,
                    ),
                    children: [
                      InkWell(
                        child: moduleview(title: '${allTitle.viewLocationModule}', path: Assets.iconsViewLocation,),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocations()));
                        },
                      ),
                      InkWell(
                        child: moduleview(title: '${allTitle.updateLocationModule}', path: Assets.iconsUpdateLocation,),
                        onTap: (){
                         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => updateLocation()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
