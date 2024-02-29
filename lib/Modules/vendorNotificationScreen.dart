




import 'package:flutter/material.dart';

import '../Resource/Utiles/appBar.dart';
import '../Resource/Utiles/drawer.dart';

class vendorNotificationScreen extends StatefulWidget {
  const vendorNotificationScreen({super.key});

  @override
  State<vendorNotificationScreen> createState() => _vendorNotificationScreenState();
}

class _vendorNotificationScreenState extends State<vendorNotificationScreen> {
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
