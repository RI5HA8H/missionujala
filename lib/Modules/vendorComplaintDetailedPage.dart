

import 'package:flutter/material.dart';

import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';



class vendorComplaintDetailedPage extends StatefulWidget {
  const vendorComplaintDetailedPage({super.key});

  @override
  State<vendorComplaintDetailedPage> createState() => _vendorComplaintDetailedPageState();
}

class _vendorComplaintDetailedPageState extends State<vendorComplaintDetailedPage> {
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
