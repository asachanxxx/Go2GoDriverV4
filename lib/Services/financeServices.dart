import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/dailyParameters.dart';

class FinanceService {

  static Future<void> handleDailyFinance(dailyFinanceMap) {
    DateTime date = DateTime.now();
    String timeKey = "${date.day.toString().padLeft(2, '0')}${date.month
        .toString().padLeft(2, '0')}${date.year}";

    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser
        .uid}/finance/$timeKey');
     userRef.once().then((DataSnapshot snapshot) {
      print('snapshot handleDailyFinance ${snapshot.value} and dailyFinanceMap["earning"] ${dailyFinanceMap['earning']}');
      if(snapshot.value != null){
        Map dailyFinanceRevisedMap = {
          'earning': snapshot.value['earning'] +dailyFinanceMap['earning'],
          'commission': snapshot.value['commission'] +dailyFinanceMap['commission'],
          'driveHours': snapshot.value['driveHours'] +dailyFinanceMap['driveHours'],
          'totalDistance': snapshot.value['totalDistance'] +dailyFinanceMap['totalDistance'],
          'totalTrips': snapshot.value['totalTrips'] +dailyFinanceMap['totalTrips'],
        };
        var userStatusDatabaseRef = FirebaseDatabase.instance.reference().child(
            'drivers/${CustomParameters.currentFirebaseUser
                .uid}/finance/$timeKey');
        userStatusDatabaseRef.remove();
        userStatusDatabaseRef.set(dailyFinanceRevisedMap);
      }else{
        var userStatusDatabaseRef = FirebaseDatabase.instance.reference().child(
            'drivers/${CustomParameters.currentFirebaseUser
                .uid}/finance/$timeKey');
        userStatusDatabaseRef.set(dailyFinanceMap);
      }
    });
    return Future.value();
  }


  static Future<DailyParameters?> getDailyFinance() async {
    DateTime date = DateTime.now();
    DailyParameters dailyParameters = DailyParameters(earning: 0.00,
        commission: 0.00,
        driveHours: 0.00,
        totalDistance: 0.00,
        totalTrips: 0);
    String timeKey = "${date.day.toString().padLeft(2, '0')}${date.month
        .toString().padLeft(2, '0')}${date.year}";
    DatabaseReference userRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser
        .uid}/finance/$timeKey');
    await userRef.once().then((DataSnapshot snapshot) {
      print('snapshot ${snapshot.value}');
      if(snapshot.value != null){
        dailyParameters = DailyParameters.fromSnapshot(snapshot);
      }else{
        Map dailyFinanceRevisedMap = {
          'earning': 0.01,
          'commission': 0.01,
          'driveHours': 0.01,
          'totalDistance': 0.01,
          'totalTrips': 0,
        };
        var userStatusDatabaseRef = FirebaseDatabase.instance.reference().child(
            'drivers/${CustomParameters.currentFirebaseUser
                .uid}/finance/$timeKey');
        userStatusDatabaseRef.set(dailyFinanceRevisedMap);
      }

    });
    return dailyParameters;
  }

}