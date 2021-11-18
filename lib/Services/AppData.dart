import 'package:flutter/cupertino.dart';
import 'package:my_cab_driver/models/Address.dart';
import 'package:my_cab_driver/models/DateWiseSummary.dart';


class AppData extends ChangeNotifier {
  late Address pickupAdrress;
  late Address destinationAdrress;
  late DateWiseSummary dateWiseSummary;

  void updatePickupAddress(Address picup) {
    pickupAdrress = picup;
    notifyListeners();
  }

  void updateDestinationAdrress(Address destin) {
    print('updateDestinationAdrress placeFormatAddress :- ' + destin.placeFormatAddress + " latitude " + destin.latitude.toString() + "  logitude  " + destin.logitude.toString() );

    destinationAdrress = destin;
    notifyListeners();
  }

  void updatedateWiseSummary(DateWiseSummary dws) {
    dateWiseSummary = dws;
    notifyListeners();
  }

  void updatedateWiseSummaryEarning(double newValue) {
    if(dateWiseSummary == null){
      dateWiseSummary = new DateWiseSummary(0,0,0,0,0,0,0);
    }
    dateWiseSummary.totalEarning += newValue;
    notifyListeners();
  }

}
