import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';


class Driver {
  String fullName ="";
  String email="";
  String phone="";
  String id="";
  String carMake="";
  String carModel="";
  String carColor="";
  String vehicleNumber="";
  String driverLevel="";
  String nic="";
  double SCR=0.00;
  double ODR=0.00;

  Driver(
      {required this.fullName,
        required this.email,
        required this.phone,
        required this.id,
        required this.carModel,
        required this.carColor,
        required this.vehicleNumber,
        required this.SCR,
        required this.ODR,
        required this.nic,
        required this.driverLevel
      });

  Driver.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.value['key'];
    phone = snapshot.value['phoneNumber'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullName'];
    nic = snapshot.value['nic'];
    driverLevel = snapshot.value['driverLevel'];
    SCR = CustomParameters.roundUp(double.parse(snapshot.value['SCR'].toString()));
    ODR = CustomParameters.roundUp(double.parse(snapshot.value['ODR'].toString()));
  }
}
