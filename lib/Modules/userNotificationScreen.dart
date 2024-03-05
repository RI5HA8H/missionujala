

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/Utiles/appBar.dart';
import 'package:missionujala/Resource/Utiles/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/Utiles/bottomNavigationBar.dart';
import '../Resource/Utiles/toasts.dart';




class userNotificationScreen extends StatefulWidget {
  const userNotificationScreen({super.key});

  @override
  State<userNotificationScreen> createState() => _userNotificationScreenState();
}

class _userNotificationScreenState extends State<userNotificationScreen> {

  bool scroll=true;
  String userId='';
  var userNotificationAllItem = [];

  @override
  void initState() {
    getUserToken();
    super.initState();
  }


  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userKey')!;
    });
    getUserNotificationList();
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Expanded(
                        child: scroll ? Center(child: CircularProgressIndicator()) : ListView.builder(
                            itemCount: userNotificationAllItem.length,
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
    );
  }


  Widget getRow(int index,var snapshot) {
    return Container(
      color: Colors.white,
      child: Column(
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
                    child: Text("${userNotificationAllItem[index]['notificationTitle']}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor),
                      maxLines: 5,overflow: TextOverflow.ellipsis,),
                  ),

                  SizedBox(height: 5,),
                  Container(
                    width: double.infinity,
                    child: Text("${userNotificationAllItem[index]['notificationBody']}",style: TextStyle(fontSize: 12,color: Colors.black38),
                      maxLines: 10,overflow: TextOverflow.ellipsis,),
                  ),

                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(),
                      Text('${formatDate(userNotificationAllItem[index]['createdOn'])}',style: TextStyle(fontSize: 8,color: Colors.grey)),
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

  String formatDate(String dateString) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    final outputFormat = DateFormat("hh:mm a, dd MMM yyyy");

    final date = inputFormat.parse(dateString);
    return outputFormat.format(date);
  }


  Future<void> getUserNotificationList() async {
    setState(() {scroll=true;});
    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getUserNotificationListURL+'/$userId'));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      userNotificationAllItem=results;
      setState(() {scroll=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }

}
