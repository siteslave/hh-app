import 'package:flutter/material.dart';
import 'package:pin_code_view/pin_code_view.dart';

class PincodePage extends StatefulWidget {
  @override
  _PincodePageState createState() => _PincodePageState();
}

class _PincodePageState extends State<PincodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ENTER PIN CODE'),
        ),
        body: PinCode(
          obscurePin: true,
          codeTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          title: Text(
            "Lock Screen",
            style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
          subTitle: Text(
            "Enter the pin code",
            style: TextStyle(color: Colors.white),
          ),
          codeLength: 7,
          correctPin: "1234",
          onCodeSuccess: (code) {
            print(code);
          },
          onCodeFail: (code) {
            print(code);
          },
        ));
  }
}
