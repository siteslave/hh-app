import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:helping_hand/pincode.dart';
import 'package:helping_hand/register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLogged = false;
  final storage = new FlutterSecureStorage();

  Future getCid() async {
    String cid = await storage.read(key: 'cid');
    if (cid != null) {
      setState(() {
        isLogged = true;
      });
    }
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
                      setState(() {
                        isLogged = false;
                      });
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => PincodePage(),
                    fullscreenDialog: true));
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
