import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import 'package:missionujala/splashScreen.dart';



class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = new MyHttpOverrides();
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

