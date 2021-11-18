import 'package:firebase_database/firebase_database.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';


class DateWiseSummary {
  double totalCommission = 0.00;
  double totalEarning= 0.00;
  double totalKMs= 0.00;
  double totalTime= 0.00;
  double kmPrice= 0.00;
  double timePrice= 0.00;
  double totalFare= 0.00;

  DateWiseSummary(this.totalCommission, this.totalEarning, this.totalKMs, this.totalTime,
      this.kmPrice,this.totalFare,this.timePrice
      );

  DateWiseSummary.consturct(
      this.totalCommission,
      this.totalEarning,
      this.totalTime,
      this.totalKMs,
      this.kmPrice,
      this.timePrice,
      this.totalFare,
      );

  DateWiseSummary.fromShapShot(DataSnapshot snapshot) {
    this.totalCommission = CustomParameters.roundUp(double.parse(snapshot.value['totalCommission'].toString()));
    this.totalEarning = CustomParameters.roundUp(double.parse(snapshot.value['totalEarning'].toString()));
    this.totalTime = CustomParameters.roundUp(double.parse(snapshot.value['totalTime'].toString()));
    this.totalKMs = CustomParameters.roundUp(double.parse(snapshot.value['totalKMs'].toString()));
    this.kmPrice = CustomParameters.roundUp(double.parse(snapshot.value['kmPrice'].toString()));
    this.timePrice = CustomParameters.roundUp(double.parse(snapshot.value['timePrice'].toString()));
    this.totalFare = CustomParameters.roundUp(double.parse(snapshot.value['totalFare'].toString()));

  }


}

class CashFlows {
  double debit = 0.00;
  double credit = 0.00;

  CashFlows(this.debit, this.credit);

  CashFlows.consturct(
      this.debit,
      this.credit,
      );

  CashFlows.fromShapShot(DataSnapshot snapshot) {
    this.debit = CustomParameters.roundUp(double.parse(snapshot.value['debit'].toString()));
    this.credit = CustomParameters.roundUp(double.parse(snapshot.value['credit'].toString()));
  }



}
