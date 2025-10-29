import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/status.dart';

void toastInfo({required String msg, required Status status}) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.CENTER, backgroundColor: status == Status.error ? Colors.red : Colors.green,
  );
}
