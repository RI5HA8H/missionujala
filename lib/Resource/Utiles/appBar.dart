


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/assets.dart';
import '../../userProfile.dart';

class appBar extends StatefulWidget implements PreferredSizeWidget {
  const appBar({super.key});

  @override
  State<appBar> createState() => _appBarState();


  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Implement preferredSize getter


}

class _appBarState extends State<appBar> {

  String profileImg='';

  @override
  void initState() {
    getUserProfile();
    super.initState();
  }


  getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      profileImg = prefs.getString('profileImg')!;
    });
  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 50,
      shadowColor: Colors.transparent,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Image.asset(Assets.iconsMenuIcon,color: appcolors.primaryColor,width: 50,height: 50,),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      titleSpacing: 0,
      title: Image.asset(Assets.imagesSuryodayAppbarLogo,height: 50,),
      actions: [
        IconButton(
          icon: Container(width: 5,),
          onPressed: () {
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
          },
        ),
        IconButton(
          icon: Image.asset(Assets.imagesDepartmentLogo,width: 50,height: 50,),
          onPressed: () {
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
          },
        ),
        IconButton(
          icon: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[200],
            child:  profileImg == ''
                ?  Center(child:ClipRect(child: Image.network('https://cdn-icons-png.flaticon.com/512/219/219983.png',)))
                : ClipOval(child: Image.network('$profileImg',fit: BoxFit.cover,height: 100,width: 100,),),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
          },
        ),
      ],

    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
