




import 'package:flutter/material.dart';
import 'package:missionujala/Resource/Utiles/appBar.dart';
import 'package:missionujala/Resource/Utiles/drawer.dart';

class userNotificationScreen extends StatefulWidget {
  const userNotificationScreen({super.key});

  @override
  State<userNotificationScreen> createState() => _userNotificationScreenState();
}

class _userNotificationScreenState extends State<userNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: Container(

      ),
    );
  }
}
