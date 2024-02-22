




import 'package:flutter/material.dart';

import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';

class dashBoard extends StatefulWidget {
  const dashBoard({super.key});

  @override
  State<dashBoard> createState() => _dashBoardState();
}

class _dashBoardState extends State<dashBoard> {
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
