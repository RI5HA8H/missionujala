


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';


class emptyContainer extends StatelessWidget {
  emptyContainer({Key? key,
    required this.imgPath,
    required this.title,
    required this.subTitle,

    this.imgColor=Colors.transparent,
    this.bckColor=Colors.white,
    this.titleColor=appcolors.primaryColor,
    this.subTitleColor=appcolors.primaryColor,

    this.titleFontSize=18,
    this.subTitlefontSize=10,

    this.spaceHeight1=10,
    this.spaceHeight2=2,

    this.imgWidth=150,
    this.imgHeight=150,

    this.cHeight=200,
    this.cWidth=double.infinity,

    this.bordeRadious=5,
  }) : super(key: key);

  String imgPath;
  String title;
  String subTitle;
  Color imgColor;
  Color bckColor;
  Color titleColor;
  Color subTitleColor;
  double titleFontSize;
  double subTitlefontSize;
  double cWidth;
  double cHeight;
  double spaceHeight1;
  double spaceHeight2;
  double imgWidth;
  double imgHeight;
  double bordeRadious;



  @override
  Widget build(BuildContext context) {
    return Container(
        width: cWidth,
        height: cHeight,
        padding: EdgeInsets.only(left: 10,right: 10),
        decoration: BoxDecoration(
          color: bckColor,
          borderRadius: BorderRadius.circular(bordeRadious),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(imgPath,height: imgHeight,width: imgWidth,),
            SizedBox(height: spaceHeight1,),
            Center(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleFontSize, color: titleColor))),
            SizedBox(height: spaceHeight2,),
            Center(child: Text(subTitle, style: TextStyle(fontSize: subTitlefontSize, color: subTitleColor),textAlign: TextAlign.center,)),
          ],
        )
    );
  }
}
