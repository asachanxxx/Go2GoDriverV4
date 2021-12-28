import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/DirectionDetails.dart';
import 'package:my_cab_driver/models/SystemSettings.dart';
import 'package:my_cab_driver/models/TripDetails.dart';
import 'package:my_cab_driver/models/VType.dart';
import 'package:http/http.dart' as http;
import 'package:my_cab_driver/widgets/wgt_progressdialog.dart';

class CommonService {
  Future<List<VType>?> getVehicleTypeInfo() async {
    var checkRef = await FirebaseDatabase.instance
        .reference()
        .child("vehicleTypes")
        .orderByChild("name")
        .once();
    if (checkRef.value != null) {
      List<VType> theList = <VType>[];
      checkRef.value.entries.forEach((snapshot) {
        print("==================================================");
        print("fullName of name ---  ${snapshot.value["name"]} ");
        print("fullName of baseFare ---  ${snapshot.value["baseFire"]} ");
        print("fullName of minutePrice ---  ${snapshot.value["minutePrice"]} ");
        print("fullName of perKM ---  ${snapshot.value["perKm"]} ");
        print("==================================================");
        theList.add(VType(
            snapshot.value["name"],
            double.parse(snapshot.value["baseFire"].toString()),
            double.parse(snapshot.value["minutePrice"].toString()),
            double.parse(snapshot.value["perKm"].toString()),
            snapshot.value["displayName"]));
      });
      theList.sort((a, b) => a.name.compareTo(b.name));
      return theList;
    }
    return null;
  }

  static void disableHomTabLocationUpdates() {
    CustomParameters.homeTabPositionStream!.pause();
    Geofire.removeLocation(CustomParameters.currentFirebaseUser.uid);
  }

  static void enableHomTabLocationUpdates() {
    if (CustomParameters.homeTabPositionStream != null) {
      CustomParameters.homeTabPositionStream!.resume();
    }
    Geofire.setLocation(
        CustomParameters.currentFirebaseUser.uid,
        CustomParameters.currentPosition.latitude!,
        CustomParameters.currentPosition.longitude!);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  static Future<String> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.value('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.value(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.value(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    return "Loc ok";
  }

  static void handleOnlineStatus(String uid) {
    // Fetch the current user's ID from Firebase Authentication.

    var userStatusDatabaseRef = FirebaseDatabase.instance
        .reference()
        .child('statusFactors/drivers/' + uid);
    var isOfflineForDatabase = {
      "state": 'offline',
      "last_changed": DateTime.now().toString(),
    };
    var isOnlineForDatabase = {
      "state": 'online',
      "last_changed": DateTime.now().toString(),
    };

    FirebaseDatabase.instance
        .reference()
        .child('.info/connected')
        .onValue
        .listen((event) {
      print(".info/connected ${event.snapshot.value}");
      if (event.snapshot.value == false) {
        return;
      }
      userStatusDatabaseRef
          .onDisconnect()
          .set(isOfflineForDatabase)
          .then((value) {
        print("userStatusDatabaseRef  ");
        userStatusDatabaseRef.set(isOnlineForDatabase);
      });
    });
  }

  Future<SystemSettings?> fetchSystemConfigurations() async {
    var checkRef =
        await FirebaseDatabase.instance.reference().child("companies").once();
    if (checkRef.value != null) {
      Map<dynamic, dynamic> map = checkRef.value;
      //var firstElement = map.values.toList()[0]['SCR'];
      SystemSettings entity = SystemSettings.fromDb(map);
      return entity;
    }
    return null;
  }

  static Future<DirectionDetails?> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return null;
    }
    String urlOnly = "https://maps.googleapis.com/maps/api/directions/json?";
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude}, ${startPosition.longitude}&destination=${endPosition.latitude}, ${endPosition.longitude}&mode=driving&key=AIzaSyBSixR5_gpaPVfXXIXV-bdDKW624mBrRqQ";
    print('Direction URL: ' + url);
    var response = await getRequestRevamp(url);
    print('Response getDirectionDetails: $response');
    if (response == 'failed' || response == 'ZERO_RESULTS') {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails(
        distanceText: response['routes'][0]['legs'][0]['duration']['text'],
        durationText: response['routes'][0]['legs'][0]['distance']['text'],
        distanceValue: response['routes'][0]['legs'][0]['distance']['value'],
        durationValue: response['routes'][0]['legs'][0]['duration']['value'],
        encodedPoints: response['routes'][0]['overview_polyline']['points']);
    return directionDetails;
  }

  static Future<dynamic> getRequestRevamp(String url) async {
    Uri uriX = Uri.parse(url);
    print("getRequestRevamp uriX ${uriX}"); // {q: yellow, size: very big}
    http.Response response = await http.get(uriX);

    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedata = jsonDecode(data);
        return decodedata;
      } else {
        return "failed";
      }
    } catch (e) {
      return "failed";
    }
  }

  static void showProgressDialog(context) {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Please wait',
        circularProgressIndicatorColor: Colors.redAccent,
      ),
    );
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

  static int estimateFares(
      DirectionDetails details, String vehicleType, TripDetails tripDetails) {
    var PerMinute = 2.5;

    print("estimateFares->vehicleType = $vehicleType");

    /*
      Bikes-25
      Tuk-Tuk -36
      Flex-Nano -45
      Flex-Alto -48
      Mini -50
      Car -68
      Minivan -55
      Van-58
      Minilorry
      Lorry
    * */
    /*
      * Fire Calculation
      * ----------------
      * Base Fares: This is the base or the fla amount of money witch will charged for a trip
      *
      * Distance Fares: This is the amount charge for Kilometer base
      *
      * Time Fares: this is the amount charged for every minute spend on the trip
      *
      * Total Fire  = Sum(Base Fares + Distance Fares +Time Fares)
      * KM = 0.3
      * Per Minute = 2
      * Base Fire = $3
      * */
    if (details != null) {
      double baseFire = 40;

      ///Distance is from KM
      double distanceFire = details.distanceValue * 40;
      double timeFire = (details.durationValue / 60) * PerMinute;
      VType tukObject = VType(
          "", double.minPositive, double.minPositive, double.minPositive, "");

      if (vehicleType == "Type1") {
        // Tuk-Tuk
        tukObject = CustomParameters.globalVTypes
            .singleWhere((element) => element.name.trim() == "Type1");
        baseFire = tukObject.baseFare;
        distanceFire = applyFireLogic(details.distanceValue, tukObject.perKM);
        timeFire = (details.durationValue / 60) * tukObject.minutePrice;
      } else if (vehicleType == "Type2") {
        // Flex-Nano
        tukObject = CustomParameters.globalVTypes
            .singleWhere((element) => element.name.trim() == "Type2");
        baseFire = tukObject.baseFare;
        distanceFire = applyFireLogic(details.distanceValue, tukObject.perKM);
        timeFire = (details.durationValue / 60) * tukObject.minutePrice;
        print(
            "vehicleType tukObject.baseFare = ${tukObject.baseFare} \n details.distanceValue = ${details.distanceValue} \n tukObject.perKM = ${tukObject.perKM} \n details.durationValue = ${details.durationValue} \n tukObject.minutePrice = ${tukObject.minutePrice}");
      } else if (vehicleType == "Type3") {
        // Flex-Alto

        tukObject = CustomParameters.globalVTypes
            .singleWhere((element) => element.name.trim() == "Type3");
        baseFire = tukObject.baseFare;
        distanceFire = applyFireLogic(details.distanceValue, tukObject.perKM);
        timeFire = (details.durationValue) * tukObject.minutePrice;
        print(
            "vehicleType tukObject.baseFare = ${tukObject.baseFare} \n details.distanceValue = ${details.distanceValue} \n tukObject.perKM = ${tukObject.perKM} \n details.durationValue = ${details.durationValue} \n tukObject.minutePrice = ${tukObject.minutePrice}");
      } else if (vehicleType == "Type4") {
        // Mini
        tukObject = CustomParameters.globalVTypes
            .singleWhere((element) => element.name.trim() == "Type4");
        baseFire = tukObject.baseFare;
        distanceFire = applyFireLogic(details.distanceValue, tukObject.perKM);
        timeFire = (details.durationValue / 60) * tukObject.minutePrice;
        print(
            "vehicleType tukObject.baseFare = ${tukObject.baseFare} \n details.distanceValue = ${details.distanceValue} \n tukObject.perKM = ${tukObject.perKM} \n details.durationValue = ${details.durationValue} \n tukObject.minutePrice = ${tukObject.minutePrice}");
      } else if (vehicleType == "Type5") {
        // Car
        tukObject = CustomParameters.globalVTypes
            .singleWhere((element) => element.name.trim() == "Type5");
        baseFire = tukObject.baseFare;
        distanceFire = applyFireLogic(details.distanceValue, tukObject.perKM);
        timeFire = (details.durationValue / 60) * tukObject.minutePrice;
        print(
            "vehicleType tukObject.baseFare = ${tukObject.baseFare} \n details.distanceValue = ${details.distanceValue} \n tukObject.perKM = ${tukObject.perKM} \n details.durationValue = ${details.durationValue} \n tukObject.minutePrice = ${tukObject.minutePrice}");
      } else if (vehicleType == "Type6") {
        // Minivan
        tukObject = CustomParameters.globalVTypes
            .singleWhere((element) => element.name.trim() == "Type6");
        baseFire = tukObject.baseFare;
        distanceFire = applyFireLogic(details.distanceValue, tukObject.perKM);
        timeFire = (details.durationValue / 60) * tukObject.minutePrice;
      } else if (vehicleType == "Type7") {
        // Van
        tukObject = CustomParameters.globalVTypes
            .singleWhere((element) => element.name.trim() == "Type7");
        baseFire = tukObject.baseFare;
        distanceFire = applyFireLogic(details.distanceValue, tukObject.perKM);
        timeFire = (details.durationValue / 60) * tukObject.minutePrice;
      }

      double totalFire = baseFire + distanceFire + timeFire;

      CustomParameters.paymentDetails.kmPrice = distanceFire;
      CustomParameters.paymentDetails.timePrice = timeFire;
      CustomParameters.paymentDetails.appPrice = baseFire;
      CustomParameters.paymentDetails.totalFare = totalFire;

      double SCR = double.minPositive;
      double ODR = double.minPositive;

      ///Company payable amount calc
      if (CustomParameters.currentDriverInfo == null ||
          CustomParameters.currentDriverInfo.SCR == null) {
        SCR = ((distanceFire + timeFire) * 10) / 100;
      } else {
        SCR = ((distanceFire + timeFire) *
                CustomParameters.currentDriverInfo.SCR) /
            100;
      }

      if (tripDetails.commissionApplicable) {
        if (CustomParameters.currentDriverInfo == null ||
            CustomParameters.currentDriverInfo.ODR == null) {
          ODR = ((distanceFire + timeFire) * 5) / 100;
        } else {
          ODR = ((distanceFire + timeFire) *
                  CustomParameters.currentDriverInfo.ODR) /
              100;
        }
      } else {
        ODR = 0;
      }

      CustomParameters.paymentDetails.companyPayable = SCR;
      CustomParameters.paymentDetails.commissionApplicable =
          tripDetails.commissionApplicable;
      CustomParameters.paymentDetails.commission = ODR;

      print(
          "estimateFares baseFire = $baseFire distanceFire= $distanceFire timeFire= $timeFire ");

      print("Full Payment details $CustomParameters.paymentDetails");
      return totalFire.truncate();
    } else {
      return 0;
    }
  }

  static double applyFireLogic(int kms, double kmPrice) {
    //var disKms = kms/1000;
    if (kms <= 4) {
      return kmPrice * 4;
    } else {
      return (kms) * kmPrice;
    }
  }

  /*
   * @desc Function to generate password based on some criteria
   * @param bool _isWithLetters: password must contain letters
   * @param bool _isWithUppercase: password must contain uppercase letters
   * @param bool _isWithNumbers: password must contain numbers
   * @param bool _isWithSpecial: password must contain special chars
   * @param int _numberCharPassword: password length
   * @return string: new password
   */
  static String generatePassword(bool _isWithLetters, bool _isWithUppercase,
      bool _isWithNumbers, bool _isWithSpecial, double _numberCharPassword) {
    //Define the allowed chars to use in the password
    String _lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz";
    String _upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String _numbers = "0123456789";
    String _special = "@#=+!£\$%&?[](){}";

    //Create the empty string that will contain the allowed chars
    String _allowedChars = "";

    //Put chars on the allowed ones based on the input values
    _allowedChars += (_isWithLetters ? _lowerCaseLetters : '');
    _allowedChars += (_isWithUppercase ? _upperCaseLetters : '');
    _allowedChars += (_isWithNumbers ? _numbers : '');
    _allowedChars += (_isWithSpecial ? _special : '');

    int i = 0;
    String _result = "";

    //Create password
    while (i < _numberCharPassword.round()) {
      //Get random int
      int randomInt = Random.secure().nextInt(_allowedChars.length);
      //Get random char and append it to the password
      _result += _allowedChars[randomInt];
      i++;
    }

    return _result;
  }
}
