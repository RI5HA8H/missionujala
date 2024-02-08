

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          icon: Image.asset(Assets.iconsHome,color: widget.position==0 ? appcolors.primaryColor : appcolors.primaryThemeColor,),
          title: Text(allTitle.home,style: TextStyle(fontSize: 10, color: widget.position==0 ? appcolors.primaryColor : appcolors.primaryThemeColor,fontWeight: FontWeight.bold),),
        ),
        CustomNavigationBarItem(
          icon: Image.asset(Assets.iconsStrretLight,color: widget.position==1 ? appcolors.primaryColor : appcolors.primaryThemeColor,),
          title: Text(allTitle.viewLocationModule,style: TextStyle(fontSize: 8, color:widget.position==1 ? appcolors.primaryColor : appcolors.primaryThemeColor,fontWeight: FontWeight.bold),),
        ),
        CustomNavigationBarItem(
          icon: Image.asset(Assets.iconsProfile,color: widget.position==2 ? appcolors.primaryColor : appcolors.primaryThemeColor,),
          title: Text(allTitle.profile,style: TextStyle(fontSize: 10, color:widget.position==2 ? appcolors.primaryColor : appcolors.primaryThemeColor,fontWeight: FontWeight.bold),),
        ),
        CustomNavigationBarItem(
          icon: Image.asset(Assets.iconsComplaint,color: widget.position==3 ? appcolors.primaryColor : appcolors.primaryThemeColor,),
          title: Text(allTitle.complaint,style: TextStyle(fontSize: 10,color: widget.position==3 ? appcolors.primaryColor : appcolors.primaryThemeColor, fontWeight: FontWeight.bold),),
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocations()));
          }
          if(currentIndex==2){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
          }
          if(currentIndex==3){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
          }
        });
      },
    );
  }
}
