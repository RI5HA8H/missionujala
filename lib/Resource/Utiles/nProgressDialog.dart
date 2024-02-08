
import 'package:flutter/cupertino.dart';
import 'package:ndialog/ndialog.dart';

class nDialog {
  nDialog._();

  static ProgressDialog nProgressDialog(BuildContext context) {
    return ProgressDialog(
      context,
      blur: 5,
      dismissable: false,
      //title: Text(""),
      message: Text("Please wait.."),
      onDismiss: () => print("Do something onDismiss"),
    );
  }


}