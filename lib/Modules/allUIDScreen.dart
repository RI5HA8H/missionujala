

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
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/bottomNavigationBar.dart';
import '../Resource/Utiles/drawer.dart';
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
  bool enableScroll=false;
  String userToken='';
  String companyKey='';
  String districtKey='';
  String purchaseOrderKey='';


  var financialTypeItem = [];
  var schemsTypeItem = [];
  var purchaseTypeItem = [];
  var districtsTypeItem = [];
  var blocksTypeItem = [];
  var villagesTypeItem = [];

  var financialDropdownValue;
  var schemsDropdownValue;
  var purchaseDropdownValue;
  var districtsDropdownValue;
  var blocksDropdownValue;
  var villagesDropdownValue;

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
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar(),
        drawer: drawer(),
        body: scroll1 ? Center(child: CircularProgressIndicator()) : Container(
          child: NestedScrollView(
            // The headerSliverBuilder callback defines the sliver widgets in the header
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                // SliverAppBar is the header that remains visible while scrolling
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height*0.6,
                  floating: false,
                  elevation: 0,
                  forceElevated: true,
                  pinned: false,
                  shadowColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Container(
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
                                menuItemStyleData: MenuItemStyleData(
                                  height: 40,
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

                                    schemsTypeItem.clear();
                                    purchaseTypeItem.clear();
                                    districtsTypeItem.clear();
                                    blocksTypeItem.clear();
                                    villagesTypeItem.clear();

                                    schemsDropdownValue=null;
                                    purchaseDropdownValue=null;
                                    districtsDropdownValue=null;
                                    blocksDropdownValue=null;
                                    villagesDropdownValue=null;

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
                                menuItemStyleData: MenuItemStyleData(
                                  height: 40,
                                ),
                                items: schemsTypeItem.map((item2) {
                                  return DropdownMenuItem(
                                    value: item2['schemeKey'],
                                    child: Container(width: MediaQuery.of(context).size.width/1.3,child: Text(item2['schemeName'],style: TextStyle(fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                  );
                                }).toList(),
                                onChanged: (newVal2) {
                                  setState(() {
                                    schemsDropdownValue = newVal2;
                                    print('llllllllll----$schemsDropdownValue');

                                    purchaseTypeItem.clear();
                                    districtsTypeItem.clear();
                                    blocksTypeItem.clear();
                                    villagesTypeItem.clear();

                                    purchaseDropdownValue=null;
                                    districtsDropdownValue=null;
                                    blocksDropdownValue=null;
                                    villagesDropdownValue=null;

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
                                menuItemStyleData: MenuItemStyleData(
                                  height: 40,
                                ),
                                items: purchaseTypeItem.map((item3) {
                                  return DropdownMenuItem(
                                    value: item3['podKey'].toString()+'_'+item3['purchaseOrderKey'].toString(),
                                    child: Container(width: MediaQuery.of(context).size.width/1.3,child: Text(item3['orderNo'],style: TextStyle(fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                  );
                                }).toList(),
                                onChanged: (newVal3) {
                                  setState(() {
                                    enableScroll=true;
                                    purchaseDropdownValue = newVal3.toString();
                                    purchaseOrderKey=purchaseDropdownValue.toString().split('_')[1];
                                    print('llllllllll----$purchaseOrderKey');

                                    districtsTypeItem.clear();
                                    blocksTypeItem.clear();
                                    villagesTypeItem.clear();

                                    districtsDropdownValue=null;
                                    blocksDropdownValue=null;
                                    villagesDropdownValue=null;

                                    getDistricts();
                                  });
                                },
                                value: enableScroll ? purchaseDropdownValue : null,
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
                                hint: Text('Select District',style: TextStyle(fontSize: 12,),),
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
                                menuItemStyleData: MenuItemStyleData(
                                  height: 40,
                                ),
                                items: districtsTypeItem.map((item4) {
                                  return DropdownMenuItem(
                                    value: item4['districtKey'],
                                    child: Container(width: MediaQuery.of(context).size.width/2,child: Text(item4['districtName'],style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                  );
                                }).toList(),
                                onChanged: (newVal4) {
                                  setState(() {
                                    districtsDropdownValue = newVal4;
                                    print('llllllllll----$districtsDropdownValue');

                                    blocksTypeItem.clear();
                                    villagesTypeItem.clear();

                                    blocksDropdownValue=null;
                                    villagesDropdownValue=null;

                                    getBlocks();
                                  });
                                },
                                value: districtsDropdownValue,
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
                                hint: Text('Select Area',style: TextStyle(fontSize: 12,),),
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
                                menuItemStyleData: MenuItemStyleData(
                                  height: 40,
                                ),
                                items: blocksTypeItem.map((item5) {
                                  return DropdownMenuItem(
                                    value: item5['blockKey'],
                                    child: Container(width: MediaQuery.of(context).size.width/2,child: Text(item5['blockName'],style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                  );
                                }).toList(),
                                onChanged: (newVal5) {
                                  setState(() {
                                    blocksDropdownValue = newVal5;
                                    print('llllllllll----$blocksDropdownValue');

                                    villagesTypeItem.clear();

                                    villagesDropdownValue=null;

                                    getVillages();
                                  });
                                },
                                value: blocksDropdownValue,
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
                                hint: Text('Select Village',style: TextStyle(fontSize: 12,),),
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
                                menuItemStyleData: MenuItemStyleData(
                                  height: 40,
                                ),
                                items: villagesTypeItem.map((item6) {
                                  return DropdownMenuItem(
                                    value: item6['villageName'],
                                    child: Container(width: MediaQuery.of(context).size.width/2,child: Text(item6['villageName'],style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                  );
                                }).toList(),
                                onChanged: (newVal6) {
                                  setState(() {
                                    villagesDropdownValue = newVal6;
                                    print('llllllllll----$villagesDropdownValue');
                                  });
                                },
                                value: villagesDropdownValue,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          InkWell(
                            child: normalButton(name: 'Search',height:45,bordeRadious: 20,fontSize:14,textColor: Colors.white,bckColor: appcolors.greenTextColor,),
                            onTap: (){
                              setState(() {
                                if(financialDropdownValue==null || schemsDropdownValue==null || purchaseDropdownValue==null || districtsDropdownValue==null ){
                                  toasts().redToastLong('Proper fill the datails');
                                }else{
                                  getInstalledList();
                                }
                              });
                            },
                          ),
                          SizedBox(height: 10,),

                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: MySliverPersistentHeaderDelegate(
                    minHeight: 50.0,
                    maxHeight: 50.0,
                    child: Container(
                      color: appcolors.whiteColor,
                      child: TabBar(
                        labelColor: appcolors.primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),
                        tabs: [
                          Tab(text: 'Pending'),
                          Tab(text: 'Corrected'),
                        ],
                      ),
                    ),
                  ),
                )
              ];
            },
            // The body contains the scrollable content
            body:  Container(
              color: appcolors.screenBckColor,
              padding: EdgeInsets.only(top: 10),
              child: TabBarView(
                children: [
                  ListView.builder(
                    /*shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),*/
                      itemCount: installedSystemList.length,
                      itemBuilder: (BuildContext context, int index) => getRow1(index, context)
                  ),
                  ListView.builder(
                    /*shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),*/
                      itemCount: installedSystemList.length,
                      itemBuilder: (BuildContext context, int index) => getRow2(index, context)
                  ),
                ],
              ),
            ),
          ),
        ),
       // bottomNavigationBar: bottomNavigationBar(1),
      ),
    );
  }

  Widget getRow2(int index,var snapshot) {
    return installedSystemList[index]['isCorrect_LatLong']==true ? Container(
      padding: EdgeInsets.fromLTRB(10,0,10,5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.green[100],
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

                          Text('UID No.: ${installedSystemList[index]['uidNo']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
                          Text('Installation Date : ${installedSystemList[index]['installationDate']}',style: TextStyle(fontSize: 14,color: Colors.black)),
                          Text('${installedSystemList[index]['placeName']},${installedSystemList[index]['villageName']}',style: TextStyle(fontSize: 12,color: Colors.black)),
                        ],
                      )
                  ),
                  onTap: () async {

                    final updateUid=await Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocationFullDetails(
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
                      installedSystemList[index]['formatPath1Extn'],
                      installedSystemList[index]['schemeName'],
                      installedSystemList[index]['serviceValidTill'],
                    )));
                    print('uuuuuuuuuuuuuuu-->$updateUid');

                    if(updateUid != null){
                      getInstalledList();
                    }

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
    ) : Container();
  }


  Widget getRow1(int index,var snapshot) {
    return installedSystemList[index]['isCorrect_LatLong']==true ? Container() : Container(
      padding: EdgeInsets.fromLTRB(10,0,10,5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.white,
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

                          Text('UID No.: ${installedSystemList[index]['uidNo']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),),
                          Text('Installation Date : ${installedSystemList[index]['installationDate']}',style: TextStyle(fontSize: 14,color: Colors.black)),
                          Text('${installedSystemList[index]['placeName']},${installedSystemList[index]['villageName']}',style: TextStyle(fontSize: 12,color: Colors.black)),
                        ],
                      )
                  ),
                  onTap: () async {
                    bool updateUid= false;
                    updateUid=await Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocationFullDetails(
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
                      installedSystemList[index]['formatPath1Extn'],
                      installedSystemList[index]['schemeName'],
                      installedSystemList[index]['serviceValidTill'],
                    )));
                    print('uuuuuuuuuuuuuuu-->$updateUid');

                    if(updateUid == true){
                      getInstalledList();
                    }

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

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().schemesByFYURL+'/$financialDropdownValue/$companyKey'));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${urls().base_url + allAPI().schemesByFYURL+'/$financialDropdownValue/$companyKey'}');
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

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().pusrchaseOrderBySFYURL+'/$schemsDropdownValue/$companyKey/$financialDropdownValue'));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${urls().base_url + allAPI().pusrchaseOrderBySFYURL}');
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

  Future<void> getDistricts() async {
    setState(() {scroll1 = true;});

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().disctrictByPOURL+'/$purchaseOrderKey'));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      districtsTypeItem=results;
      if(districtsTypeItem.isEmpty){
        toasts().redToastLong('District Not Found');
      }
      setState(() {scroll1 = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll1 = false;});
    }
  }

  Future<void> getBlocks() async {
    setState(() {scroll1 = true;});

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().blockByDPOURL+'/$purchaseOrderKey/$districtsDropdownValue'));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      blocksTypeItem=results;
      if(blocksTypeItem.isEmpty){
        toasts().redToastLong('Block Not Found');
      }
      setState(() {scroll1 = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll1 = false;});
    }
  }

  Future<void> getVillages() async {
    setState(() {scroll1 = true;});

    var headers = {
      'Authorization': 'Bearer $userToken'
    };

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().villageByDBPO+'/$purchaseOrderKey/$districtsDropdownValue/$blocksDropdownValue'));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print(await 'aaaaaaaaa-----${results}');
      villagesTypeItem=results;
      if(villagesTypeItem.isEmpty){
        toasts().redToastLong('Village Not Found');
      }
      setState(() {scroll1 = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll1 = false;});
    }
  }


  Future<void> getInstalledList() async {
    setState(() {scroll1 = true;});

    if(villagesDropdownValue==null){
      villagesDropdownValue='Select Village';
    }
    if(blocksDropdownValue==null){
      blocksDropdownValue=0;
    }

    var headers = {
      'Authorization': 'Bearer $userToken'
    };
    debugPrint(await 'aaaaaaaaa-----${urls().base_url + allAPI().installedAllListURL+'/$purchaseOrderKey/$districtsDropdownValue/$blocksDropdownValue/$villagesDropdownValue'}');

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().installedAllListURL+'/$purchaseOrderKey/$districtsDropdownValue/$blocksDropdownValue/$villagesDropdownValue'));
    request.headers.addAll(headers);
    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      installedSystemList=results['installedSystemList'];
      totalSystemCount= results['totalSytemCount'];
      installedSystemCount= results['installedSytemCount'];
      setState(() {scroll1 = false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll1 = false;});
    }
  }

}
class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  MySliverPersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}