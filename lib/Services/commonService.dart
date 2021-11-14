import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/SystemSettings.dart';
import 'package:my_cab_driver/models/VType.dart';

class CommonService{
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
    CustomParameters.homeTabPositionStream.pause();
    Geofire.removeLocation(CustomParameters.currentFirebaseUser.uid);
  }

  static void enableHomTabLocationUpdates() {
    CustomParameters.homeTabPositionStream.resume();
    Geofire.setLocation(CustomParameters.currentFirebaseUser.uid, CustomParameters.currentPosition.latitude!,
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



  static void handleOnlineStatus(String uid){
    // Fetch the current user's ID from Firebase Authentication.

    var userStatusDatabaseRef = FirebaseDatabase.instance.reference().child(
        'statusFactors/drivers/' + uid);
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
      userStatusDatabaseRef.onDisconnect().set(isOfflineForDatabase).then((value) {
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



}