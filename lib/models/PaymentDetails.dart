import 'package:google_maps_flutter/google_maps_flutter.dart';

class PaymentDetails {
  String destinationAddress;
  String pickupAddress;
  String rideID;
  double kmPrice;
  double appPrice;
  double timePrice;
  double totalFare;
  double companyPayable;
  bool commissionApplicable;
  double commission;


  PaymentDetails({
    required this.pickupAddress,
    required this.destinationAddress,
    required this.rideID,
    required this.kmPrice,
    required this.appPrice,
    required this.timePrice,
    required this.totalFare,
    required this.companyPayable,
    required this.commissionApplicable,
    required this.commission
  });

}