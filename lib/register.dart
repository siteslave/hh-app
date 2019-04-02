import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register new user'),
      ),
      body: ListView(
        children: <Widget>[
          Text('User detail'),
          TextFormField(),
          TextFormField(),
          TextFormField(),
          RaisedButton.icon(
            icon: Icon(Icons.save),
            label: Text('REGISTER'),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
