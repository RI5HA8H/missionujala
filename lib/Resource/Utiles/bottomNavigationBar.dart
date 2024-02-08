

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missionujala/Modules/allUIDScreen.dart';
import 'package:missionujala/Modules/viewLocations.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/generated/assets.dart';
import 'package:missionujala/userProfile.dart';

import '../StringLocalization/titles.dart';


class bottomNavigationBar extends StatefulWidget {
  int? position;

  bottomNavigationBar(this.position);

  @override
  State<bottomNavigationBar> createState() => _bottomNavigationBarState(position);
}

class _bottomNavigationBarState extends State<bottomNavigationBar> {
  _bottomNavigationBarState(position);

  int currentIndex = 0;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return  CustomNavigationBar(
      iconSize: 25.0,
      selectedColor: appcolors.primaryThemeColor,
      strokeColor: Colors.transparent,
      unSelectedColor: appcolors.primaryColor,
      backgroundColor: Colors.white,
      items: [
        CustomNavigationBarItem(
          icon: Image.asset(Assets.iconsHome,color: widget.position==0 ? appcolors.primaryThemeColor : appcolors.primaryColor,),
          title: Text(allTitle.home,style: TextStyle(fontSize: 10, color: widget.position==0 ? appcolors.primaryThemeColor : appcolors.primaryColor,fontWeight: FontWeight.bold),),
        ),
        CustomNavigationBarItem(
          icon: Image.asset(Assets.iconsUpdateBottomLocation,color: widget.position==1 ? appcolors.primaryThemeColor : appcolors.primaryColor,),
          title: Text(allTitle.updateLocationModule,style: TextStyle(fontSize: 10,color: widget.position==1 ? appcolors.primaryThemeColor : appcolors.primaryColor, fontWeight: FontWeight.bold),),
        ),
        CustomNavigationBarItem(
          icon: Image.asset(Assets.iconsBottomProfile,color: widget.position==2 ? appcolors.primaryThemeColor : appcolors.primaryColor,),
          title: Text(allTitle.profile,style: TextStyle(fontSize: 10, color:widget.position==2 ? appcolors.primaryThemeColor : appcolors.primaryColor,fontWeight: FontWeight.bold),),
        ),
      ],
      currentIndex: widget.position!,
      onTap: (index) {
        setState(() {
          currentIndex = index;
          print('iiiiiii->$index');
          if(currentIndex==0){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => viewLocations()), (Route<dynamic> route) => false);
          }
          if(currentIndex==1){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => allUIDScreen()), (Route<dynamic> route) => false);
          }
          if(currentIndex==2){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => userProfile()), (Route<dynamic> route) => false);
          }
        });
      },
    );
  }
}
