import 'package:flutter/material.dart';

void successMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    ),
  );
}

void errorMessage(BuildContext context, String m) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(m, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    ),
  );
}
