import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/DateWiseSummary.dart';
import 'package:my_cab_driver/models/dailyParameters.dart';

class FinanceService {
  static Future<void> handleDailyFinance(dailyFinanceMap) {
    DateTime date = DateTime.now();
    String timeKey =
        "${date.day.toString().padLeft(2, '0')}${date.month.toString().padLeft(2, '0')}${date.year}";

    DatabaseReference userRef = FirebaseDatabase.instance.reference().child(
        'drivers/${CustomParameters.currentFirebaseUser.uid}/finance/$timeKey');
    userRef.once().then((DataSnapshot snapshot) {
      print(
          'snapshot handleDailyFinance ${snapshot.value} and dailyFinanceMap["earning"] ${dailyFinanceMap['earning']}');
      if (snapshot.value != null) {
        Map dailyFinanceRevisedMap = {
          'earning': snapshot.value['earning'] + dailyFinanceMap['earning'],
          'commission':
              snapshot.value['commission'] + dailyFinanceMap['commission'],
          'driveHours':
              snapshot.value['driveHours'] + dailyFinanceMap['driveHours'],
          'totalDistance': snapshot.value['totalDistance'] +
              dailyFinanceMap['totalDistance'] / 1000,
          'totalTrips':
              snapshot.value['totalTrips'] + dailyFinanceMap['totalTrips'],
        };
        var userStatusDatabaseRef = FirebaseDatabase.instance.reference().child(
            'drivers/${CustomParameters.currentFirebaseUser.uid}/finance/$timeKey');
        userStatusDatabaseRef.remove();
        userStatusDatabaseRef.set(dailyFinanceRevisedMap);
      } else {
        var userStatusDatabaseRef = FirebaseDatabase.instance.reference().child(
            'drivers/${CustomParameters.currentFirebaseUser.uid}/finance/$timeKey');
        userStatusDatabaseRef.set(dailyFinanceMap);
      }
    });
    return Future.value();
  }

  static Future<DailyParameters?> getDailyFinance() async {
    DateTime date = DateTime.now();
    DailyParameters dailyParameters = DailyParameters(
        earning: 0.00,
        commission: 0.00,
        driveHours: 0,
        totalDistance: 0.00,
        totalTrips: 0);
    String timeKey =
        "${date.day.toString().padLeft(2, '0')}${date.month.toString().padLeft(2, '0')}${date.year}";
    DatabaseReference userRef = FirebaseDatabase.instance.reference().child(
        'drivers/${CustomParameters.currentFirebaseUser.uid}/finance/$timeKey');
    await userRef.once().then((DataSnapshot snapshot) {
      print('snapshot ${snapshot.value}');
      if (snapshot.value != null) {
        dailyParameters = DailyParameters.fromSnapshot(snapshot);
      } else {
        Map dailyFinanceRevisedMap = {
          'earning': 0.01,
          'commission': 0.01,
          'driveHours': 0,
          'totalDistance': 0.01,
          'totalTrips': 0,
        };
        var userStatusDatabaseRef = FirebaseDatabase.instance.reference().child(
            'drivers/${CustomParameters.currentFirebaseUser.uid}/finance/$timeKey');
        userStatusDatabaseRef.set(dailyFinanceRevisedMap);
      }
    });
    return dailyParameters;
  }

  static Future<DateWiseSummary> getdateWiseSummary(context) async {
    var datestring = makeDateString();
    var snapShotx = await FirebaseDatabase.instance
        .reference()
        .child(
            'drivers/${CustomParameters.currentFirebaseUser.uid}/dateWiseSummary/$datestring')
        .once();
    if (snapShotx.value == null) {
      var summary = DateWiseSummary(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
      await earningTryOut(summary);
      return Future.value(summary);
    } else {
      var dateWiseSummary = DateWiseSummary.fromShapShot(snapShotx);
      return dateWiseSummary;
    }
  }

  static Future<CashFlows> getCashDlows(context) async {
    var snapShotx = await FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/cashFlows')
        .once();
    if (snapShotx.value == null) {
      var summary = CashFlows(0, 0);
      await updateCashFlows(summary);
      return Future.value(summary);
    } else {
      var cashFlows = CashFlows.fromShapShot(snapShotx);
      print("getCashDlows YYYY ${snapShotx.value}");
      return cashFlows;
    }
  }

  static Future<bool> earningTryOut(DateWiseSummary summary) async {
    var datestring = makeDateString();
    print(
        "earnignTryOut Firebase Path ${'drivers/${CustomParameters.currentFirebaseUser.uid}/$datestring'}");
    var reg = FirebaseDatabase.instance.reference().child(
        'drivers/${CustomParameters.currentFirebaseUser.uid}/dateWiseSummary/$datestring');

    Map datramap = {
      "totalEarning": summary.totalEarning,
      "totalCommission": summary.totalCommission,
      "totalTime": summary.totalTime,
      "totalKMs": summary.totalKMs,
      "totalFare": summary.totalFare,
      "timePrice": summary.timePrice,
      "kmPrice": summary.kmPrice,
    };

    await reg.set(datramap);
    return Future.value(true);
  }

  static Future<bool> updatedateWiseSummary(DateWiseSummary summary) async {
    var datestring = makeDateString();
    DateWiseSummary exDateWiseSummary;
    var exxistingValue = await FirebaseDatabase.instance
        .reference()
        .child(
            'drivers/${CustomParameters.currentFirebaseUser.uid}/dateWiseSummary/$datestring')
        .once();

    if (exxistingValue.value != null) {
      exDateWiseSummary = DateWiseSummary.fromShapShot(exxistingValue);
    } else {
      exDateWiseSummary = DateWiseSummary(0, 0, 0, 0, 0, 0, 0);
    }

    var reg = FirebaseDatabase.instance.reference().child(
        'drivers/${CustomParameters.currentFirebaseUser.uid}/dateWiseSummary/$datestring');

    Map datramap = {
      "totalEarning": summary.totalEarning + exDateWiseSummary.totalEarning,
      "totalCommission":
          summary.totalCommission + exDateWiseSummary.totalCommission,
      "totalTime": summary.totalTime + exDateWiseSummary.totalTime,
      "totalKMs": summary.totalKMs + exDateWiseSummary.totalKMs,
      "totalFare": summary.totalFare + exDateWiseSummary.totalFare,
      "timePrice": summary.timePrice + exDateWiseSummary.timePrice,
      "kmPrice": summary.kmPrice + exDateWiseSummary.kmPrice,
    };

    await reg.set(datramap);
    return Future.value(true);
  }

  static String makeDateString() {
    var datestring =
        "${DateTime.now().year.toString()}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}";
    print("makeDateString -> $datestring");
    return datestring;
  }

  static Future<bool> updateEarningOnly(double earning) async {
    double exValue = 0;
    var datestring = makeDateString();
    print(
        "updateEarningOnly Firebase Path ${'drivers/${CustomParameters.currentFirebaseUser.uid}/dateWiseSummary/$datestring/totalEarning'}");

    var exxistingValue = await FirebaseDatabase.instance
        .reference()
        .child(
            'drivers/${CustomParameters.currentFirebaseUser.uid}/dateWiseSummary/$datestring/totalEarning')
        .once();
    print("exxistingValue = ${exxistingValue.value}");

    if (exxistingValue.value == null) {
      exValue = 0;
    } else {
      exValue = double.parse(exxistingValue.value.toString());
    }

    await FirebaseDatabase.instance
        .reference()
        .child(
            'drivers/${CustomParameters.currentFirebaseUser.uid}/dateWiseSummary/$datestring/totalEarning')
        .set(exValue + earning);
    return Future.value(true);
  }

  static Future<bool> updateCashFlows(CashFlows summary) async {
    CashFlows exDateWiseSummary;
    var exxistingValue = await FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/cashFlows/')
        .once();

    if (exxistingValue.value != null) {
      exDateWiseSummary = CashFlows.fromShapShot(exxistingValue);
    } else {
      exDateWiseSummary = CashFlows(0, 0);
    }

    var reg = FirebaseDatabase.instance.reference().child(
        'drivers/${CustomParameters.currentFirebaseUser.uid}/cashFlows/');

    Map datramap = {
      "debit": summary.debit + exDateWiseSummary.debit,
      "credit": summary.credit + exDateWiseSummary.credit,
    };

    await reg.set(datramap);
    return Future.value(true);
  }
}
