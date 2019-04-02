import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helping_hand/api.dart';
import 'package:pin_code_view/pin_code_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PincodePage extends StatefulWidget {
  @override
  _PincodePageState createState() => _PincodePageState();
}

class _PincodePageState extends State<PincodePage> {
  Api api = Api();

  final storage = new FlutterSecureStorage();
  String cid;

  Future doLoginPincode(String pincode) async {
    try {
      String _cid = await storage.read(key: 'cid');
      var res = await api.doLoginPincode(_cid, pincode);
      if (res.statusCode == 200) {
        var jsonDecoded = json.decode(res.body);
        if (jsonDecoded['ok']) {
          String token = jsonDecoded['token'];
          await storage.write(key: 'token', value: token);
          Navigator.of(context).pop();
        } else {
          print(jsonDecoded['message']);
        }
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
  }

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
          onCodeFail: (code) {
            print(code);
            doLoginPincode(code);
          },
        ));
  }
}
