


import 'package:flutter/material.dart';

import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';



class userServiceCenterScreen extends StatefulWidget {
  const userServiceCenterScreen({super.key});

  @override
  State<userServiceCenterScreen> createState() => _userServiceCenterScreenState();
}

class _userServiceCenterScreenState extends State<userServiceCenterScreen> {
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
