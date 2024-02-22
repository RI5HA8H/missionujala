


import 'package:flutter/material.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/Utiles/appBar.dart';
import 'package:missionujala/Resource/Utiles/drawer.dart';

class complainList extends StatefulWidget {
  const complainList({super.key});

  @override
  State<complainList> createState() => _complainListState();
}

class _complainListState extends State<complainList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
        color: appcolors.screenBckColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            color: Colors.white,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) => getComplaintContainer(index, context),
            ),
          ),
        ),
      ),
    );
  }

  Widget getComplaintContainer(int index,var snapshot) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('#MURI21022024XXXX09',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/remarkIcon.png',width: 20,height: 20,color: appcolors.primaryColor,),
                          SizedBox(width: 10,),
                          Image.asset('assets/icons/imgIconn.png',width: 20,height: 20,color: appcolors.primaryColor,),
                          SizedBox(width: 10,),
                          Image.asset('assets/icons/locationIconn.png',width: 20,height: 20,color: appcolors.primaryColor,),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('UID No.: 20047836589042',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('[Pending]',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                          Container(),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 5,),
                  Text('CR By : Rishabh Tiwari',style: TextStyle(fontSize: 12,color: Colors.black54)),


                  SizedBox(height: 2,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(),
                      Text('12 Feb 2024',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.grey)),
                    ],
                  ),



                ],
              ),
            ),

          ),

          Container(
            padding: EdgeInsets.only(left: 15,right: 15),
            child: Divider(
              thickness: 0.5,
              color: Colors.black12,
            ),
          ),
        ],
      ),
    );
  }

}
