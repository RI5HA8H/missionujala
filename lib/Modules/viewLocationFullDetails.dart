
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:missionujala/Modules/updateLocation.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/Utiles/appBar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/drawer.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/toasts.dart';
import '../generated/assets.dart';
import 'complainScreen.dart';


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
  var uIdPhotoPathExtn;
  var uIdScheme;
  var uIdSVTill;

  viewLocationFullDetails(
      this.uIdKey,this.uIdNo,this.uIdMob,this.uIdVillage,
      this.uIdPlace,this.uIdBlock,this.uIdDist,
      this.uIdInstallDate,this.uIdStatus,this.uIdBeniNAme,
      this.uIdFatherName,this.uIdGramPanchayt,this.uIdLati,this.uIdLongi,
      this.uIdPhotoPath,this.uIdPdfPath,this.uIdPhotoPathExtn,this.uIdScheme,this.uIdSVTill,
      );


  @override
  State<viewLocationFullDetails> createState() => _viewLocationFullDetailsState(
    uIdNo,uIdNo,uIdMob,uIdVillage,
    uIdPlace,uIdBlock,uIdDist,
    uIdInstallDate,uIdStatus,uIdBeniNAme,
    uIdFatherName,uIdGramPanchayt,uIdLati,uIdLongi,uIdPhotoPath,uIdPdfPath,uIdPhotoPathExtn,uIdScheme,uIdSVTill,
  );
}

class _viewLocationFullDetailsState extends State<viewLocationFullDetails> {
  _viewLocationFullDetailsState(
      uIdNo,uId,uIdMob,uIdVillage,
      uIdPlace,uIdBlock,uIdDist,
      uIdInstallD,uIdStatus,uIdBeniNAme,
      uIdFatherNa,uIdGramPanc,uIdLati,uIdLongi,uIdPhotoPath,uIdPdfPath,uIdPhotoPathExtn,uIdScheme,uIdSVTill,
      );

  String loginType='';
  late PDFViewController pdfViewController;

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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context,false);
        return false;
      },
      child: Scaffold(
        appBar: appBar(),
        drawer: drawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                color: appcolors.screenBckColor,
                padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
                child: Text(allTitle.viewLocationFullDetails,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: appcolors.primaryColor),),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('UID No : ${widget.uIdNo}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Scheme : ${widget.uIdScheme}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Place : ${widget.uIdPlace}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Mobile No : ${widget.uIdMob.toString()=='null' ? 'N/A' : widget.uIdMob}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: widget.uIdMob.toString()=='null' ? Colors.red : Colors.black),),
                    Divider(),
                    Text('Village : ${widget.uIdVillage}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Block : ${widget.uIdBlock}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('District : ${widget.uIdDist}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Installation Date : ${widget.uIdInstallDate == 'null' ? 'N/A' : convertDateFormat(widget.uIdInstallDate)}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Service Valid till : ${widget.uIdSVTill == 'null' ? 'N/A' : convertDateFormat(widget.uIdSVTill)}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                    Divider(),
                    Text('Status : ${widget.uIdStatus.toString()=='null' ? 'N/A' : widget.uIdStatus}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: widget.uIdStatus.toString()=='null' ? Colors.red : Colors.black),),
                    Divider(),
                    Text('Beneficiary Name : ${widget.uIdBeniNAme.toString()=='null' ? 'N/A' : widget.uIdBeniNAme}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: widget.uIdBeniNAme.toString()=='null' ? Colors.red : Colors.black),),
                    Divider(),
                    Text('Father Name : ${widget.uIdFatherName.toString()=='null' ? 'N/A' : widget.uIdFatherName}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: widget.uIdFatherName.toString()=='null' ? Colors.red : Colors.black),),
                    Divider(),
                    Text('Gram Panchayat : ${widget.uIdGramPanchayt.toString()=='null' ? 'N/A' : widget.uIdGramPanchayt}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: widget.uIdGramPanchayt.toString()=='null' ? Colors.red : Colors.black),),
                    Divider(),
                    Text('Latitude : ${widget.uIdLati.toString()=='null' ? 'N/A' : widget.uIdLati}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: widget.uIdLati.toString()=='null' ? Colors.red : Colors.black),),
                    Divider(),
                    Text('Longitude : ${widget.uIdLongi.toString()=='null' ? 'N/A' : widget.uIdLongi}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: widget.uIdLongi.toString()=='null' ? Colors.red : Colors.black),),
                    Divider(),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height/6,
                              width: MediaQuery.of(context).size.width*0.4,
                              color: Colors.grey[300],
                              child: widget.uIdPhotoPath.toString()=='null' ? Icon(Icons.camera_alt,size: 50,) : Image.network(widget.uIdPhotoPath,width: 70,height: 100,),
                            ),
                          ),
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
                                    child: ExtendedImage.network(
                                      '${widget.uIdPhotoPath}',
                                      fit: BoxFit.contain,
                                      //enableLoadState: false,
                                      mode: ExtendedImageMode.gesture,
                                      initGestureConfigHandler: (state) {
                                        return GestureConfig(
                                          minScale: 0.9,
                                          animationMinScale: 0.7,
                                          maxScale: 3.0,
                                          animationMaxScale: 3.5,
                                          speed: 1.0,
                                          inertialSpeed: 100.0,
                                          initialScale: 1.0,
                                          inPageView: false,
                                          initialAlignment: InitialAlignment.center,
                                        );
                                      },
                                    )
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
                        widget.uIdPhotoPathExtn.toString()=='pdf'
                            ? InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height/6,
                              width: MediaQuery.of(context).size.width*0.4,
                              color: Colors.grey[300],
                              child: widget.uIdPdfPath.toString()=='null' ? Icon(Icons.picture_as_pdf,size: 50,) : Image.asset(Assets.iconsPdfIcons,width: 70,height: 100,),
                            ),
                          ),
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
                        )
                            : InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height/6,
                              width: MediaQuery.of(context).size.width*0.4,
                              color: Colors.grey[300],
                              child: widget.uIdPdfPath.toString()=='null' ? Icon(Icons.camera_alt,size: 50,) : Image.network(widget.uIdPdfPath,width: 70,height: 100,),
                            ),
                          ),
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
                                    child: ExtendedImage.network(
                                      '${widget.uIdPdfPath}',
                                      fit: BoxFit.contain,
                                      //enableLoadState: false,
                                      mode: ExtendedImageMode.gesture,
                                      initGestureConfigHandler: (state) {
                                        return GestureConfig(
                                          minScale: 0.9,
                                          animationMinScale: 0.7,
                                          maxScale: 3.0,
                                          animationMaxScale: 3.5,
                                          speed: 1.0,
                                          inertialSpeed: 100.0,
                                          initialScale: 1.0,
                                          inPageView: false,
                                          initialAlignment: InitialAlignment.center,
                                        );
                                      },
                                    )
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
                      ],
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: appcolors.screenBckColor,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: loginType=='user' ? InkWell(
            child: normalButton(name: 'Report Issue',height:45,bordeRadious: 10,fontSize:14,textColor: Colors.white,bckColor: appcolors.buttonColor,),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => complaintScreen(widget.uIdNo)));
            },
          ) :
          InkWell(
            child: normalButton(name: 'Update Location',height:45,bordeRadious: 10,fontSize:14,textColor: Colors.white,bckColor: appcolors.buttonColor,),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => updateLocation(
                '${widget.uIdNo}',
                '${widget.uIdLati}',
                '${widget.uIdLongi}',

                '${widget.uIdPlace}',
                '${widget.uIdVillage}',
                '${widget.uIdBlock}',
                '${widget.uIdDist}',
                '${widget.uIdSVTill}',
                '${widget.uIdPhotoPath}',

              )));
            },
          ),
        ),
      ),
    );
  }

  String convertDateFormat(String inputDate) {
    // Parse the input date
    DateTime dateTime = DateFormat("dd-MM-yyyy").parse(inputDate);

    // Format the date in the desired format
    String formattedDate = DateFormat("dd-MMM-yy").format(dateTime);

    return formattedDate;
  }
}
