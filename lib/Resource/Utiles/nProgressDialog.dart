
import 'package:flutter/cupertino.dart';
import 'package:ndialog/ndialog.dart';

class nDialog {
  nDialog._();

  static ProgressDialog nProgressDialog(BuildContext context) {
    return ProgressDialog(
      context,
      blur: 0,
      dismissable: false,
      //title: Text(""),
      message: Text("Please wait.."),
      onDismiss: () => debugPrint("Do something onDismiss"),
    );
  }


}