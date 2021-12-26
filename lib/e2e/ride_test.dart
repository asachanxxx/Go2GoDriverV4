import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class RideTest extends StatefulWidget {
  const RideTest({Key? key}) : super(key: key);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<RideTest> {
  var appBarheight = 20.0;

  String latitude = 'waiting...';
  String longitude = 'waiting...';
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';


  @override
  Widget build(BuildContext context) {
    appBarheight = AppBar().preferredSize.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child:
        Center(
          child: ListView(
            children: <Widget>[
              locationData('Latitude: ' + latitude),
              locationData('Longitude: ' + longitude),
              locationData('Altitude: ' + altitude),
              locationData('Accuracy: ' + accuracy),
              locationData('Bearing: ' + bearing),
              locationData('Speed: ' + speed),
              locationData('Time: ' + time),
              ElevatedButton(
                  onPressed: () async {
                    var permission = await Permission.locationAlways.isGranted;
                    if(!permission){
                      var permisisonState = await Permission.locationAlways.request();
                      if(permisisonState.isDenied || permisisonState.isPermanentlyDenied){
                        print("New trip Point 5");
                        Navigator.pop(context);
                      }
                    }else{
                      print("New trip Point 6");
                    }

                    await BackgroundLocation.setAndroidNotification(
                      title: 'Go2Go Location tracking enabled Da?',
                      message: 'Background location in progress',
                      icon: '@mipmap/ic_launcher',
                    );
                    await BackgroundLocation.setAndroidConfiguration(1000);
                    print("New trip Point 7");
                    await BackgroundLocation.startLocationService(
                        distanceFilter: 20);
                    BackgroundLocation.getLocationUpdates((location) {
                      setState(() {
                        latitude = location.latitude.toString();
                        longitude = location.longitude.toString();
                        accuracy = location.accuracy.toString();
                        altitude = location.altitude.toString();
                        bearing = location.bearing.toString();
                        speed = location.speed.toString();
                        time = DateTime.fromMillisecondsSinceEpoch(
                            location.time!.toInt())
                            .toString();
                      });
                      print('''\n
                        Latitude:  $latitude
                        Longitude: $longitude
                        Altitude: $altitude
                        Accuracy: $accuracy
                        Bearing:  $bearing
                        Speed: $speed
                        Time: $time
                      ''');
                    });
                  },
                  child: Text('Start Location Service')),
              ElevatedButton(
                  onPressed: () {
                    BackgroundLocation.stopLocationService();
                  },
                  child: Text('Stop Location Service')),
              ElevatedButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  child: Text('Get Current Location')),
              ElevatedButton(
                  onPressed: () async {
                    final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
                    var serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
                    //Position? position = await Geolocator.getLastKnownPosition();
                    print("position $serviceEnabled");


                  },
                  child: Text('GetStatic Loc')),
            ],
          ),
        ),
      ),
    );
  }

  Widget locationData(String data) {
    return Text(
      data,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  void getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print('This is current Location ' + location.toMap().toString());
    });
  }



  double earnings =0.00;



}
