


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class simpleEditText extends StatelessWidget {
  simpleEditText({Key? key,
    required this.controllers,
    required this.focusNode,
    required this.keyboardTypes,
    required this.maxlength,
    this.fontSize=16,
    this.counterTexts='',
    this.hint='',
    this.label='',
    this.readOnly=false,
  }) : super(key: key);

  TextEditingController controllers;
  FocusNode focusNode = FocusNode();
  var keyboardTypes;
  String label;
  String hint;
  String counterTexts;
  int maxlength;
  double fontSize;
  bool readOnly;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        readOnly: readOnly,
        maxLength: maxlength,
        keyboardType:keyboardTypes,
        controller: controllers,
        focusNode: focusNode,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          counterText: counterTexts,
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(fontSize: 12),
        ),
        style: TextStyle(fontSize: fontSize,),
      ),
    );
  }
}
