import 'package:flutter/material.dart';
import 'package:helping_hand/home.dart';

void main() {
  runApp(HelpingApp());
}

class HelpingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      title: 'Helping Hand',
    );
  }
}
