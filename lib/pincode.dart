import 'package:flutter/material.dart';
import 'package:pin_code_view/pin_code_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PincodePage extends StatefulWidget {
  @override
  _PincodePageState createState() => _PincodePageState();
}

class _PincodePageState extends State<PincodePage> {
  final storage = new FlutterSecureStorage();
  String cid;

  Future getCid() async {
    String _cid = await storage.read(key: 'cid');
    print(_cid);

    setState(() {
      cid = _cid;
    });
  }

  @override
  void initState() {
    super.initState();
    getCid();
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
