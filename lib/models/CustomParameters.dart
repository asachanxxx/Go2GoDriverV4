import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab_driver/models/Driver.dart';
import 'package:my_cab_driver/models/SystemSettings.dart';
import 'package:my_cab_driver/models/VType.dart';
import 'package:my_cab_driver/models/VehicleInfomation.dart';
import 'package:my_cab_driver/models/dailyParameters.dart';

class CustomParameters{

  static bool fireBaseLogEnable = true;
  static String userProfilePath = "images/drivers/profilePics";
  static String userDocumentPath = "images/drivers/docpath";
  static String userAudioPath = "audio/rideRequest";
  static final String operatingCountry = 'LK';
  static late User currentFirebaseUser;
  static late Location currentPosition;
  static bool isOnline = false;
  static LatLng posError = LatLng(6.877133555388284, 79.98983549839619);
  static List<VType> globalVTypes = [];
  static late StreamSubscription<Position> homeTabPositionStream;
  static late SystemSettings systemSettings;
  static late DatabaseReference rideRef;
  static String ApiKey = "AIzaSyBSixR5_gpaPVfXXIXV-bdDKW624mBrRqQ";
  static final String geoCodeUrl = 'https://maps.googleapis.com/maps/api/geocode/json';
  static late String token;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
  static late AndroidNotificationChannel channel;
  static Driver currentDriverInfo = Driver(fullName: "", email: "", phone: "", id: "", carModel: "", carColor: "", vehicleNumber: "", SCR: 6.00, ODR: 10, nic: "",driverLevel: '');
  static late VehicleInfomation currentVehicleInfomation;
  static DailyParameters dailyParameters = DailyParameters(earning: 0.00,commission: 0.00,driveHours: 0.00,totalDistance: 0.00,totalTrips: 0);
  static final CameraPosition googlePlex = CameraPosition(
    target: LatLng(6.885173, 80.015352),
    zoom: 14.4746,
  );

  static double roundUp(double val) {
    return double.parse(val.toStringAsFixed(2));
  }

  static String VtypeConverter(String Vtype) {
    String GlobalVtype = "Type1";
    if (Vtype == null || Vtype.trim() == "") {
      GlobalVtype = "Type1";
    } else {
      switch (Vtype.trim().toUpperCase()) {
        case "TUK":
          GlobalVtype = "Type1";
          break;
        case "NANO":
          GlobalVtype = "Type2";
          break;
        case "ALTO":
          GlobalVtype = "Type3";
          break;
        case "WAGONR":
          GlobalVtype = "Type4";
          break;
        case "CLASSIC":
          GlobalVtype = "Type5";
          break;
        case "DELUXE":
          GlobalVtype = "Type6";
          break;
        case "MINI-VAN":
          GlobalVtype = "Type7";
          break;
        case "VAN":
          GlobalVtype = "Type8";
          break;
      }
    }

    return GlobalVtype;
  }
}
