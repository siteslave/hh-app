import 'dart:convert';
import 'package:helping_hand/map.dart';
import 'package:mqtt_client/mqtt_client.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:helping_hand/api.dart';
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
  Api api = Api();

  var registerId;
  var topic;
  var status;

  Future connectMqtt() async {
    var clientId = 'helping_hand-$registerId';
    final MqttClient client = MqttClient(api.mqttHost, clientId);

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .keepAliveFor(20) // Must agree with the keep alive set above or not set
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    print('Client connecting....');

    try {
      await client.connect('q4u', '##q4u##');
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('Client connected');
    } else {
      print(
          'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }

    String topic = 'request/status/$registerId';
    print(topic);

    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print(pt);
      getStatus();
    });
  }

  Future getStatus() async {
    String token = await storage.read(key: 'token');
    print(token);

    try {
      var rs = await api.getStatus(token);
      if (rs.statusCode == 200) {
        var decoded = json.decode(rs.body);
        if (decoded['ok']) {
          setState(() {
            status = decoded['status'].toString();
            print('STATUS $status');
            registerId = decoded['registerId'].toString();
            if (decoded['registerId'] != null) {
              connectMqtt();
            }
          });
        } else {
          print(decoded['message']);
        }
      } else {
        print('Connection error!');
      }
    } catch (e) {
      print(e);
    }
  }

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
              onPressed: () async {
                if (ctrlDescription.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PincodePage(ctrlDescription.text),
                      fullscreenDialog: true));

                  getStatus();
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
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
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
      body: new Center(
        child: (status == "0" || status == "5")
            ? new GestureDetector(
                onTap: () {
                  if (isLogged) {
                    showEntryDialog();
                  } else {
                    print('Please login!');
                  }
                },
                child: new Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      border: Border.all(color: Colors.red[900], width: 10)),
                  child: new Column(
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
              )
            : new Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status == "1"
                        ? Colors.orange
                        : status == "2" ? Colors.green : Colors.blueGrey,
                    border: Border.all(
                        color: status == "1"
                            ? Colors.orange[900]
                            : status == "2"
                                ? Colors.green[900]
                                : Colors.blueGrey[900],
                        width: 10)),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      status == "1"
                          ? 'WAITING'
                          : status == "2" ? "ACCEPTED" : "REJECT",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.map),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => MapPage()));
        },
      ),
    );
  }
}
