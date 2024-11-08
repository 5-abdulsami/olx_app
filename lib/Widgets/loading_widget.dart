import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    padding: const EdgeInsets.all(12),
    alignment: Alignment.center,
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.lightGreen),
    ),
  );
}
