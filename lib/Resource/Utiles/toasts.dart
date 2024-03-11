
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class toasts{

  void redToastShort(String debugPrintvalue){
    Fluttertoast.showToast(
        msg: debugPrintvalue,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 14.0

    );
  }

  void redToastLong(String debugPrintvalue){
    Fluttertoast.showToast(
        msg: debugPrintvalue,
        backgroundColor: Colors.red,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 14.0

    );
  }


  void greenToastShort(String debugPrintvalue){
    Fluttertoast.showToast(
        msg: debugPrintvalue,
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 14.0
    );
  }

  void greenToastLong(String debugPrintvalue){
    Fluttertoast.showToast(
        msg: debugPrintvalue,
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 14.0
    );
  }


  void greyToastShort(String debugPrintvalue){
    Fluttertoast.showToast(
        msg: debugPrintvalue,
        backgroundColor: Colors.grey[300],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.black,
        fontSize: 14.0
    );
  }

  void greyToastLong(String debugPrintvalue){
    Fluttertoast.showToast(
        msg: debugPrintvalue,
        backgroundColor: Colors.grey[300],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.black,
        fontSize: 14.0
    );
  }


}