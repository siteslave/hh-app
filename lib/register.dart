import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helping_hand/api.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Api api = Api();

  TextEditingController ctrlPincode = TextEditingController();
  TextEditingController ctrlCid = TextEditingController();
  TextEditingController ctrlTelphone = TextEditingController();

  Future doRegister() async {
    var cid = ctrlCid.text;
    var pincode = ctrlPincode.text;
    var telephone = ctrlTelphone.text;

    if (cid.isNotEmpty && pincode.isNotEmpty && telephone.isNotEmpty) {
      try {
        var res = await api.doRegister(cid, pincode, telephone);
        if (res.statusCode == 200) {
          var jsonDecoded = json.decode(res.body);
          if (jsonDecoded['ok']) {
            Navigator.of(context).pop();
          } else {
            print(jsonDecoded['message']);
          }
        } else {
          print('Connection error!');
        }
      } catch (e) {}
    } else {
      print('Data invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register new user'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Text(
              'ENTER USER INFORMATION',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
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
            TextFormField(
              controller: ctrlTelphone,
              decoration: InputDecoration(
                labelText: 'TELEPHONE',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.phone),
                helperText: 'หมายเลขโทรศัพท์',
              ),
            ),
            RaisedButton.icon(
              color: Colors.green,
              icon: Icon(Icons.save),
              label: Text('REGISTER'),
              onPressed: () {
                doRegister();
              },
            )
          ],
        ),
      ),
    );
  }
}
