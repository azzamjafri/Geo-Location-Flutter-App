import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

//  Map<String, double> currentLocation = new Map();
    LocationData currentLocation;


  StreamSubscription<LocationData> locationSubscription;

  var location = new Location();

  String error;


  @override
  void initState() {
    super.initState();


    initPlatformState();

//    locationSubscriptionA = location.onLocationChanged().listen(currentLocation) as StreamSubscription<Map<String, double>>;

    locationSubscription = location.onLocationChanged().listen((LocationData result) {

      setState(() {
        currentLocation =  result;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Location"),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text('Lat/Lan: ${currentLocation.longitude}/${currentLocation.latitude}'),
              new Text('Time: ${DateTime.fromMillisecondsSinceEpoch(currentLocation.time.toInt())} ')
            ],
          ),
        ),
      ),
    );

  }

  void initPlatformState() async {

    var my_location;
    try{
      my_location = (await location.getLocation());
      error = "";

    }on PlatformException catch(e) {
      if(e.code == 'PERMISSION_DENIED')
        error = 'Permission Denied';
      else if(e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Permission denied- ask user to enable it from settings';
      my_location =null;
    }
    setState(() {
      currentLocation = my_location;
    });

  }

}