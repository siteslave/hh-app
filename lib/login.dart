import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:helping_hand/api.dart';
import 'package:helping_hand/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController ctrlPincode = TextEditingController();
  TextEditingController ctrlCid = TextEditingController();

  final storage = new FlutterSecureStorage();

  Api api = Api();

  Future doLogin() async {
    try {
      String cid = ctrlCid.text;
      String pincode = ctrlPincode.text;

      var rs = await api.doLoginPincode(cid, pincode);
      if (rs.statusCode == 200) {
        var jsonDecoded = json.decode(rs.body);
        if (jsonDecoded['ok']) {
          var _token = jsonDecoded['token'];
          await storage.write(key: 'token', value: _token);
          print(cid);
          await storage.write(key: 'cid', value: cid);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        } else {
          print(jsonDecoded['message']);
        }
      } else {
        print('Connection failed!');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PLEASE LOGIN')),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              controller: ctrlCid,
              decoration: InputDecoration(
                  labelText: 'PERSONAL ID',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.credit_card),
                  helperText: 'ระบุเลขประชาชน 13 หลัก',
                  hintText: 'xxxxxxxxxxxxx'),
            ),
            TextFormField(
              controller: ctrlPincode,
              decoration: InputDecoration(
                  labelText: 'PINCODE',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.keyboard),
                  helperText: 'ระบุ PINCODE 7 หลัก',
                  hintText: 'xxxxxxx'),
            ),
            Divider(),
            RaisedButton.icon(
              color: Colors.green,
              icon: Icon(Icons.vpn_key),
              label: Text('LOGIN'),
              onPressed: () {
                doLogin();
              },
            )
          ],
        ),
      ),
    );
  }
}
