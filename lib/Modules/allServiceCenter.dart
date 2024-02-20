



import 'package:flutter/material.dart';
import 'package:missionujala/Modules/addServiceCenter.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';

import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/normalButton.dart';

class allServiceCenter extends StatefulWidget {
  const allServiceCenter({super.key});

  @override
  State<allServiceCenter> createState() => _allServiceCenterState();
}

class _allServiceCenterState extends State<allServiceCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: Container(
        color: appcolors.screenBckColor,
        padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: normalButton(name: allTitle.addServiceCenterModule,height:45,bordeRadious: 25,fontSize:14,textColor: Colors.white,bckColor: appcolors.primaryColor,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => addServiceCenter()));
              },
            ),

            SizedBox(height: 20,),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Center Name",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: appcolors.blackColor)),

                          Text("Contact",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: appcolors.blackColor)),

                          Text("View",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: appcolors.blackColor)),

                          Text("Map",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: appcolors.blackColor)),
                        ],
                      ),
                    ),

                    Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
              
                    Expanded(
                      child: ListView.builder(
                          itemCount: 20,
                          itemBuilder: (BuildContext context, int index) => getRow(index, context)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRow(int index,var snapshot) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              
                  Text("Sri Ram Power",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: appcolors.blackColor)),
              
                  Text("7007143286",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: appcolors.blackColor)),

                  Icon(Icons.remove_red_eye,size: 20,color: Colors.grey[600],),

                  Icon(Icons.location_on,size: 20,color: Colors.grey[600],),
              
                ],
              
              ),
            ),

          ),

          Container(
            padding: EdgeInsets.only(left: 5,right: 5),
            child: Divider(
              thickness: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

}
