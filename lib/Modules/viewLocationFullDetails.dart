
import 'package:flutter/material.dart';
import 'package:missionujala/Modules/complainScreen.dart';
import 'package:missionujala/Modules/updateLocation.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';


 class viewLocationFullDetails extends StatefulWidget {
  var uIdKey;
  var uIdNo;
  var uIdMob;
  var uIdVillage;
  var uIdPlace;
  var uIdBlock;
  var uIdDist;
  var uIdInstallDate;
  var uIdStatus;
  var uIdBeniNAme;
  var uIdFatherName;
  var uIdGramPanchayt;
  var uIdLati;
  var uIdLongi;
  var uIdPhotoPath;
  var uIdPdfPath;

      viewLocationFullDetails(
        this.uIdKey,this.uIdNo,this.uIdMob,this.uIdVillage,
        this.uIdPlace,this.uIdBlock,this.uIdDist,
        this.uIdInstallDate,this.uIdStatus,this.uIdBeniNAme,
        this.uIdFatherName,this.uIdGramPanchayt,this.uIdLati,this.uIdLongi,
          this.uIdPhotoPath,this.uIdPdfPath,
      );


  @override
  State<viewLocationFullDetails> createState() => _viewLocationFullDetailsState(
    uIdNo,uIdNo,uIdMob,uIdVillage,
    uIdPlace,uIdBlock,uIdDist,
    uIdInstallDate,uIdStatus,uIdBeniNAme,
    uIdFatherName,uIdGramPanchayt,uIdLati,uIdLongi,uIdPhotoPath,uIdPdfPath,
  );
}

class _viewLocationFullDetailsState extends State<viewLocationFullDetails> {
  _viewLocationFullDetailsState(
      uIdNo,uId,uIdMob,uIdVillage,
      uIdPlace,uIdBlock,uIdDist,
      uIdInstallD,uIdStatus,uIdBeniNAme,
      uIdFatherNa,uIdGramPanc,uIdLati,uIdLongi,uIdPhotoPath,uIdPdfPath,
      );

  String loginType='';

  @override
  void initState() {
    getUserToken();
    super.initState();
  }

  getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loginType = prefs.getString('loginType')!;
      print('uuu--${loginType}');
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 30,
        title: Text('${allTitle.viewLocationFullDetails}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('UID No : ${widget.uIdNo}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Place Name : ${widget.uIdPlace}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Mobile No : ${widget.uIdMob.toString()=='null' ? 'N/A' : widget.uIdMob}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Village Name : ${widget.uIdVillage}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Block Name : ${widget.uIdBlock}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('District Name : ${widget.uIdDist}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Installation Date : ${widget.uIdInstallDate}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Status : ${widget.uIdStatus.toString()=='null' ? 'N/A' : widget.uIdStatus}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Beneficiary Name : ${widget.uIdBeniNAme.toString()=='null' ? 'N/A' : widget.uIdBeniNAme}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Father Name : ${widget.uIdFatherName.toString()=='null' ? 'N/A' : widget.uIdFatherName}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Gram Panchayat : ${widget.uIdGramPanchayt.toString()=='null' ? 'N/A' : widget.uIdGramPanchayt}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Latitude : ${widget.uIdLati.toString()=='null' ? 'N/A' : widget.uIdLati}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              Text('Longitude : ${widget.uIdLongi.toString()=='null' ? 'N/A' : widget.uIdLongi}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
              Divider(),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Image.asset('assets/icons/imgIcon.png',width: 50,height: 50,),
                    onTap: () async{
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
                            child: Image.network('${widget.uIdPhotoPath}',),
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
                    },
                  ),
                  InkWell(
                    child: Image.asset('assets/icons/browser.png',width: 50,height: 50,),
                    onTap: () async {
                      var url='${widget.uIdPdfPath}';
                      var urllaunchable = await canLaunch(url);
                      if(urllaunchable){
                        await launchUrl(Uri.parse(url));
                        setState(() {});
                      }else{
                        print("URL can't be launched.");
                        toasts().redToastLong("Documents not found");
                      }
                    },
                  ),
                ],
              ),
        
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey[100],
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: loginType=='user' ? InkWell(
          child: normalButton(name: 'Report Issue',height:45,bordeRadious: 10,fontSize:14,textColor: Colors.black,bckColor: appcolors.primaryTextColor,),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => complaintScreen(widget.uIdNo)));
          },
        ) :
        InkWell(
          child: normalButton(name: 'Update Location',height:45,bordeRadious: 10,fontSize:14,textColor: Colors.black,bckColor: appcolors.primaryTextColor,),
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => updateLocation(
              '${widget.uIdNo}',
              '${widget.uIdLati}',
              '${widget.uIdLongi}',
            )));
          },
        ),
      ),
    );
  }
}
