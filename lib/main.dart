import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/splashScreen.dart';



class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingbackgroundHandler) ;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MyApp());
}


@pragma('vm:entry-point')
Future<void> _firebaseMessagingbackgroundHandler(RemoteMessage message) async{
  await Firebase.initializeApp();
  debugPrint(message.notification!.title.toString());
  debugPrint(message.notification!.body.toString());
  debugPrint(message.data.toString());
  debugPrint(message.data['badge'].runtimeType.toString());
  if(await FlutterAppBadger.isAppBadgeSupported()){
    FlutterAppBadger.updateBadgeCount(int.parse(message.data['badge']));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mission Ujala',
      theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch:mainAppColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: appcolors.primaryColor,
          ),
          appBarTheme: AppBarTheme(
            shadowColor: Colors.black,
            backgroundColor: appcolors.screenBckColor,
            foregroundColor: appcolors.whiteColor,
          )
      ),
      home:  const splashScreen(),
    );
  }
}

