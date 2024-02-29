

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class checkInternet extends StatefulWidget {
  const checkInternet({Key? key}) : super(key: key);

  @override
  State<checkInternet> createState() => _checkInternetState();
}

class _checkInternetState extends State<checkInternet> {


  @override
  void initState() {
    internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if(result == ConnectivityResult.none){
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      }else if(result == ConnectivityResult.mobile){
        //connection is mobile data network
        setState(() {
          isoffline = false;
          Navigator.pop(context);
        });
      }else if(result == ConnectivityResult.wifi){
        //connection is from wifi
        setState(() {
          isoffline = false;
          Navigator.pop(context);
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    internetconnection!.cancel();
    super.dispose();
  }

  StreamSubscription? internetconnection;
  bool isoffline = false;
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: new Text('Are you sure ?',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black),),
        content: new Text('Do you want to exit an Mission Ujala Application.',style: TextStyle(fontSize: 14,color: Colors.redAccent)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), //<-- SEE HERE
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(), // <-- SEE HERE
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/wifi.png',width: 100,height: 100,),
                  SizedBox(height: 20,),
                  Text("Please Check Your Internet Connection",style: TextStyle(fontSize: 14, color:Colors.green,fontWeight: FontWeight.bold),),
                  /*Padding(
                    padding: const EdgeInsets.all(50),
                    child: ElevatedButton(child: SizedBox(width: double.infinity, height: 50,child: Center(child: Text('Enable',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),))),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red[500]),),
                      onPressed: (){

                      },
                    ),
                  ),*/
                ],
              ),
          ),
        ),
      ),
    );
  }
}

