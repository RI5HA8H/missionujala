

import 'package:flutter/material.dart';


class editTextSimple extends StatelessWidget {
  editTextSimple({Key? key,
    required this.controllers,
    required this.focusNode,
    required this.keyboardTypes,
    required this.maxlength,
    this.cHeight=50,
    this.cWidth=double.infinity,
    this.fontSize=16,
    this.counterTexts='',
    this.hint='',
    this.label='',
    this.readOnly=false,
    this.etBckgoundColor=Colors.white,
  }) : super(key: key);

  TextEditingController controllers;
  FocusNode focusNode = FocusNode();
  var keyboardTypes;
  String label;
  String hint;
  String counterTexts;
  int maxlength;
  double fontSize;
  double cHeight;
  double cWidth;
  bool readOnly;
  Color etBckgoundColor;

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: cHeight,
      width: cWidth,
      child: Container(
        decoration: BoxDecoration(
          color: etBckgoundColor,
          borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
        ),
        child: TextFormField(
          readOnly: readOnly,
          maxLength: maxlength,
          keyboardType:keyboardTypes,
          controller: controllers,
          focusNode: focusNode,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10, 14, 10, 14),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: Color(0xffC5C5C5), // Border color
                width: 0.5,         // Border width
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            counterText: counterTexts,
            labelText: label,
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12),
          ),
          style: TextStyle(fontSize: fontSize,),
        ),
      ),
    );
  }
}




