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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Text(
              'ENTER USER INFORMATION',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'PERSONAL ID',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.credit_card),
                  helperText: 'ระบุเลขประชาชน 13 หลัก',
                  hintText: 'xxxxxxxxxxxxx'),
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'PINCODE',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.keyboard),
                  helperText: 'ระบุ PINCODE 7 หลัก',
                  hintText: 'xxxxxxx'),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'TELEPHONE',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.phone),
                helperText: 'หมายเลขโทรศัพท์',
              ),
            ),
            RaisedButton.icon(
              icon: Icon(Icons.save),
              label: Text('REGISTER'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
