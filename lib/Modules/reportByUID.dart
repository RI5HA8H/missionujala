


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:missionujala/Modules/viewLocationFullDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Resource/Colors/app_colors.dart';
import '../Resource/StringLocalization/allAPI.dart';
import '../Resource/StringLocalization/baseUrl.dart';
import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';



class reportByUID extends StatefulWidget {
  const reportByUID({super.key});

  @override
  State<reportByUID> createState() => _reportByUIDState();
}

class _reportByUIDState extends State<reportByUID> {


  String userToken='';
  String companyKey='';
  bool scroll=false;
  var uidDetails = [];

  String query = '';
  final filterController = TextEditingController();
  FocusNode filterFocusNode = FocusNode();
  final ScrollController scrollController=ScrollController();





  @override
  void initState(){
    super.initState();
    getUserToken();
  }


  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

  }





  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = query.isEmpty ? styleHint : styleActive;
    return Scaffold(
        appBar: appBar(),
        drawer: drawer(),
        body: scroll ? Center(child: CircularProgressIndicator()) : Container(
          color: appcolors.whiteColor,
          child: Container(
            padding: EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Container(
                  color: appcolors.screenBckColor,
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  alignment: Alignment.centerLeft,
                  child: Text('Register Complaint By UID',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: appcolors.primaryColor),maxLines: 2,),
                ),

                Container(
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(10, 16, 10, 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                  ),
                  padding: const EdgeInsets.only(left: 15),
                  child: TextFormField(
                    style: style,
                    keyboardType: TextInputType.number,
                    controller: filterController,
                    focusNode: filterFocusNode,
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: style.color),
                      suffixIcon: query.isNotEmpty
                          ? GestureDetector(
                        child: Icon(Icons.close, color: style.color),
                        onTap: () {
                          filterController.clear();
                          query='';
                          filterFocusNode.unfocus();
                        },
                      ) : null,
                      hintText: 'Search UID',
                      hintStyle: style,
                      border: InputBorder.none,
                      contentPadding: query.isNotEmpty
                          ? EdgeInsets.only(top: 12)
                          : EdgeInsets.all(0),
                    ),
                    onChanged: (String? value){
                      setState(() {
                        query=value.toString();
                      });
                    },
                  ),
                ),

                SizedBox(height: 20,),

                Container(
                  padding: EdgeInsets.all(10),
                  child: InkWell(
                    child: normalButton(name: 'Search',height:50,bordeRadious: 5,fontSize:16,textColor: Colors.white,bckColor: appcolors.buttonColor,width: 160,),
                    onTap: (){
                      filterFocusNode.unfocus();
                      if(filterController.text.isEmpty){
                        toasts().redToastLong('Please enter uid');
                      }else{
                        getUidDetailsApi();
                      }

                    },
                  ),
                )

              ],
            ),
          ),
        )
    );
  }


  Future<void> getUidDetailsApi() async{
    setState(() {scroll = true;});

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getDataByUID1URL+'/${filterController.text}'));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      setState(() {scroll = false;});
      toasts().greenToastLong('Successfull');

      bool updateUid= false;
      updateUid=await Navigator.of(context).push(MaterialPageRoute(builder: (context) => viewLocationFullDetails(
        '${results['uidKey']}',
        '${results['uidNo']}',
        '${results['mobileNo']}',
        '${results['villageName']}',
        '${results['placeName']}',
        '${results['blockName']}',
        '${results['districtName']}',
        '${results['installationDate']}',

        '${results['status']}',
        '${results['beneficiaryName']}',
        '${results['fatherName']}',
        '${results['gramPanchayat']}',
        '${results['latitude']}',
        '${results['longitude']}',
        '${results['photoPath']}',
        '${results['formatPath1']}',
        '${results['formatPath1Extn']}',
        '${results['schemeName']}',
        '${results['serviceValidTill']}',
        '${results['companyName']}',
        '${results['isCorrect_LatLong']}',
      )));

    }
    else {
      if (response.statusCode == 404) {
        setState(() {scroll = false;});
        toasts().redToastLong('Uid Not Found');
      }
      else {
        toasts().redToastLong('Server Error');
        setState(() {scroll = false;});
      }
    }
  }

}
