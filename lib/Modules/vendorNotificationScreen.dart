

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:intl/intl.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/Utiles/appBar.dart';
import 'package:missionujala/Resource/Utiles/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/Utiles/bottomNavigationBar.dart';
import '../Resource/Utiles/emptyContainer.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';
import '../homeScreen.dart';



class vendorNotificationScreen extends StatefulWidget {
  const vendorNotificationScreen({super.key});

  @override
  State<vendorNotificationScreen> createState() => _vendorNotificationScreenState();
}

class _vendorNotificationScreenState extends State<vendorNotificationScreen> {

  bool scroll=true;
  String vendorId='';
  var vendorNotificationAllItem = [];

  @override
  void initState() {
    getVendorToken();
    super.initState();
  }


  getVendorToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      vendorId = prefs.getString('vendorKey')!;
    });
    getVendorNotificationList();
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
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          color: appcolors.screenBckColor,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
                    child: Text('Notification',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Expanded(
                          child: scroll ? Center(child: CircularProgressIndicator()) : vendorNotificationAllItem.length==0 ?  Container(
                            height: MediaQuery.of(context).size.height/2,
                            child: emptyContainer(
                              imgPath: 'assets/images/emptyNotification.png',
                              title: 'No Notification Record',
                              subTitle: 'All information related to this app will be found here',
                            ),
                          ) : ListView.builder(
                              itemCount: vendorNotificationAllItem.length,
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
        ),
        bottomNavigationBar: bottomNavigationBar(2),
      ),
    );
  }


  Widget getRow(int index,var snapshot) {
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Column(
            children: [
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        width: double.infinity,
                        child: Text("${vendorNotificationAllItem[index]['notificationTitle']}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor),
                          maxLines: 5,overflow: TextOverflow.ellipsis,),
                      ),

                      SizedBox(height: 5,),
                      Container(
                        width: double.infinity,
                        child: Text("${vendorNotificationAllItem[index]['notificationBody']}",style: TextStyle(fontSize: 12,color: Colors.black),
                          maxLines: 10,overflow: TextOverflow.ellipsis,),
                      ),

                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          vendorNotificationAllItem[index]['status']==true ? Container(
                            child: normalButton(name: 'Viewed',height: 16,width: 50,fontSize: 8,bckColor: Colors.black26,bordeRadious: 20,),
                          ) : Container(
                            child: normalButton(name: 'New',height: 16,width: 50,fontSize: 8,bckColor: Colors.deepOrangeAccent,bordeRadious: 20,),
                          ),
                          /*Container(
                            child: normalButton(name: '${formatDate(vendorNotificationAllItem[index]['createdOn'])}',height: 16,width: 100,fontSize: 8,bckColor: Colors.black26,bordeRadious: 20,),
                          ),*/
                          Text('${formatDate(vendorNotificationAllItem[index]['createdOn'])}',style: TextStyle(fontSize: 8,color: Colors.black)),
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
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
          /*Positioned(
            right: 10,
             child: vendorNotificationAllItem[index]['status']==true ? Container(
               child: normalButton(name: 'New',height: 16,width: 50,fontSize: 8,bckColor: Colors.deepOrangeAccent,bordeRadious: 20,),
             ) : Container(),
          ),*/
        ],
      ),
    );
  }

  String formatDate(String dateString) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    final outputFormat = DateFormat("hh:mm a, dd MMM yyyy");

    final date = inputFormat.parse(dateString);
    return outputFormat.format(date);
  }


  Future<void> getVendorNotificationList() async {
    setState(() {scroll=true;});
    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getVendorNotificationListURL+'/$vendorId'));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      //debugPrint(await 'aaaaaaaaa-----${results}');
      vendorNotificationAllItem=results;
      FlutterAppBadger.removeBadge();
      setState(() {scroll=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }

}
