


import 'package:flutter/material.dart';

import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';


class userComplaintDetailedPage extends StatefulWidget {
  const userComplaintDetailedPage({super.key});

  @override
  State<userComplaintDetailedPage> createState() => _userComplaintDetailedPageState();
}

class _userComplaintDetailedPageState extends State<userComplaintDetailedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: drawer(),
      body: Container(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
