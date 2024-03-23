

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/Resource/Utiles/allFunctions.dart';
import 'package:missionujala/Resource/Utiles/normalButton.dart';
import 'package:missionujala/homeScreen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Modules/viewLocations.dart';
import 'Resource/StringLocalization/allAPI.dart';
import 'Resource/StringLocalization/baseUrl.dart';
import 'Resource/StringLocalization/titles.dart';
import 'Resource/Utiles/appBar.dart';
import 'Resource/Utiles/bottomNavigationBar.dart';
import 'Resource/Utiles/drawer.dart';
import 'Resource/Utiles/dropDown.dart';
import 'Resource/Utiles/editText.dart';
import 'Resource/Utiles/simpleEditText.dart';
import 'Resource/Utiles/toasts.dart';
import 'loginDashboard.dart';


class userProfile extends StatefulWidget {
  const userProfile({super.key});

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {


  bool scroll=false;

  String uvUserName  = '';
  String uvContactName  = '';
  String uvMobileNo  = '';
  String uvEmail  = '';
  String uvDistrict  = '';
  String uvAddress  ='';
  String uvImage  = '';
  String loginType='';
  String uvKey='';

  var allUVData;

  File? galleryFile;
  final picker = ImagePicker();

  var districtDropdownValue;
  var districtTypeItem=[];


  TextEditingController uvUserNameController = TextEditingController();
  TextEditingController uvContactNameController = TextEditingController();
  TextEditingController uvEmailController = TextEditingController();
  TextEditingController uvAddressController = TextEditingController();

  FocusNode uvUserNameFocusNode = FocusNode();
  FocusNode uvContactNameFocusNode = FocusNode();
  FocusNode uvEmailFocusNode = FocusNode();
  FocusNode uvAddressFocusNode = FocusNode();



  @override
  void initState() {
    getDistrict();
    getUserName();
    super.initState();
  }


  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      loginType = prefs.getString('loginType')!;

      if(loginType=='user'){
        uvKey = prefs.getString('userKey')!;
      }else{
        uvKey = prefs.getString('vendorKey')!;
      }

      getProfileApi();

    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => homeScreen()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        appBar: appBar(),
        drawer: drawer(),
        body: scroll ? Center(child: CircularProgressIndicator()) : Container(
          width: double.infinity,
          //color: appcolors.screenBckColor,
          child: Column(
            children: [

              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20,40, 20, 10),
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.only(left: 20,right: 30),
                            child:  GestureDetector(
                              child: CircleAvatar(
                                radius: 56,
                                backgroundColor: appcolors.greenTextColor,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 55,
                                      backgroundColor: Colors.grey,
                                      child:ClipOval(child: Image.network('${uvImage}',fit: BoxFit.cover,height: 100,width: 100,),),
                                    ),
                                    Positioned(
                                      right: 10,
                                      child: CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.grey[200],
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: (){
                                _showPicker(context: context);
                              },
                            ),
                          ),

                          SizedBox(height: 50,),

                          getRow('Name','${uvContactName}'),
                          divider(),

                          getRow('Mobile No','${uvMobileNo}'),
                          divider(),

                          getRow('Email','${uvEmail}'),
                          divider(),

                          getRow('District','${uvDistrict}'),
                          divider(),

                          getRow('Address','${uvAddress}'),
                          divider(),


                          SizedBox(height: 20,),

                          loginType=='user' ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                child: normalButton(name: 'Logout',height: 40,width: MediaQuery.of(context).size.width/2.5,),
                                onTap: () async {
                                  Alert(
                                    context: context,
                                    type: AlertType.none,
                                    style: AlertStyle(
                                      descStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                                      descPadding: EdgeInsets.all(5),
                                      titlePadding: EdgeInsets.all(5),
                                      descTextAlign: TextAlign.start,
                                      titleTextAlign: TextAlign.start,
                                      titleStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
                                    ),
                                    title: 'Logout',
                                    desc: 'Are you sure, do you want to logout?',
                                    buttons: [
                                      DialogButton(
                                        color: Colors.redAccent[200],
                                        child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 14),),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      DialogButton(
                                        color: Colors.green[500],
                                        child: Text("Confirm", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 14),),
                                        onPressed: () async {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setString('userToken', '');
                                          prefs.setString('loginType', '');
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => loginDashboard()), (Route<dynamic> route) => false);
                                        },
                                      ),
                                    ],
                                  ).show();
                                },
                              ),
                              GestureDetector(
                                child: normalButton(name: 'Edit',height: 40,width: MediaQuery.of(context).size.width/2.5,),
                                onTap: (){
                                  _showEditDialog(context);
                                },
                              )
                            ],
                          ) : GestureDetector(
                            child: normalButton(name: 'Logout',height: 40,),
                            onTap: () async {
                              Alert(
                                context: context,
                                type: AlertType.none,
                                style: AlertStyle(
                                  descStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                                  descPadding: EdgeInsets.all(5),
                                  titlePadding: EdgeInsets.all(5),
                                  descTextAlign: TextAlign.start,
                                  titleTextAlign: TextAlign.start,
                                  titleStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
                                ),
                                title: 'Logout',
                                desc: 'Are you sure, do you want to logout?',
                                buttons: [
                                  DialogButton(
                                    color: Colors.redAccent[200],
                                    child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 14),),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  DialogButton(
                                    color: Colors.green[500],
                                    child: Text("Confirm", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 14),),
                                    onPressed: () async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      prefs.setString('userToken', '');
                                      prefs.setString('loginType', '');
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => loginDashboard()), (Route<dynamic> route) => false);
                                    },
                                  ),
                                ],
                              ).show();
                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavigationBar(3),
      ),
    );
  }

  Widget getRow(String name,String value) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width*.3,
            child: Text('$name :',style: const TextStyle(fontSize: 12,color:appcolors.blackColor)),
          ),
          Container(
              width: MediaQuery.of(context).size.width*.5,
              child: Text(value,style: const TextStyle(fontSize: 12,color:appcolors.blackColor,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 2,)
          ),

        ],
      ),
    );
  }

  Widget divider(){
    return Container(
      padding:EdgeInsets.only(left: 8,right: 8),
      child: IntrinsicHeight(
        child: Divider(
          thickness: 1,
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Future<void> getProfileApi() async {
    setState(() {scroll=true;});
    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().getUVProfileURL+'/$uvKey/$loginType'));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      debugPrint(await 'aaaaaaaaa-----${results}');
      allUVData=results;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profileImg', results['profilePic']);

      uvContactName=results['userName']=='' ? '' : allFunctions().decryptStringFromBase64(results['userName']);
      uvContactName=results['userContactName']=='' ? 'N/A' : allFunctions().decryptStringFromBase64(results['userContactName']);
      uvMobileNo=results['mobileNo']=='' ? 'N/A' : allFunctions().decryptStringFromBase64(results['mobileNo']);
      uvEmail=results['emailId']=='' ? 'N/A' : allFunctions().decryptStringFromBase64(results['emailId']);
      uvDistrict=results['districtName']=='' ? 'N/A' : allFunctions().decryptStringFromBase64(results['districtName']);
      uvAddress=results['userAddress']=='' ? 'N/A' : allFunctions().decryptStringFromBase64(results['userAddress']);
      //debugPrint('ppppp${allFunctions().decryptStringFromBase64('8s8ixdg9KOTDiTHg/Z0qQupOmUthnQix4c3pIn0Ia0yRiVaHg7AGhkA5AZRtI9ZedbSCY+hw2OMEyMxiWAnKYGim9NnlsLXVXpipC6BKnvskB790Rf7soO5F4w+IgmWd')}');
      uvImage=results['profilePic']=='' ? 'https://cdn-icons-png.flaticon.com/512/219/219983.png' : results['profilePic'];

      uvUserNameController.text=results['userName']=='' ? '' : allFunctions().decryptStringFromBase64(results['userName']);
      uvContactNameController.text=results['userContactName']=='' ? '' : allFunctions().decryptStringFromBase64(results['userContactName']);
      uvEmailController.text=results['emailId']=='' ? '' : allFunctions().decryptStringFromBase64(results['emailId']);
      uvAddressController.text=results['userAddress']=='' ? '' : allFunctions().decryptStringFromBase64(results['userAddress']);
      //districtDropdownValue=allFunctions().decryptStringFromBase64(results['districtKey']);

      setState(() {scroll=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }

  void _showPicker({required BuildContext context,}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img,) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    if (xfilePick != null) {
      galleryFile = File(pickedFile!.path);

       await uploadPicToAPI();

    } else {
      toasts().redToastShort('Nothing is selected');
    }
  }

  Future<String?> compressImage(File file) async {
    try {
      final compressedFile = await FlutterNativeImage.compressImage(
          file.path,
          quality: 50,
          percentage: 50
      );
      return compressedFile.path;
    } catch (e) {
      return null;
    }
  }

  Future<void> uploadPicToAPI() async {
    setState(() {scroll = true;});

    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().updatePicURL));
    request.fields.addAll({
      'UserKey': '$uvKey',
      'Type': '$loginType'
    });
    galleryFile == null ?  debugPrint('') : request.files.add(await http.MultipartFile.fromPath('FilePhoto','${await compressImage(galleryFile!)}'),);


    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      //debugPrint(await 'aaaaaaaaa-----${results}');
      if (results['statusCode'] == 'MU501') {
        setState(() {scroll = false;});
        getProfileApi();
        toasts().greenToastShort(results['statusMsg']);
      } else {
        setState(() {scroll = false;});
        toasts().redToastShort('Please Try Again');
      }
    }else{
      setState(() {scroll = false;});
      toasts().redToastShort('Server Error');
    }
  }

  Future<void> getDistrict() async {
    setState(() {scroll=true;});

    var request = http.Request('GET', Uri.parse(urls().base_url + allAPI().disctrictURL));

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      //debugPrint(await 'aaaaaaaaa-----${results}');
      districtTypeItem=results;
      setState(() {scroll=false;});
    }
    else {
      toasts().redToastLong('Server Error');
      setState(() {scroll=false;});
    }
  }


  Future<void> uploadProfileAPI() async {
    setState(() {scroll = true;});

    //debugPrint('lyname-${allFunctions().encryptToBase64(loginType)}');
    //debugPrint('uname-${allFunctions().encryptToBase64(uvUserNameController.text)}');
    //debugPrint('cname-${allFunctions().encryptToBase64(uvContactNameController.text)}');
    //debugPrint('ename-${allFunctions().encryptToBase64(uvEmailController.text)}');
    //debugPrint('aname-${allFunctions().encryptToBase64(uvAddressController.text)}');

    //debugPrint('dkname-${districtDropdownValue.toString()}');


    var request = http.MultipartRequest('POST', Uri.parse(urls().base_url + allAPI().updateProfileURL));
    request.fields.addAll({
      'UserKey': '${int.parse(uvKey.toString())}',
      'Type': '${allFunctions().encryptToBase64(loginType)}',
      'EmailId': '${allFunctions().encryptToBase64(uvEmailController.text)}',
      'UserAddress': '${allFunctions().encryptToBase64(uvAddressController.text)}',
      'UserName': '${allFunctions().encryptToBase64(uvUserNameController.text)}',
      'UserContactName': '${allFunctions().encryptToBase64(uvContactNameController.text)}',
      'DistrictKey': '${int.parse(districtDropdownValue.toString())}'
    });

    var response = await request.send();
    var results = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      //debugPrint(await 'aaaaaaaaa-----${results}');
      if (results['statusCode'] == 'MU501') {
        setState(() {scroll = false;});
        getProfileApi();
        toasts().greenToastShort(results['statusMsg']);
      } else {
        setState(() {scroll = false;});
        toasts().redToastShort('Please Try Again');
      }
    }else{
      setState(() {scroll = false;});
      toasts().redToastShort('Server Error');
    }
  }



  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, newSetState){
          return AlertDialog(
            title: Text('Edit Profile'),
            content: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    editTextSimple(
                      controllers: uvUserNameController,
                      focusNode: uvUserNameFocusNode,
                      hint: 'Enter User Name',
                      keyboardTypes: TextInputType.text,
                      maxlength: 50,),

                    SizedBox(height: 10,),

                    editTextSimple(
                      controllers: uvContactNameController,
                      focusNode: uvContactNameFocusNode,
                      hint: 'Enter Contact Name',
                      keyboardTypes: TextInputType.text,
                      maxlength: 50,),

                    SizedBox(height: 10,),

                    editTextSimple(
                      controllers: uvEmailController,
                      focusNode: uvEmailFocusNode,
                      hint: 'Enter Email',
                      keyboardTypes: TextInputType.emailAddress,
                      maxlength: 60,),

                    SizedBox(height: 10,),

                    editTextSimple(
                      controllers: uvAddressController,
                      focusNode: uvAddressFocusNode,
                      hint: 'Enter Address',
                      keyboardTypes: TextInputType.text,
                      maxlength: 100,),

                    SizedBox(height: 10,),

                    dropDown(selectText: 'Select District', sendValue: 'districtKey', viewValue: 'districtName', selectedValue: districtDropdownValue, allItem: districtTypeItem,
                      onChanged: (value){
                        newSetState(() {
                          districtDropdownValue = value!;
                          //debugPrint('vvvvvvvvvvvvvvvvvvvv$districtDropdownValue');
                        });
                      },
                    ),

                    SizedBox(height: 20,),

                    GestureDetector(
                      child: normalButton(name: 'Update',height: 50,),
                      onTap: (){
                        if(uvUserNameController.text.isEmpty || uvContactNameController.text.isEmpty || uvEmailController.text.isEmpty || uvAddressController.text.isEmpty || districtDropdownValue==null || districtDropdownValue==0 ){
                          toasts().redToastShort('Proper Fill The Details');
                        }else{
                          Navigator.pop(context);
                          uploadProfileAPI();
                        }
                      },
                    )


                  ],
                ),
              ),
            ),
          );
        }
        );
      }
    );
  }

}
