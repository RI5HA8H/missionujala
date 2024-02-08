

import 'package:flutter/material.dart';
import 'package:missionujala/Resource/Colors/app_colors.dart';
import '../Resource/StringLocalization/titles.dart';
import '../Resource/Utiles/normalButton.dart';
import '../Resource/Utiles/simpleEditText.dart';


class complaintScreen extends StatefulWidget {
  const complaintScreen({super.key});

  @override
  State<complaintScreen> createState() => _complaintScreenState();
}

class _complaintScreenState extends State<complaintScreen> {

  FocusNode titleFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 30,
        title: Text('${allTitle.userComplaint}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
      ),
      body: Container(
        color: appcolors.screenBckColor,
        child: Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 30,),
                simpleEditText(
                  controllers: titleController,
                  focusNode: titleFocusNode,
                  hint: 'Enter Title',
                  label: 'Title',
                  keyboardTypes: TextInputType.text,
                  maxlength: 50,
                ),
                SizedBox(height: 10,),
                simpleEditText(
                  controllers: descriptionController,
                  focusNode: descriptionFocusNode,
                  hint: 'Enter Description',
                  label: 'Description',
                  keyboardTypes: TextInputType.text,
                  maxlength: 200,
                ),

                SizedBox(height: 20,),
                InkWell(
                  child: normalButton(name: 'Send',height:45,bordeRadious: 25,fontSize:14,textColor: Colors.black,bckColor: appcolors.primaryTextColor,),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => complaintScreen()));
                  },
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
