

import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class notificationservices {

  FirebaseMessaging messaging=FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

  void requestNotificationPermissions() async{
    NotificationSettings setting=await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if(setting.authorizationStatus==AuthorizationStatus.authorized){
      print('user granted permission android');
    }else if(setting.authorizationStatus==AuthorizationStatus.provisional){
      print('user granted provisional permission ios');
    }else{
      print('user denied permission');
    }
  }

  Future<void> initLocalNotification(BuildContext context,RemoteMessage message) async{
    var androidInitializationSetting =const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitializationSetting =const DarwinInitializationSettings();

    var initializationSetting=InitializationSettings(
      android: androidInitializationSetting,
      iOS: iosInitializationSetting
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,onDidReceiveBackgroundNotificationResponse: (payload){

    });

  }


  void firebaseinit(BuildContext context){
    FirebaseMessaging.onMessage.listen((message) async {
     /* if(kDebugMode){
        print("Tittle---${message.notification!.title.toString()}");
        print("Bodye---${message.notification!.body.toString()}");
      }*/
      if(Platform.isAndroid){
        initLocalNotification(context,message);
        showNotification(message);
        if(await FlutterAppBadger.isAppBadgeSupported()){
          FlutterAppBadger.updateBadgeCount(int.parse(message.data['badge']));
        }
      }
    });
  }


  Future<void> showNotification(RemoteMessage message) async{

    AndroidNotificationChannel channel=AndroidNotificationChannel(
    Random.secure().nextInt(100000).toString(),
        "High Importance Notification",
      importance: Importance.max,
        enableLights: true,
        enableVibration: true,
        playSound: true,
        showBadge: true,
    );

    AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails(
        channel.id.toString(),
        channel.name.toString(),
      channelDescription: "Your Channel Description",
      importance: Importance.max,
      icon: "@mipmap/ic_launcher",
      priority: Priority.max,
      playSound: true,
      enableLights: true,
      enableVibration: true,
      ticker: "ticker"
    );

    const DarwinNotificationDetails darwinNotificationDetails=DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails=NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero,() {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails
      );
    });

  }


  Future<String> getDeviceToken() async{
    String? token=await messaging.getToken();
    return token!;
  }

  void getifDeviceTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      print("if token is refresh...........");
      event.toString();
    });
  }

}