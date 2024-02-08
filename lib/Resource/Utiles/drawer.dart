

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missionujala/Modules/allUIDScreen.dart';
import 'package:missionujala/Modules/viewLocations.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/generated/assets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../venderLoginScreen.dart';
import '../../userProfile.dart';
import '../StringLocalization/titles.dart';


class drawer extends StatefulWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {

  String userName  = "XXXXXXXXXX";
  String _version = 'Loading...';

  @override
  void initState() {
    getUserName();
    _getVersion();
    super.initState();
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('vendorName')!;
    });
  }

  Future<void> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: appcolors.primaryColor,
      child: Drawer(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(0),
            bottomRight: Radius.circular(0)),
        ),
        width: MediaQuery.of(context).size.width/1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 50,),
                  Container(
                    child:CircleAvatar(
                      radius: 52,
                      backgroundColor: appcolors.whiteColor,
                      child: CircleAvatar(
                        radius: 51,
                        backgroundColor: appcolors.whiteColor,
                        backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/219/219983.png'),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),
                  Center(child: Text("${userName.toUpperCase()}",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color:appcolors.whiteColor),textAlign: TextAlign.center,)),
                  SizedBox(height: 50,),

                  InkWell(
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -2),
                      title: Text('${allTitle.profile}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: appcolors.whiteColor,)),
                      leading:ImageIcon(
                        AssetImage(Assets.iconsProfile),
                        color: appcolors.whiteColor,
                        size: 20,
                      ),
                    ),

                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
                    },
                  ),
                  InkWell(
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -2),
                      title: Text('${allTitle.viewLocationModule}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: appcolors.whiteColor,)),
                      leading:ImageIcon(
                        AssetImage(Assets.iconsViewLocation),
                        color: appcolors.whiteColor,
                        size:20,
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocations()));
                    },
                  ),
                  InkWell(
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -2),
                      title: Text('${allTitle.updateLocationModule}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: appcolors.whiteColor,)),
                      leading:ImageIcon(
                        AssetImage(Assets.iconsUpdateLocation),
                        color: appcolors.whiteColor,
                        size:20,
                      ),
                    ),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => allUIDScreen()));
                    },
                  ),
                  InkWell(
                    child: ListTile(
                      dense: true,
                      visualDensity: VisualDensity(vertical: -2),
                      title: Text('${allTitle.logout}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: appcolors.whiteColor,),),
                      leading:ImageIcon(
                        AssetImage(Assets.iconsLogout),
                        color: appcolors.whiteColor,
                        //size: 20,
                      ),
                    ),
                    onTap: ()async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('userToken', '');
                      prefs.setString('loginType', '');
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => venderLoginScreen()), (Route<dynamic> route) => false);
                    },
                  ),
                ],

              ),
              Container(
                padding: EdgeInsets.only(top: 15,bottom: 15),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child:Text("version: $_version",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: appcolors.whiteColor,),),
                  )),
            ],
          ),
      ),
    );
  }
}
