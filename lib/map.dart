import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helping_hand/api.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  double lat;
  double lng;

  double currentLat;
  double currentLng;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final storage = new FlutterSecureStorage();
  Api api = Api();

  static final CameraPosition myPosition = CameraPosition(
    target: LatLng(13.8449339, 100.5793709),
    zoom: 18,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future gotoCurrentPosition() async {
    CameraPosition hotel = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, lng),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(hotel));
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude ?? 13.8449339;
      lng = position.longitude ?? 100.5793709;
    });

    print(position);
  }

  void _add() {
    final MarkerId markerId = MarkerId('1');

    setState(() {
      if (markers.containsKey(markerId)) {
        markers.remove(markerId);
      }
    });

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(currentLat, currentLng),
      infoWindow: InfoWindow(title: 'นายทดสอบ เล่นๆ', snippet: 'HN: 0041223'),
      onTap: () {},
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  Future updateLatLng() async {
    if (currentLat != null && currentLng != null) {
      var token = await storage.read(key: 'token');
      try {
        var rs = await api.updateLatLng(
            currentLat.toString(), currentLng.toString(), token);
        if (rs.statusCode == 200) {
          var decoded = json.decode(rs.body);
          if (decoded['ok']) {
            Navigator.of(context).pop();
          } else {
            print(decoded['message']);
          }
        } else {
          print('Connection error!');
        }
      } catch (error) {
        print(error);
      }
    } else {
      print('No current position!');
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('MAP'),
//      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: myPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (CameraPosition position) {
              print(position);
              setState(() {
                currentLat = position.target.latitude;
                currentLng = position.target.longitude;
              });

              _add();
            },
            markers: Set<Marker>.of(markers.values),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.location_searching,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        gotoCurrentPosition();
                        _add();
                      },
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        updateLatLng();
                      },
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    height: 50,
                    width: 50,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
