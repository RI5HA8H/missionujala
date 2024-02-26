


import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/Utiles/appBar.dart';
import 'package:missionujala/Resource/Utiles/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/Utiles/editText.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';
import '../generated/assets.dart';
import '../userProfile.dart';

class complainList extends StatefulWidget {
  const complainList({super.key});

  @override
  State<complainList> createState() => _complainListState();
}

class _complainListState extends State<complainList> {

  Completer<GoogleMapController> _controller = Completer();
  static  CameraPosition _kGooglePlex = CameraPosition(target: LatLng(26.439602610044293, 82.58186811379103), zoom: 20,);

  FocusNode vendorRemarkFocusNode = FocusNode();
  TextEditingController vendorRemarkController = TextEditingController();

  bool scroll=false;
  String userToken='';
  String companyKey='';
  String vendorId='';

  var complaintList=[];



  @override
  void initState() {
    getUserToken();
    super.initState();
  }


  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('vendorToken')!;
      companyKey = prefs.getString('vendorCompanyKey')!;
      vendorId = prefs.getString('vendorKey')!;
    });
    complainListFunction();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
          title: Image.asset(Assets.imagesMuAppbarLogo,height: 50,),
          actions: [
            IconButton(
              icon: Image.asset(Assets.imagesDepartmentLogo,width: 50,height: 50,),
              onPressed: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => userProfile()));
              },
            ),
            IconButton(
              icon: Image.asset(Assets.imagesProfileLogo,width: 50,height: 50,),
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
              Tab(text: 'Progress'),
              Tab(text: 'Resolve'),
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
                  ListView.builder(
                    itemCount: complaintList.length,
                    itemBuilder: (BuildContext context, int index) => getPendingComplaintContainer(index, context),
                  ),
                  ListView.builder(
                    itemCount: complaintList.length,
                    itemBuilder: (BuildContext context, int index) => getResolveComplaintContainer(index, context),
                  ),
                 Center(
                   child: Container(
                     child: Text('Records not found',style: TextStyle(fontSize: 14,color: Colors.grey),),
                   ),
                 ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getPendingComplaintContainer(int index,var snapshot) {
    if(complaintList[index]['status']=='Progress'){
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
                        Text('#MURI2024XXXX00${complaintList[index]['reportIssueKey']}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                child: Image.asset('assets/icons/remarkIcon.png',width: 20,height: 20,color: appcolors.primaryColor,),
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
                                          updateResolvedFunction('${complaintList[index]['reportIssueKey']}',vendorRemarkController.text);
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
                                if(complaintList[index]['photo']==''){
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
                                        child: Image.network('${complaintList[index]['photo']}',),
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
                                if(complaintList[index]['latitude']==''){
                                  toasts().redToastLong('Latlong Not Found');
                                }else{
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder: (context, newSetState) {
                                        return AlertDialog(
                                          titlePadding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                                          contentPadding: EdgeInsets.all(5),
                                          //buttonPadding: EdgeInsets.fromLTRB(5, 50, 10, 5),
                                          //title: const Text('Complaint Location'),
                                          content: Container(
                                            padding: EdgeInsets.only(top: 25),
                                            height: MediaQuery.of(context).size.height/2,
                                            child: GoogleMap(
                                                mapType: MapType.normal,
                                                markers: <Marker>[
                                                  Marker(markerId:MarkerId('1'),
                                                    position: LatLng(complaintList[index]['latitude'], complaintList[index]['latitude']),
                                                    icon: BitmapDescriptor.defaultMarker,
                                                  )
                                                ].toSet(),
                                                initialCameraPosition: _kGooglePlex,
                                                onMapCreated: (GoogleMapController controller) async {
                                                  controller.animateCamera(CameraUpdate.newCameraPosition(
                                                      CameraPosition(target: LatLng(complaintList[index]['latitude'], complaintList[index]['latitude']), zoom: 15,)
                                                  ));
                                                },

                                            ),
                                          ),
                                          actions: <Widget>[
                                            SizedBox(height: 10,),
                                            GestureDetector(
                                              child: normalButton(name: 'OK',height:45,bordeRadious: 5,fontSize:12,textColor: Colors.white,bckColor: appcolors.primaryColor,width: double.infinity,),
                                              onTap: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    },
                                  );
                                  setState(() {});
                                }
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
                        Text('UID No.: ${complaintList[index]['uidNo']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${complaintList[index]['status']}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                            Container(),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 5,),
                    Text('CR By - ${complaintList[index]['userName']}',style: TextStyle(fontSize: 12,color: Colors.black54)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.call,size: 20,color: appcolors.primaryColor,),
                        SizedBox(width: 10,),
                        Text('${complaintList[index]['userMobileNo']}',style: TextStyle(fontSize: 12,color: Colors.black54)),
                      ],
                    ),


                    SizedBox(height: 2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(),
                        Text('${formatDate(complaintList[index]['createdOn'])}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.grey)),
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
    }else{
      return Container();
    }
  }

  Widget getResolveComplaintContainer(int index,var snapshot) {
    if(complaintList[index]['status']=='Resolve'){
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
                        Text('#MURI2024XXXX00${complaintList[index]['reportIssueKey']}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /*GestureDetector(
                              child: Image.asset('assets/icons/remarkIcon.png',width: 20,height: 20,color: appcolors.primaryColor,),
                              onTap: (){

                              },
                            ),*/
                            SizedBox(width: 10,),
                            GestureDetector(
                              child: Image.asset('assets/icons/imgIconn.png',width: 20,height: 20,color: appcolors.primaryColor,),
                              onTap: () async {
                                if(complaintList[index]['photo']==''){
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
                                        child: Image.network('${complaintList[index]['photo']}',),
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
                                if(complaintList[index]['latitude']==''){
                                  toasts().redToastLong('Latlong Not Found');
                                }else{
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder: (context, newSetState) {
                                        return AlertDialog(
                                          titlePadding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                                          contentPadding: EdgeInsets.all(5),
                                          //buttonPadding: EdgeInsets.fromLTRB(5, 50, 10, 5),
                                          //title: const Text('Complaint Location'),
                                          content: Container(
                                            padding: EdgeInsets.only(top: 25),
                                            height: MediaQuery.of(context).size.height/2,
                                            child: GoogleMap(
                                              mapType: MapType.normal,
                                              markers: <Marker>[
                                                Marker(markerId:MarkerId('1'),
                                                  position: LatLng(complaintList[index]['latitude'], complaintList[index]['latitude']),
                                                  icon: BitmapDescriptor.defaultMarker,
                                                )
                                              ].toSet(),
                                              initialCameraPosition: _kGooglePlex,
                                              onMapCreated: (GoogleMapController controller) async {
                                                controller.animateCamera(CameraUpdate.newCameraPosition(
                                                    CameraPosition(target: LatLng(complaintList[index]['latitude'], complaintList[index]['latitude']), zoom: 15,)
                                                ));
                                              },

                                            ),
                                          ),
                                          actions: <Widget>[
                                            SizedBox(height: 10,),
                                            GestureDetector(
                                              child: normalButton(name: 'OK',height:45,bordeRadious: 5,fontSize:12,textColor: Colors.white,bckColor: appcolors.primaryColor,width: double.infinity,),
                                              onTap: (){
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                    },
                                  );
                                  setState(() {});
                                }
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
                        Text('UID No.: ${complaintList[index]['uidNo']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: appcolors.primaryColor)),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('${complaintList[index]['status']}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
                            Container(),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 5,),
                    Text('CR By - ${complaintList[index]['userName']}',style: TextStyle(fontSize: 12,color: Colors.black54)),

                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.call,size: 20,color: appcolors.primaryColor,),
                        SizedBox(width: 10,),
                        Text('${complaintList[index]['userMobileNo']}',style: TextStyle(fontSize: 12,color: Colors.black54)),
                      ],
                    ),



                    SizedBox(height: 2,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(),
                        Text('${formatDate(complaintList[index]['createdOn'])}',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.grey)),
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
    }else{
      return Container();
    }
  }

  String formatDate(String dateString) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    final outputFormat = DateFormat("dd MMM yyyy");

    final date = inputFormat.parse(dateString);
    return outputFormat.format(date);
  }

  Future<void> complainListFunction() async {
    setState(() {scroll = true;});

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('POST', Uri.parse(urls().base_url + allAPI().getComplaintURL+'/0/1'));
    print('uuuuu${urls().base_url + allAPI().getComplaintURL+'/$companyKey/$vendorId'}');
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      complaintList=results;

      setState(() {scroll = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll = false;});
    }
  }



  Future<void> updateResolvedFunction(String vendorId, String vendorRemark) async {

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken'
    };

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().updateComplaintStatusURL+'/$vendorId/Resolve/$vendorRemark'));


    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      if(results['statusCode']=='MU501'){
        toasts().greenToastShort(results['statusMsg']);
        setState(() {scroll = false;});
        vendorRemarkController.clear();
        complainListFunction();
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
