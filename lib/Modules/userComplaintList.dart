



import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:missionujala/Modules/userComplaintDetailedPage.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/Utiles/appBar.dart';
import 'package:missionujala/Resource/Utiles/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/Utiles/bottomNavigationBar.dart';
import '../Resource/Utiles/editText.dart';
import '../Resource/Utiles/emptyContainer.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';
import '../generated/assets.dart';
import '../homeScreen.dart';
import '../userProfile.dart';



class userComplaintList extends StatefulWidget {
  const userComplaintList({super.key});

  @override
  State<userComplaintList> createState() => _userComplaintListState();
}

class _userComplaintListState extends State<userComplaintList> {
  Completer<GoogleMapController> _controller = Completer();
  static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.439602610044293, 82.58186811379103), zoom: 20,);

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
    userComplainListFunction();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => homeScreen()), (Route<dynamic> route) => false);
        return false;
      },
      child: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leadingWidth: 50,
            shadowColor: Colors.transparent,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Image.asset(Assets.iconsMenuIcon,color: appcolors.primaryColor,width: 50,height: 50,),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            title: Image.asset(Assets.imagesSuryodayAppbarLogo,height: 50,),
            actions: [
              IconButton(
                icon: Image.asset(Assets.imagesDepartmentLogo,width: 50,height: 50,),
                onPressed: () {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
                },
              ),
              IconButton(
                icon: Icon(Icons.account_circle,size: 35,color: appcolors.greenTextColor,),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
                },
              ),
            ],
            bottom: const TabBar(
              indicatorColor: appcolors.primaryColor,
              labelColor: appcolors.primaryColor,
              unselectedLabelColor: Colors.black38,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Resolved'),
                Tab(text: 'Archived'),
              ],
            ),
          ),
          drawer: drawer(),
          body:scroll ? Center(child: CircularProgressIndicator()) : Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            color: appcolors.screenBckColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.white,
                child: TabBarView(
                  children: [
                    userComplaintList.length==0 ?  Container(
                      height: MediaQuery.of(context).size.height/2,
                      child: emptyContainer(
                        imgPath: 'assets/images/emptyConplaints.jpg',
                        title: 'No Complaints Record',
                        subTitle: 'All complaints related to street lights will be found here',
                      ),
                    ) : ListView.builder(
                      itemCount: userComplaintList.length,
                      itemBuilder: (BuildContext context, int index) => getPendingComplaintContainer(index, context),
                    ),
                    userComplaintList.length==0 ?  Container(
                      height: MediaQuery.of(context).size.height/2,
                      child: emptyContainer(
                        imgPath: 'assets/images/emptyConplaints.jpg',
                        title: 'No Complaints Record',
                        subTitle: 'All complaints related to street lights will be found here',
                      ),
                    ) : ListView.builder(
                      itemCount: userComplaintList.length,
                      itemBuilder: (BuildContext context, int index) => getResolveComplaintContainer(index, context),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                              color: Colors.grey[200],
                              child: Text('Resolved complaints more than 6 months old',style: TextStyle(fontSize: 14,color: Colors.green),textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: bottomNavigationBar(1),
        ),
      ),
    );
  }

  /*Container(
                          height: 20,
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: Text('Upto 6 months old',style: TextStyle(fontSize: 14,color: Colors.green),textAlign: TextAlign.center,),
                        ),*/

  Widget getPendingComplaintContainer(int index,var snapshot) {
    if(userComplaintList[index]['status']=='Pending'  || userComplaintList[index]['status']=='InProcess'){
      return Container(
        child: Column(
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${userComplaintList[index]['complaintNo']}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Image.asset('assets/icons/imgIconn.png',width: 20,height: 20,color: appcolors.primaryColor,),
                              onTap: () async {
                                if(userComplaintList[index]['photo']==''){
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
                                        child: Image.network('${userComplaintList[index]['photo']}',),
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
                              child: Image.asset('assets/icons/locationIconn.png',width: 20,height: 20,color: appcolors.primaryColor,),
                              onTap: () async {
                                if(userComplaintList[index]['latitude']==''){
                                  toasts().redToastLong('Latlong Not Found');
                                }else{
                                  String url = 'https://www.google.com/maps/search/?api=1&query=${userComplaintList[index]['latitude']},${userComplaintList[index]['longitude']}';
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
                            userComplaintList[index]['userRemarks'].length!=0 && userComplaintList[index]['vendorRemarks'].length!=0 ? GestureDetector(
                              child: Image.asset('assets/icons/comment.png',width: 20,height: 20,color: appcolors.primaryColor,),
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
                                          userComplaintList[index]['vendorRemarks'].length==0 ? Container() : ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: userComplaintList[index]['vendorRemarks'].length,
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
                                                                  Text('${userComplaintList[index]['vendorRemarks'][indexs]['vendorStatus']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),
                                                                  //SizedBox(height: 2,),
                                                                  Text('${userComplaintList[index]['vendorRemarks'][indexs]['vendorFeedBacks']}',style: TextStyle(fontSize: 12,color: Colors.black)),

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
                                                            Text('${formatDate(userComplaintList[index]['vendorRemarks'][indexs]['createdOn'])}',style: TextStyle(fontSize: 8,color: Colors.black38)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          userComplaintList[index]['userRemarks'].length==0 ? Container() : ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: userComplaintList[index]['userRemarks'].length,
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
                                                            userComplaintList[index]['userRemarks'][indexs]['userStatus']=='Resolved' ? Icon(Icons.sentiment_satisfied_alt,size: 20,color: appcolors.primaryColor,) : Icon(Icons.sentiment_dissatisfied_outlined,size: 20,color: appcolors.primaryColor,),
                                                            SizedBox(width: 5,),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width*0.425,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text('${userComplaintList[index]['userRemarks'][indexs]['userStatus']=='Resolved' ? 'Satisfied' : 'Not Satisfied'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),
                                                                  //SizedBox(height: 2,),
                                                                  Text('${userComplaintList[index]['userRemarks'][indexs]['userFeedBacks']}',style: TextStyle(fontSize: 12,color: Colors.black)),
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
                                                            Text('${formatDate(userComplaintList[index]['userRemarks'][indexs]['createdOn'])}',style: TextStyle(fontSize: 8,color: Colors.black38)),
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
                            ) : Container()
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('UID No.: ${userComplaintList[index]['uidNo']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${userComplaintList[index]['status']}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                            Container(),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 5,),
                    Text('${userComplaintList[index]['companyName']}',style: TextStyle(fontSize: 12,color: Colors.black54)),

                    SizedBox(height: 5,),
                    userComplaintList[index]['vendorMobileNo']!=null ? GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(Assets.iconsCallCirculerIcon,width: 20,height: 20,),
                          SizedBox(width: 10,),
                          Text('${userComplaintList[index]['vendorMobileNo']}',style: TextStyle(fontSize: 12,color: Colors.black54)),
                        ],
                      ),
                      onTap: () async {
                        final call = Uri.parse('tel:+91 ${userComplaintList[index]['vendorMobileNo']}');
                        if (await canLaunchUrl(call)) {
                          launchUrl(call);
                        } else {
                          throw 'Could not launch $call';
                        }
                      },
                    ) : Container(),


                    SizedBox(height: 2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(),
                        Text('${formatDate(userComplaintList[index]['createdOn'])}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.grey)),
                      ],
                    ),



                  ],
                ),
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => userComplaintDetailedPage(
                  userComplaintList[index],
                )));

              },
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
    }else{
      return Container();
    }
  }

  Widget getResolveComplaintContainer(int index,var snapshot) {
    if(userComplaintList[index]['status']=='Resolved'){
      return Container(
        color: userComplaintList[index]['userRemarks'].length==0 && userComplaintList[index]['vendorRemarks'].length!=0 ? Colors.red[100] : Colors.transparent,
        child: Column(
          children: [
            ListTile(
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${userComplaintList[index]['complaintNo']}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Image.asset(Assets.iconsFeedbacksIcon,width: 20,height: 20,color: appcolors.primaryColor,),
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
                                          updateFeedbackFunction('${userComplaintList[index]['reportIssueKey']}',userRemarkController.text);
                                        }
                                      },
                                    ),
                                  ],
                                ).show();
                              },
                            ),
                            SizedBox(width: 10,),
                            GestureDetector(
                              child: Image.asset('assets/icons/imgIconn.png',width: 20,height: 20,color: appcolors.primaryColor,),
                              onTap: () async {
                                if(userComplaintList[index]['photo']==''){
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
                                        child: Image.network('${userComplaintList[index]['photo']}',),
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
                              child: Image.asset('assets/icons/locationIconn.png',width: 20,height: 20,color: appcolors.primaryColor,),
                              onTap: () async {
                                if(userComplaintList[index]['latitude']==''){
                                  toasts().redToastLong('Latlong Not Found');
                                }else{
                                  String url = 'https://www.google.com/maps/search/?api=1&query=${userComplaintList[index]['latitude']},${userComplaintList[index]['longitude']}';
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
                              child: Image.asset('assets/icons/comment.png',width: 20,height: 20,color: appcolors.primaryColor,),
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
                                          userComplaintList[index]['vendorRemarks'].length==0 ? Container() : ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: userComplaintList[index]['vendorRemarks'].length,
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
                                                                  Text('${userComplaintList[index]['vendorRemarks'][indexs]['vendorStatus']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),
                                                                  Text('${userComplaintList[index]['vendorRemarks'][indexs]['vendorFeedBacks']}',style: TextStyle(fontSize: 12,color: Colors.black)),
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
                                                            Text('${formatDate(userComplaintList[index]['vendorRemarks'][indexs]['createdOn'])}',style: TextStyle(fontSize: 8,color: Colors.black38)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          userComplaintList[index]['userRemarks'].length==0 ? Container() : ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: userComplaintList[index]['userRemarks'].length,
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
                                                            userComplaintList[index]['userRemarks'][indexs]['userStatus']=='Resolved' ? Icon(Icons.sentiment_satisfied_alt,size: 20,color: appcolors.primaryColor,) : Icon(Icons.sentiment_dissatisfied_outlined,size: 20,color: appcolors.primaryColor,),
                                                            SizedBox(width: 5,),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width*0.425,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text('${userComplaintList[index]['userRemarks'][indexs]['userStatus']=='Resolved' ? 'Satisfied' : 'Not Satisfied'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),
                                                                  Text('${userComplaintList[index]['userRemarks'][indexs]['userFeedBacks']}',style: TextStyle(fontSize: 12,color: Colors.black)),
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
                                                            Text('${formatDate(userComplaintList[index]['userRemarks'][indexs]['createdOn'])}',style: TextStyle(fontSize:8,color: Colors.black38)),
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
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('UID No.: ${userComplaintList[index]['uidNo']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${userComplaintList[index]['status']}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                            Container(),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 5,),
                    Text('${userComplaintList[index]['companyName']}',style: TextStyle(fontSize: 12,color: Colors.black54)),

                    SizedBox(height: 5,),
                    userComplaintList[index]['vendorMobileNo']!=null ? GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(Assets.iconsCallCirculerIcon,width: 20,height: 20,),
                          SizedBox(width: 10,),
                          Text('${userComplaintList[index]['vendorMobileNo']}',style: TextStyle(fontSize: 12,color: Colors.black54)),
                        ],
                      ),
                      onTap: () async {
                        final call = Uri.parse('tel:+91 ${userComplaintList[index]['vendorMobileNo']}');
                        if (await canLaunchUrl(call)) {
                          launchUrl(call);
                        } else {
                          throw 'Could not launch $call';
                        }
                      },
                    ) : Container(),



                    SizedBox(height: 2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(),
                        Text('${formatDate(userComplaintList[index]['createdOn'])}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.grey)),
                      ],
                    ),



                  ],
                ),
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => userComplaintDetailedPage(
                    userComplaintList[index],
                )));

              },
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
    }else{
      return Container();
    }
  }

  String formatDate(String dateString) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    final outputFormat = DateFormat("hh:mm a, dd MMM yyyy");

    final date = inputFormat.parse(dateString);
    return outputFormat.format(date);
  }

  Future<void> userComplainListFunction() async {
    setState(() {scroll = true;});


    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getUserComplaintListURL+'/$userCompanyKey/$userId'));


    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      //debugPrint('rrrr->$results');
      userComplaintList=results;

      setState(() {scroll = false;});
    }
    else {
      if(results['statusCode']=='MU501'){
        toasts().redToastLong(results['statusMsg']);
        setState(() {scroll = false;});
      }else{
        toasts().redToastLong('Server Error');
        setState(() {scroll = false;});
      }
    }
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
        userComplainListFunction();
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
