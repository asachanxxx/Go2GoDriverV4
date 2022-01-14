import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';

class DailyParameters {
  double earning = 0.00;
  double commission = 0.00;
  int driveHours = 0;
  double totalDistance = 0.00;
  int totalTrips = 0;

  DailyParameters({
    required this.earning,
    required this.commission,
    required this.driveHours,
    required this.totalDistance,
    required this.totalTrips,
  });

  DailyParameters.fromSnapshot(DataSnapshot snapshot) {
    earning = snapshot.value['earning'] != null
        ? double.parse(snapshot.value['earning'].toString())
        : 0.00;
    commission = snapshot.value['commission'] != null
        ? double.parse(snapshot.value['commission'].toString())
        : 0.00;
    driveHours = snapshot.value['driveHours'] != null
        ? snapshot.value['driveHours']
        : 0.00;
    totalDistance = snapshot.value['totalDistance'] != null
        ? double.parse(snapshot.value['totalDistance'].toString())
        : 0.00;
    totalTrips =
        snapshot.value['totalTrips'] != null ? snapshot.value['totalTrips'] : 0;
    // earning = CustomParameters.roundUp(double.parse(snapshot.value['earning'] != null ? snapshot.value['earning'] :0.00));
    // commission = CustomParameters.roundUp(double.parse(snapshot.value['commission'] != null ? snapshot.value['commission'] : 0.00));
    // driveHours = CustomParameters.roundUp(double.parse(snapshot.value['driveHours'] != null ? snapshot.value['driveHours'] :0.00));
    // totalDistance = CustomParameters.roundUp(double.parse(snapshot.value['totalDistance'] != null ? snapshot.value['totalDistance'] : 0.00));
    // totalTrips = snapshot.value['totalTrips'] != null ? snapshot.value['totalTrips'] :0;
  }
}
