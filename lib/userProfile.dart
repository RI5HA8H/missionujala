

import 'package:flutter/material.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Modules/viewLocations.dart';
import 'Resource/StringLocalization/titles.dart';
import 'Resource/Utiles/appBar.dart';
import 'Resource/Utiles/bottomNavigationBar.dart';
import 'Resource/Utiles/drawer.dart';
import 'Resource/Utiles/simpleEditText.dart';


class userProfile extends StatefulWidget {
  const userProfile({super.key});

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {


  String userName  = "N/A";
  String vendorName  = "N/A";
  String userPhoneNo  = "N/A";
  String vendorPhoneNo  = "N/A";
  String loginType='';



  @override
  void initState() {
    getUserName();
    super.initState();
  }


  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginType = prefs.getString('loginType')!;
      userName = prefs.getString('userName')!;
      userPhoneNo = prefs.getString('userMobile')!;
      vendorName = prefs.getString('vendorName')!;
      vendorPhoneNo = prefs.getString('vendorMobile')!;

    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => homeScreen()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        appBar: appBar(),
        drawer: drawer(),
        body: Container(
          width: double.infinity,
          color: appcolors.screenBckColor,
          child: Column(
            children: [

              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20,40, 20, 10),
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.only(left: 20,right: 30),
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 52,
                              child: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: 50,
                                  child: Image.network('https://cdn-icons-png.flaticon.com/512/219/219983.png',width: 150,height: 100,)),
                            ),
                          ),

                          SizedBox(height: 50,),

                          getRow('Name','${loginType=='user' ? userName : vendorName}'),
                          divider(),

                          getRow('Mobile No','${loginType=='user' ? userPhoneNo : vendorPhoneNo}'),
                          divider(),

                          getRow('Address','N/A'),
                          divider(),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavigationBar(3),
      ),
    );
  }

  Widget getRow(String name,String value) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*.3,
            child: Text('$name :',style: const TextStyle(fontSize: 12,color:appcolors.blackColor)),
          ),
          Container(
              width: MediaQuery.of(context).size.width*.5,
              child: Text(value,style: const TextStyle(fontSize: 12,color:appcolors.blackColor,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 2,)
          ),

        ],
      ),
    );
  }

  Widget divider(){
    return Container(
      padding:EdgeInsets.only(left: 8,right: 8),
      child: IntrinsicHeight(
        child: Divider(
          thickness: 1,
          color: Colors.grey[300],
        ),
      ),
    );
  }

}
