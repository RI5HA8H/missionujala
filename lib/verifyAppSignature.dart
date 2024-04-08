

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:missionujala/splashScreen.dart';
import 'package:package_info_plus/package_info_plus.dart';



class verifyAppSignature extends StatefulWidget {
  const verifyAppSignature({super.key});

  @override
  State<verifyAppSignature> createState() => _verifyAppSignatureState();
}

class _verifyAppSignatureState extends State<verifyAppSignature> {

    String developerSignature= 'A3:F3:10:77:01:AD:6D:DA:74:96:E5:7C:C1:64:57:5B:9D:B3:A7:0D';
    // String developerSignature= '49:B3:4F:CC:C0:79:95:B8:56:03:44:B5:E3:DF:56:67:60:67:FF:53';

   @override
    void initState() {
       verifySignature();
       super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }


   Future<void> verifySignature() async {
     try {
       final platform = MethodChannel('signatureVerification');
       final String currentSignature = await platform.invokeMethod('getSHA1Signature');

       //debugPrint('ssssssssssssssss$currentSignature');

       // Compare signatures
       if (currentSignature.contains(developerSignature)) {
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>splashScreen()));
       } else {
         SystemChannels.platform.invokeMethod('SystemNavigator.pop');
       }
     } on PlatformException catch (e) {
       // Error accessing package info
       //debugPrint('Error: $e');
     }
   }

}
