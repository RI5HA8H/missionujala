

import 'package:flutter/material.dart';

import 'Modules/viewLocations.dart';
import 'Resource/StringLocalization/titles.dart';
import 'Resource/Utiles/appBar.dart';
import 'Resource/Utiles/bottomNavigationBar.dart';
import 'Resource/Utiles/drawer.dart';


class userProfile extends StatefulWidget {
  const userProfile({super.key});

  @override
  State<userProfile> createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => viewLocations()), (Route<dynamic> route) => false);
        return false;
      },
      child: Scaffold(
        appBar: appBar(),
        drawer: drawer(),
        body: Container(
          child: Center(
            child: Text('Hello User'),
          ),
        ),
        bottomNavigationBar: bottomNavigationBar(2),
      ),
    );
  }
}
