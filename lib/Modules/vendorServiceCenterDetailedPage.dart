

import 'package:flutter/material.dart';
import 'package:missionujala/Modules/updateServiceCenter.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';
import '../generated/assets.dart';


class vendorServiceCenterDetailedPage extends StatefulWidget {
  var vendorSCData;

  vendorServiceCenterDetailedPage(this.vendorSCData);

  @override
  State<vendorServiceCenterDetailedPage> createState() => _vendorServiceCenterDetailedPageState(vendorSCData);
}

class _vendorServiceCenterDetailedPageState extends State<vendorServiceCenterDetailedPage> {
  _vendorServiceCenterDetailedPageState(vendorSCData);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: Container(
        width: double.infinity,
        color: appcolors.whiteColor,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: appcolors.screenBckColor,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Text('Service Center Details',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 10,),
                    Text('${widget.vendorSCData['scName'].toString().toUpperCase()}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('District : ${widget.vendorSCData['districtName']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Address : ${widget.vendorSCData['scFullAdress']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Assets.iconsCallCirculerIcon,width: 25,height: 25,),
                        SizedBox(width: 10,),
                        GestureDetector(
                          child: Text('${widget.vendorSCData['scContactNo']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),),
                          onTap: () async {
                            final call = Uri.parse('tel:+91 ${widget.vendorSCData['scContactNo']}');
                            if (await canLaunchUrl(call)) {
                              launchUrl(call);
                            } else {
                              throw 'Could not launch $call';
                            }
                          },
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Assets.iconsEmailCirculerIcon,width: 25,height: 25,),
                        SizedBox(width: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.75,
                          child: GestureDetector(
                            child: Text('${widget.vendorSCData['scEmailId']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                            onTap: () async {
                              String url = 'mailto:${widget.vendorSCData['scEmailId']}';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                //debugPrint('Could not launch $url');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Assets.iconsLocationViewIcon,width: 25,height: 25,),
                        SizedBox(width: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.75,
                          child: GestureDetector(
                            child: Text('${'https://www.google.com/maps/search/?api=1&query=${widget.vendorSCData['latitude']},${widget.vendorSCData['longitude']}'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                            onTap: () async {
                              String url = 'https://www.google.com/maps/search/?api=1&query=${widget.vendorSCData['latitude']},${widget.vendorSCData['longitude']}';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                //debugPrint('Could not launch $url');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(Assets.iconsBrowser,width: 25,height: 25,),
                        SizedBox(width: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.75,
                          child: GestureDetector(
                            child: Text('${widget.vendorSCData['scWebsiteUrl']==null ? 'N/A' : '${widget.vendorSCData['scWebsiteUrl']}'}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                            onTap: () async {
                              String url = '${widget.vendorSCData['scWebsiteUrl']}';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                //debugPrint('Could not launch $url');
                                toasts().redToastLong('Url not found');
                              }
                            },
                          ),
                        ),

                      ],
                    ),
                    Divider(),


                    SizedBox(height: 20,),

                    GestureDetector(
                      child: normalButton(name: 'Edit',bckColor: appcolors.buttonColor,height: 40,),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => updateServiceCenter(
                          widget.vendorSCData['scKey'].toString(),
                          widget.vendorSCData['latitude'],
                          widget.vendorSCData['longitude'],
                          widget.vendorSCData['districtkey'],
                          widget.vendorSCData['scName'].toString(),
                          widget.vendorSCData['scContactNo'].toString(),
                          widget.vendorSCData['scEmailId'].toString(),
                          widget.vendorSCData['scFullAdress'].toString(),
                          widget.vendorSCData['scWebsiteUrl']==null ? '' : widget.vendorSCData['scWebsiteUrl'].toString(),
                          widget.vendorSCData['scGoogleMapUrl']==null ? '' : widget.vendorSCData['scGoogleMapUrl'].toString(),
                        )));
                      },
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
}
