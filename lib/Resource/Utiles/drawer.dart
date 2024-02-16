

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missionujala/Modules/allUIDScreen.dart';
import 'package:missionujala/Modules/viewLocations.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/generated/assets.dart';
import 'package:missionujala/userLoginScreen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Modules/addServiceCenter.dart';
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
  String loginType='';

  @override
  void initState() {
    getUserName();
    _getVersion();
    super.initState();
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginType = prefs.getString('loginType')!;
      loginType=='user' ? userName = prefs.getString('userName')! : userName = prefs.getString('vendorName')!;
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
      color: Colors.white,
      child: Drawer(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(0),
              bottomRight: Radius.circular(0)),
        ),
        width: MediaQuery.of(context).size.width/1.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.only(left: 20,right: 30),
                  child: Image.asset('assets/images/muLogo.png',width: 150,height: 100,),
                ),

                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Divider(thickness: 2,color: Colors.grey[300],),
                ),
                SizedBox(height: 20,),

                InkWell(
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: 3),
                    title: Text('${allTitle.profile}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: appcolors.primaryColor,)),
                    leading:ImageIcon(
                      AssetImage(Assets.iconsProfile),
                      color: appcolors.primaryColor,
                      size: 24,
                    ),
                  ),

                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
                  },
                ),
                InkWell(
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: 3),
                    title: Text('${allTitle.nearByModule}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: appcolors.primaryColor,)),
                    leading:ImageIcon(
                      AssetImage(Assets.iconsStrretLight),
                      color: appcolors.primaryColor,
                      size:24,
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocations()));
                  },
                ),
                loginType=='user' ? Container() : InkWell(
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: 3),
                    title: Text('${allTitle.updateLocationModule}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: appcolors.primaryColor,)),
                    leading:ImageIcon(
                      AssetImage(Assets.iconsUpdateLocation),
                      color: appcolors.primaryColor,
                      size:24,
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => allUIDScreen()));
                  },
                ),
                loginType=='user' ? Container() : InkWell(
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: 3),
                    title: Text('${allTitle.ServiceCenterModule}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: appcolors.primaryColor,)),
                    leading:ImageIcon(
                      AssetImage(Assets.iconsServiceCenterIcon),
                      color: appcolors.primaryColor,
                      size:24,
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => addServiceCenter()));
                  },
                ),
                ListTile(
                  dense: true,
                  visualDensity: VisualDensity(vertical: 3),
                  title: Text('${allTitle.setting}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: appcolors.primaryColor,)),
                  leading:ImageIcon(
                    AssetImage(Assets.iconsSetting),
                    color: appcolors.primaryColor,
                    size:24,
                  ),
                ),
                InkWell(
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: 3),
                    title: Text('${allTitle.logout}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: appcolors.primaryColor,),),
                    leading:ImageIcon(
                      AssetImage(Assets.iconsLogout),
                      color: appcolors.primaryColor,
                      size: 24,
                    ),
                  ),
                  onTap: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('userToken', '');
                    prefs.setString('loginType', '');
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => userLoginScreen()), (Route<dynamic> route) => false);
                  },
                ),
              ],

            ),
            Container(
                padding: EdgeInsets.only(top: 15,bottom: 15),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child:Text("version: $_version",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: appcolors.primaryColor,),),
                )),
          ],
        ),
      ),
    );
  }
}
