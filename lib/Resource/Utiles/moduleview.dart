
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';


class moduleview  extends StatelessWidget {
  const moduleview ({Key? key,
    required this.title,
    required this.path,
  }) : super(key: key);
  

  final String path;
  final String title;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: appcolors.primaryColor,
          width: 0.25,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: appcolors.moduleBckColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 5),
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                  child: Image.asset(path,height: 40,width: 40,color: appcolors.primaryColor,),
              ),
              SizedBox(height: 10),
              Text(title, style: TextStyle(fontSize: 14, color:Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
