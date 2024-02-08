

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:missionujala/Modules/viewLocationFullDetails.dart';
import 'package:missionujala/Modules/viewLocations.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';




class allUIDScreen extends StatefulWidget {
  const allUIDScreen({super.key});

  @override
  State<allUIDScreen> createState() => _allUIDScreenState();
}

class _allUIDScreenState extends State<allUIDScreen> {

  bool scroll=false;
  bool scroll1=false;
  String userToken='';
  String companyKey='';
  String districtKey='';
  var financialTypeItem = [];
  var schemsTypeItem = [];
  var purchaseTypeItem = [];
  var financialDropdownValue;
  var schemsDropdownValue;
  var purchaseDropdownValue;

  var installedSystemList=[];
  int totalSystemCount=0;
  int installedSystemCount=0;


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
      districtKey = prefs.getString('vendorDistrictKey')!;
    });
    getFinancialYear();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => viewLocations()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 30,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              SizedBox(width: 5 ,),
              GestureDetector(
                child: Icon(Icons.arrow_back_sharp),
                onTap: (){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => viewLocations()), (Route<dynamic> route) => false);
                },
              ),
              SizedBox(width: 10,),
              Text('${allTitle.allUIDModules}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
            ],
          ),
        ),
        body: Container(
          color: appcolors.screenBckColor,
          child: scroll1 ? Center(child: CircularProgressIndicator()) : Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  children: [
                    SizedBox(height: 15,),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xffC5C5C5),
                          width: 0.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Text('Select Financial Year',style: TextStyle(fontSize: 12,),),
                          iconStyleData: IconStyleData(
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Icon(Icons.keyboard_arrow_down),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            elevation: 1,
                            maxHeight: MediaQuery.of(context).size.height/2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[50],
                            ),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                          ),
                          items: financialTypeItem.map((item1) {
                            return DropdownMenuItem(
                              value: item1['finYear'],
                              child: Container(width: MediaQuery.of(context).size.width/2,child: Text(item1['finYear'],style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                            );
                          }).toList(),
                          onChanged: (newVal1) {
                            setState(() {
                              financialDropdownValue = newVal1;
                              print('llllllllll----$financialDropdownValue');
                              schemsTypeItem.isEmpty;
                              purchaseTypeItem.isEmpty;
                              schemsDropdownValue=null;
                              purchaseDropdownValue=null;
                              getSchemes();
                            });
                          },
                          value: financialDropdownValue,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xffC5C5C5),
                          width: 0.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Text('Select Scheme',style: TextStyle(fontSize: 12,),),
                          iconStyleData: IconStyleData(
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Icon(Icons.keyboard_arrow_down),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            elevation: 1,
                            maxHeight: MediaQuery.of(context).size.height/2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[50],
                            ),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                          ),
                          items: schemsTypeItem.map((item1) {
                            return DropdownMenuItem(
                              value: item1['schemeKey'],
                              child: Container(width: MediaQuery.of(context).size.width/1.3,child: Text(item1['schemeName'],style: TextStyle(fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                            );
                          }).toList(),
                          onChanged: (newVal1) {
                            setState(() {
                              schemsDropdownValue = newVal1;
                              print('llllllllll----$schemsDropdownValue');
                              purchaseTypeItem.isEmpty;
                              purchaseDropdownValue=null;
                              getPurchaseOrder();
                            });
                          },
                          value: schemsDropdownValue,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Color(0xffC5C5C5),
                          width: 0.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Text('Select Purchase Order',style: TextStyle(fontSize: 12,),),
                          iconStyleData: IconStyleData(
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Icon(Icons.keyboard_arrow_down),
                            ),
                          ),
                          dropdownStyleData: DropdownStyleData(
                            elevation: 1,
                            maxHeight: MediaQuery.of(context).size.height/2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.grey[50],
                            ),
                          ),
                          buttonStyleData: ButtonStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                          ),
                          items: purchaseTypeItem.map((item1) {
                            return DropdownMenuItem(
                              value: item1['purchaseOrderKey'],
                              child: Container(width: MediaQuery.of(context).size.width/1.3,child: Text(item1['orderNo'],style: TextStyle(fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                            );
                          }).toList(),
                          onChanged: (newVal1) {
                            setState(() {
                              purchaseDropdownValue = newVal1;
                              print('llllllllll----$purchaseDropdownValue');

                            });
                          },
                          value: purchaseDropdownValue,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      child: normalButton(name: 'Search',height:45,bordeRadious: 20,fontSize:14,textColor: Colors.black,bckColor: appcolors.primaryTextColor,),
                      onTap: (){
                        setState(() {
                          if(financialDropdownValue==null || schemsDropdownValue==null || purchaseDropdownValue==null){
                            toasts().redToastLong('Proper fill the datails');
                          }else{
                            getInstalledList();
                          }
                        });
                      },
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Total System Count : $totalSystemCount',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black),),
                          Text('Installed System Count : $installedSystemCount',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.black),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
              Expanded(
                child: scroll ? Center(child: LoadingAnimationWidget.waveDots(color: appcolors.primaryColor, size: 50))
                    : ListView.builder(
                    itemCount: installedSystemList.length,
                    itemBuilder: (BuildContext context, int index) => getRow(index, context)
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget getRow(int index,var snapshot) {
    return Container(
      padding: EdgeInsets.fromLTRB(20,0,20,5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: installedSystemList[index]['isCorrect_LatLong']==true ? Colors.green[100] : Colors.white,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('UID Number : ${installedSystemList[index]['uidNo']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
                        Text('Installation Date : ${installedSystemList[index]['installationDate']}',style: TextStyle(fontSize: 14,color: Colors.black)),
                        Text('${installedSystemList[index]['placeName']},${installedSystemList[index]['villageName']}',style: TextStyle(fontSize: 12,color: Colors.black)),
                      ],
                    )
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocationFullDetails(
                        installedSystemList[index]['uidKey'],
                        installedSystemList[index]['uidNo'],
                        installedSystemList[index]['mobileNo'],
                        installedSystemList[index]['villageName'],
                        installedSystemList[index]['placeName'],
                        installedSystemList[index]['blockName'],
                        installedSystemList[index]['districtName'],
                        installedSystemList[index]['installationDate'],

                        installedSystemList[index]['status'],
                        installedSystemList[index]['beneficiaryName'],
                        installedSystemList[index]['fatherName'],
                        installedSystemList[index]['gramPanchayat'],
                        installedSystemList[index]['latitude'],
                        installedSystemList[index]['longitude'],
                        installedSystemList[index]['photoPath'],
                        installedSystemList[index]['formatPath1'],
                    )));

                  },
                ),
              ),
              Positioned(
                child: '${installedSystemList[index]['latitude']}' == 'null' ? Container() : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/icons/isMapMarker.png',width: 20,height: 20,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<void> getFinancialYear() async {
    setState(() {scroll1 = true;});

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().financialYearURL));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      financialTypeItem=results;
      setState(() {scroll1 = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll1 = false;});
    }
  }

  Future<void> getSchemes() async {
    setState(() {scroll1 = true;});

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().schemesURL+'/$financialDropdownValue/$companyKey/$districtKey'));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${urls().base_url + allAPI().schemesURL+'/$financialDropdownValue/$companyKey/$districtKey'}');
      print(await 'aaaaaaaaa-----${results}');
      schemsTypeItem=results;
      if(schemsTypeItem.isEmpty){
        toasts().redToastLong('Scheme Not Found');
      }
      setState(() {scroll1 = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll1 = false;});
    }
  }

  Future<void> getPurchaseOrder() async {
    setState(() {scroll1 = true;});

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().pusrchaseOrderURL+'/$schemsDropdownValue/$companyKey/$districtKey/$financialDropdownValue'));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      purchaseTypeItem=results;
      if(purchaseTypeItem.isEmpty){
        toasts().redToastLong('Purchase Order Not Found');
      }
      setState(() {scroll1 = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll1 = false;});
    }
  }


  Future<void> getInstalledList() async {
    setState(() {scroll = true;});

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().installedAllListURL+'/$purchaseDropdownValue/$districtKey'));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${urls().base_url + allAPI().installedAllListURL+'/$purchaseDropdownValue/$districtKey'}');
      installedSystemList=results['installedSystemList'];
      totalSystemCount= results['totalSytemCount'];
      installedSystemCount= results['installedSytemCount'];
      setState(() {scroll = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll = false;});
    }
  }
}
