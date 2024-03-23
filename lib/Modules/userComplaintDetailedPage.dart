


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/toasts.dart';
import '../generated/assets.dart';


class userComplaintDetailedPage extends StatefulWidget {
  var userData;

  userComplaintDetailedPage(this.userData);

  @override
  State<userComplaintDetailedPage> createState() => _userComplaintDetailedPageState(userData);
}

class _userComplaintDetailedPageState extends State<userComplaintDetailedPage> {
  _userComplaintDetailedPageState(userData);

  FocusNode userRemarkFocusNode = FocusNode();
  TextEditingController userRemarkController = TextEditingController();

  bool scroll=false;
  String userToken='';
  String userCompanyKey='';
  String userId='';

  var feedbackStatusDropdownValue='Satishfied';

  var feedbackStatusItem = [{'id':'1','shortName':'Satishfied','longName':'Satishfied'},{'id':'2','shortName':'UnSatishfied','longName':'Not Satishfied'},];
  var userComplaintList=[];



  @override
  void initState() {
    getUserToken();
    super.initState();
  }


  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('userToken')!;
      userCompanyKey = prefs.getString('userCompanyKey')!;
      userId = prefs.getString('userKey')!;
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body:  scroll ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: appcolors.whiteColor,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: appcolors.screenBckColor,
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Text('Complaint Details',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
              ),
             Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              
                    //SizedBox(height: 10,),
                    Text('Complaint No. : ${widget.userData['complaintNo'].toString().toUpperCase()}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Uid No. : ${widget.userData['uidNo']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Complaint Date : ${formatDate(widget.userData['createdOn'])}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Status : ${widget.userData['status']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
              
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Is Light Working : ${widget.userData['isSSLWorking']=='true' ? 'Yes' : 'No'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Is Battery not there : ${widget.userData['isBatteryWorking']==null ? 'N/A' : widget.userData['isBatteryWorking']=='true' ? 'Yes' : 'No'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Is Solar Panel Broken : ${widget.userData['isPannelOk']==null ? 'N/A' : widget.userData['isPannelOk']=='true' ? 'Yes' : 'No'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Is Pole Broken : ${widget.userData['isPoleBroken']==null ? 'N/A' : widget.userData['isPoleBroken']=='true' ? 'Yes' : 'No'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),


                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Complaintent : ${widget.userData['userName']==null ? 'N/A' : widget.userData['userName']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                   GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Complaintent No. : ${ widget.userData['userMobileNo']==null ? 'N/A' : widget.userData['userMobileNo']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                     onTap: () async {
                       final call = Uri.parse('tel:+91 ${widget.userData['userMobileNo']}');
                       if (await canLaunchUrl(call)) {
                         launchUrl(call);
                       } else {
                         throw 'Could not launch $call';
                       }
                     },
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vendor : ${widget.userData['vendorName']==null ? 'N/A' : widget.userData['vendorName']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                    GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vendor No. : ${widget.userData['vendorMobileNo']==null ? 'N/A' : widget.userData['vendorMobileNo']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                      onTap: () async {
                        final call = Uri.parse('tel:+91 ${widget.userData['vendorMobileNo']}');
                        if (await canLaunchUrl(call)) {
                          launchUrl(call);
                        } else {
                          throw 'Could not launch $call';
                        }
                      },
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vendor Company : ${widget.userData['companyName']==null ? 'N/A' : widget.userData['companyName']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                   Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Comment : ${ widget.userData['remarks']==null ? 'N/A' : widget.userData['remarks']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),
                    

                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          GestureDetector(
                            child: Image.asset('assets/icons/imgIconn.png',width: 30,height: 30,color: appcolors.primaryColor,),
                            onTap: () async {
                              if(widget.userData['photo']==''){
                                toasts().redToastLong('Image Not Found');
                              }else{
                                Alert(
                                  context: context,
                                  style: AlertStyle(
                                      descStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                      descPadding: EdgeInsets.all(5)
                                  ),
                                  image: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network('${widget.userData['photo']}',),
                                    ),
                                  ),
                                  buttons: [
                                    DialogButton(
                                      gradient: LinearGradient(colors: [
                                        Color.fromRGBO(116, 116, 191, 1.0),
                                        Color.fromRGBO(52, 138, 199, 1.0)]),
                                      child: Text("OK", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 16),),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ).show();
                              }
                            },
                          ),
                          SizedBox(width: 10,),
                          GestureDetector(
                            child: Image.asset('assets/icons/locationIconn.png',width: 30,height: 30,color: appcolors.primaryColor,),
                            onTap: () async {
                              if(widget.userData['latitude']==''){
                                toasts().redToastLong('Latlong Not Found');
                              }else{
                                String url = 'https://www.google.com/maps/search/?api=1&query=${widget.userData['latitude']},${widget.userData['longitude']}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  //debugPrint('Could not launch $url');
                                }
                                setState(() {});
                              }
                            },
                          ),
                          SizedBox(width: 10,),
                          GestureDetector(
                            child: Image.asset('assets/icons/comment.png',width: 30,height: 30,color: appcolors.primaryColor,),
                            onTap: (){
                              Alert(
                                context: context,
                                style: AlertStyle(
                                  descStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                                  descPadding: EdgeInsets.all(5),
                                  descTextAlign: TextAlign.start,
                                  buttonAreaPadding: EdgeInsets.all(10),
                                  isOverlayTapDismiss: false,
                                ),
                                closeFunction: (){
                                  Navigator.of(context).pop();
                                },
                                desc: 'All Conversation',
                                content: Container(
                                  height: 200,
                                  color: Colors.white,
                                  padding: EdgeInsets.all(10),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        widget.userData['vendorRemarks'].length==0 ? Container() : ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount:widget.userData['vendorRemarks'].length,
                                          itemBuilder: (BuildContext context, int indexs){
                                            return Container(
                                              margin: EdgeInsets.only(top: 5,right: 20),
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(20.0),bottomRight: Radius.circular(20)),
                                                child: Container(
                                                  color: Colors.red[100],
                                                  padding: EdgeInsets.fromLTRB(5, 5, 10, 2),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Icon(Icons.check_circle,size: 20,color: appcolors.primaryColor,),
                                                          SizedBox(width: 5,),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width*0.425,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('${widget.userData['vendorRemarks'][indexs]['vendorStatus']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),
                                                                Text('${widget.userData['vendorRemarks'][indexs]['vendorFeedBacks']}',style: TextStyle(fontSize: 12,color: Colors.black)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                      
                                                      SizedBox(height: 2,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(),
                                                          Text('${formatDate(widget.userData['vendorRemarks'][indexs]['createdOn'])}',style: TextStyle(fontSize: 8,color: Colors.black38)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        widget.userData['userRemarks'].length==0 ? Container() : ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: widget.userData['userRemarks'].length,
                                          itemBuilder: (BuildContext context, int indexs){
                                            return Container(
                                              margin: EdgeInsets.only(top: 5,left: 20),
                                              child: ClipRRect(
                                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20.0),topLeft: Radius.circular(20),topRight: Radius.circular(15)),
                                                child: Container(
                                                  color: Colors.green[100],
                                                  padding: EdgeInsets.fromLTRB(10, 5, 5, 2),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          widget.userData['userRemarks'][indexs]['userStatus']=='Resolved' ? Icon(Icons.sentiment_satisfied_alt,size: 20,color: appcolors.primaryColor,) : Icon(Icons.sentiment_dissatisfied_outlined,size: 20,color: appcolors.primaryColor,),
                                                          SizedBox(width: 5,),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width*0.425,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('${widget.userData['userRemarks'][indexs]['userStatus']=='Resolved' ? 'Satisfied' : 'Not Satisfied'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),
                                                                Text('${widget.userData['userRemarks'][indexs]['userFeedBacks']}',style: TextStyle(fontSize: 12,color: Colors.black)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                      
                                                      SizedBox(height: 2,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(),
                                                          Text('${formatDate(widget.userData['userRemarks'][indexs]['createdOn'])}',style: TextStyle(fontSize:8,color: Colors.black38)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                buttons: [
                                  DialogButton(
                                    color: Color.fromRGBO(0, 179, 134, 1.0),
                                    child: Text("OK", style: TextStyle(color: Colors.white, fontSize: 16),),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ).show();
                            },
                          ),
                          SizedBox(width: 10,),
                          widget.userData['status']=='Resolved' ? GestureDetector(
                            child: Image.asset(Assets.iconsFeedbacksIcon,width: 30,height: 30,color: appcolors.primaryColor,),
                            onTap: (){
                              Alert(
                                context: context,
                                style: AlertStyle(
                                  descStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                  descPadding: EdgeInsets.all(5),
                                  descTextAlign: TextAlign.center,
                                  isOverlayTapDismiss: false,
                                ),
                                closeFunction: (){
                                  userRemarkController.clear();
                                  Navigator.of(context).pop();
                                },
                                content: StatefulBuilder(
                                    builder: (context,setState){
                                      return Container(
                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                                        ),
                                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(height: 10,),
                                              ToggleSwitch(
                                                minWidth: 108.0,
                                                initialLabelIndex: 0,
                                                cornerRadius: 20.0,
                                                activeFgColor: Colors.white,
                                                inactiveBgColor: Colors.grey[500],
                                                inactiveFgColor: Colors.white,
                                                totalSwitches: 2,
                                                iconSize: 30,
                                                //labels: ['Satisfied', 'UnSatisfied'],
                                                icons: [Icons.sentiment_satisfied_alt, Icons.sentiment_dissatisfied_outlined],
                                                activeBgColors: [[Colors.green], [Colors.red]],
                                                onToggle: (index) {
                                                  if(index==0){
                                                    feedbackStatusDropdownValue='Satishfied';
                                                  }else{
                                                    feedbackStatusDropdownValue='UnSatishfied';
                                                  }
                                                  //debugPrint('switched to: $index');
                                                  //debugPrint('switched to: $feedbackStatusDropdownValue');
                                                },
                                              ),
                                              SizedBox(height: 10,),
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(5.0),
                                                child: Container(
                                                  color: Colors.white,
                                                  child:TextField(
                                                    maxLines: 3,
                                                    maxLength: 200,
                                                    keyboardType:TextInputType.text,
                                                    controller: userRemarkController,
                                                    focusNode: userRemarkFocusNode,
                                                    style: TextStyle(fontSize: 12,color: Colors.black),
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                        borderSide: BorderSide(
                                                          color: Color(0xffC5C5C5), // Border color
                                                          width: 0.5,         // Border width
                                                        ),
                                                      ),
                                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                                      counterText: '',
                                                      labelText: '',
                                                      hintText:'Type Comment',
                                                      hintStyle: TextStyle(fontSize: 10,color: Colors.grey[500]),
                                                    ),
                                                  ) ,
                                                ),
                                              ),
                                            ]
                                        ),
                                      );
                                    }

                                ),
                                buttons: [
                                  DialogButton(
                                    color: appcolors.buttonColor,
                                    child: Text("Send Feedback", style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),),
                                    onPressed: () async {
                                      if(userRemarkController.text.isEmpty){
                                        toasts().redToastLong('Proper fill the details');
                                      }else{
                                        Navigator.pop(context);
                                        setState(() {scroll = true;});
                                        updateFeedbackFunction('${widget.userData['reportIssueKey']}',userRemarkController.text);
                                      }
                                    },
                                  ),
                                ],
                              ).show();
                            },
                          ) : Container(),

                        ],
                      ),
                    ),
              
              
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatDate(String dateString) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    final outputFormat = DateFormat("hh:mm a, dd MMM yyyy");

    final date = inputFormat.parse(dateString);
    return outputFormat.format(date);
  }



  Future<void> updateFeedbackFunction(String userId, String userRemark) async {

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().userVerifyComplaintStatus+'/$userId/$feedbackStatusDropdownValue/$userRemark'));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());


    if (response.statusCode == 200) {
      //debugPrint(await 'aaaaaaaaa-----${results}');
      if(results['statusCode']=='MU501'){
        toasts().greenToastShort(results['statusMsg']);
        userRemarkController.clear();
        setState(() {scroll = false;});
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => homeScreen()), (Route<dynamic> route) => false);
      }else{
        toasts().redToastLong('Please try again');
        setState(() {scroll = false;});
      }
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll = false;});
    }
  }
}
