import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    padding: EdgeInsets.all(12),
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
    ),
  );
}
