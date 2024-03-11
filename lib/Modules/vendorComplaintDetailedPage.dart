

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/toasts.dart';
import '../generated/assets.dart';



class vendorComplaintDetailedPage extends StatefulWidget {
  var vendorData;

  vendorComplaintDetailedPage(this.vendorData);

  @override
  State<vendorComplaintDetailedPage> createState() => _vendorComplaintDetailedPageState(vendorData);
}

class _vendorComplaintDetailedPageState extends State<vendorComplaintDetailedPage> {
  _vendorComplaintDetailedPageState(vendorData);


  FocusNode vendorRemarkFocusNode = FocusNode();
  TextEditingController vendorRemarkController = TextEditingController();

  bool scroll=false;
  String vendorToken='';
  String vendorCompanyKey='';
  String vendorId='';

  var vendorComplaintList=[];



  @override
  void initState() {
    getUserToken();
    super.initState();
  }


  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      vendorToken = prefs.getString('vendorToken')!;
      vendorCompanyKey = prefs.getString('vendorCompanyKey')!;
      vendorId = prefs.getString('vendorKey')!;
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: scroll
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: appcolors.whiteColor,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: appcolors.screenBckColor,
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Text('Complaint Details', style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: appcolors.primaryColor),),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //SizedBox(height: 10,),
                    Text('Complaint No. : ${widget.vendorData['complaintNo']
                        .toString()
                        .toUpperCase()}', style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text(
                      'Uid No. : ${widget.vendorData['uidNo']}', style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Complaint Date : ${formatDate(
                        widget.vendorData['createdOn'])}', style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text(
                      'Status : ${widget.vendorData['status']}', style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold,),),
                    Divider(),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Is Light Working : ${widget
                              .vendorData['isSSLWorking'] == 'true'
                              ? 'Yes'
                              : 'No'}', style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Is Battery not there : ${widget
                              .vendorData['isBatteryWorking'] == null
                              ? 'N/A'
                              : widget.vendorData['isBatteryWorking'] == 'true'
                              ? 'Yes'
                              : 'No'}', style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Is Solar Panel Broken : ${widget
                              .vendorData['isPannelOk'] == null ? 'N/A' : widget
                              .vendorData['isPannelOk'] == 'true'
                              ? 'Yes'
                              : 'No'}', style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Is Pole Broken : ${widget
                              .vendorData['isPoleBroken'] == null ? 'N/A' : widget
                              .vendorData['isPoleBroken'] == 'true'
                              ? 'Yes'
                              : 'No'}', style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),


                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Complaintent : ${widget.vendorData['userName'] ==
                              null ? 'N/A' : widget.vendorData['userName']}',
                            style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                    GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Complaintent No. : ${ widget
                              .vendorData['userMobileNo'] == null ? 'N/A' : widget
                              .vendorData['userMobileNo']}', style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                      onTap: () async {
                        final call = Uri.parse('tel:+91 ${widget
                            .vendorData['userMobileNo']}');
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
                          Text('Vendor : ${widget.vendorData['vendorName'] == null
                              ? 'N/A'
                              : widget.vendorData['vendorName']}',
                            style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                    GestureDetector(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vendor No. : ${widget.vendorData['vendorMobileNo'] ==
                                null ? 'N/A' : widget
                                .vendorData['vendorMobileNo']}', style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                      onTap: () async {
                        final call = Uri.parse('tel:+91 ${widget
                            .vendorData['vendorMobileNo']}');
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
                          Text('Vendor Company : ${widget
                              .vendorData['companyName'] == null ? 'N/A' : widget
                              .vendorData['companyName']}', style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold,),),
                          Divider(),
                        ],
                      ),
                    ),

                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Comment : ${ widget.vendorData['remarks'] == null
                              ? 'N/A'
                              : widget.vendorData['remarks']}', style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold,),),
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
                              if(widget.vendorData['photo']==''){
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
                                      child: Image.network('${widget.vendorData['photo']}',),
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
                          GestureDetector(
                            child: Image.asset('assets/icons/locationIconn.png',width: 30,height: 30,color: appcolors.primaryColor,),
                            onTap: () async {
                              if(widget.vendorData['latitude']==''){
                                toasts().redToastLong('Latlong Not Found');
                              }else{
                                String url = 'https://www.google.com/maps/search/?api=1&query=${widget.vendorData['latitude']},${widget.vendorData['longitude']}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  debugPrint('Could not launch $url');
                                }
                                setState(() {});
                              }
                            },
                          ),
                          widget.vendorData['vendorFeedBackList'].length!=0 && widget.vendorData['userFeedBackList'].length!=0 ? GestureDetector(
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
                                        widget.vendorData['vendorFeedBackList'].length==0 ? Container() : ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: widget.vendorData['vendorFeedBackList'].length,
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
                                                                Text('${widget.vendorData['vendorFeedBackList'][indexs]['vendorStatus']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),
                                                                Text('${widget.vendorData['vendorFeedBackList'][indexs]['vendorFeedBacks']}',style: TextStyle(fontSize: 12,color: Colors.black)),
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
                                                          Text('${formatDate(widget.vendorData['vendorFeedBackList'][indexs]['createdOn'])}',style: TextStyle(fontSize: 8,color: Colors.black38)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        widget.vendorData['userFeedBackList'].length==0 ? Container() : ListView.builder(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: widget.vendorData['userFeedBackList'].length,
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
                                                          widget.vendorData['userFeedBackList'][indexs]['userStatus']=='Resolved' ? Icon(Icons.sentiment_satisfied_alt,size: 20,color: appcolors.primaryColor,) : Icon(Icons.sentiment_dissatisfied_outlined,size: 20,color: appcolors.primaryColor,),
                                                          SizedBox(width: 5,),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width*0.425,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text('${widget.vendorData['userFeedBackList'][indexs]['userStatus']=='Resolved' ? 'Satisfied' : 'Not Satisfied'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),
                                                                Text('${widget.vendorData['userFeedBackList'][indexs]['userFeedBacks']}',style: TextStyle(fontSize: 12,color: Colors.black)),
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
                                                          Text('${formatDate(widget.vendorData['userFeedBackList'][indexs]['createdOn'])}',style: TextStyle(fontSize:8,color: Colors.black38)),
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
                          ) : Container(),

                          widget.vendorData['status']=='Resolved' ? Container() : GestureDetector(
                            child: Image.asset('assets/icons/remarkIcon.png',width: 30,height: 30,color: appcolors.primaryColor,),
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
                                  vendorRemarkController.clear();
                                  Navigator.of(context).pop();
                                },
                                image: Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5,bottom: 2),
                                            child: Text('Update Status',style: TextStyle(fontSize: 12,color: Colors.grey),),
                                          ),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: Container(
                                              color: Colors.white,
                                              child:TextField(
                                                maxLines: 3,
                                                maxLength: 200,
                                                keyboardType:TextInputType.text,
                                                controller: vendorRemarkController,
                                                focusNode: vendorRemarkFocusNode,
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
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                buttons: [
                                  DialogButton(
                                    color: Color.fromRGBO(0, 179, 134, 1.0),
                                    child: Text("Resolved", style: TextStyle(color: Colors.white, fontSize: 16),),
                                    onPressed: () async {
                                      if(vendorRemarkController.text.isEmpty){
                                        toasts().redToastLong('Proper fill the details');
                                      }else{
                                        Navigator.pop(context);
                                        setState(() {scroll = true;});
                                        updateResolvedFunction('${widget.vendorData['reportIssueKey']}',vendorRemarkController.text);
                                      }
                                    },
                                  ),
                                ],
                              ).show();
                            },
                          ),

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

  Future<void> updateResolvedFunction(String vendorId, String vendorRemark) async {

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $vendorToken'
    };

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().updateComplaintStatusURL+'/$vendorId/Resolved/$vendorRemark'));


    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      debugPrint(await 'aaaaaaaaa-----${results}');
      if(results['statusCode']=='MU501'){
        toasts().greenToastShort(results['statusMsg']);
        vendorRemarkController.clear();
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