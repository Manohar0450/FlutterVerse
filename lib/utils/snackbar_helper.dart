import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message, {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}
//use above function like this:
// showSnackBar(context, 'Login successful', isError: false);
// showSnackBar(context, 'Invalid credentials');
