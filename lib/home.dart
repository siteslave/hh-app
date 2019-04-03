import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:helping_hand/login.dart';
import 'package:helping_hand/pincode.dart';
import 'package:helping_hand/register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLogged = false;
  final storage = new FlutterSecureStorage();

  TextEditingController ctrlDescription = TextEditingController();

  Future getCid() async {
    String cid = await storage.read(key: 'cid');
    if (cid != null) {
      setState(() {
        isLogged = true;
      });
    }
  }

  Future<void> showEntryDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Description'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: ctrlDescription,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      fillColor: Colors.white10,
                      filled: true,
                      helperText: 'รายละเอียดการขอความช่วยเหลือ'),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                if (ctrlDescription.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PincodePage(ctrlDescription.text),
                      fullscreenDialog: true));
                } else {
                  print('No description');
                }
              },
            ),
            FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getCid();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Helping Hand'),
          actions: <Widget>[
            isLogged
                ? IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await storage.deleteAll();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()));
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => RegisterPage()));
                      var _cid = await storage.read(key: 'cid');
                      if (_cid != null) {
                        setState(() {
                          isLogged = true;
                        });
                      }
                    },
                  )
          ],
        ),
        body: Center(
          child: GestureDetector(
            onTap: () {
              if (isLogged) {
                showEntryDialog();
              } else {
                print('Please login!');
              }
            },
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                  border: Border.all(color: Colors.red[900], width: 10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Help Me!',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
