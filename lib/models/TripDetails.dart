import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails {
  String destinationAddress ="";
  String pickupAddress;
  LatLng pickup;
  LatLng destination;
  LatLng driverLocation = new LatLng(80.00, 79.00);
  String rideID;
  String paymentMethod;
  String riderName;
  String riderPhone;
  bool commissionApplicable = false;
  String commissionedDriverId ="";
  String status;
  String bookingID;

  TripDetails({
    required this.pickupAddress,
    required this.rideID,
    required this.destinationAddress,
    required this.destination,
    required this.pickup,
    required this.paymentMethod,
    required this.riderName,
    required this.riderPhone,
    required this.status,
    required this.bookingID
  });

}