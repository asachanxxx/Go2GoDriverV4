import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/Services/commonService.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/TripDetails.dart';
import 'package:my_cab_driver/pickup/pickupScreen.dart';
import 'package:my_cab_driver/widgets/devider_widget.dart';
import 'package:my_cab_driver/widgets/wgt_progressdialog.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationDialog extends StatelessWidget {
  final TripDetails tripDetails;

  NotificationDialog({required this.tripDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Theme.of(context).dividerColor,
      child: Container(

        margin: EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black26,
            border: Border.all(color:Theme.of(context).primaryColor)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            // Image.asset(
            //   'assets/images/taxi.png',
            //   width: 100,
            // ),
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                  'assets/images/taxi.png',

              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'NEW TRIP REQUEST',
              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/pickicon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                          child: Container(
                              child: Text(
                                tripDetails.pickupAddress,
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),

                              )))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/desticon.png',
                        height: 16,
                        width: 16,
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                          child: Container(
                              child: Text(
                                tripDetails.destinationAddress,
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                              )))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BrandDivider(),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child:
                    // Container(
                    //   child: TaxiOutlineButton(
                    //     title: 'DECLINE',
                    //     color: BrandColors.colorPrimary,
                    //     onPressed: () async {
                    //       //await CustomParameters.assetsAudioPlayer.stop();
                    //       Navigator.pop(context);
                    //     },
                    //   ),
                    // ),

                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        FlutterRingtonePlayer.stop();
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).textTheme.headline6!.color,
                          border: Border.all(color:Theme.of(context).primaryColor)
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of('Decline'),
                            style: Theme.of(context).textTheme.button!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child:
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        FlutterRingtonePlayer.stop();
                        print('Request Accepted..');
                        checkAvailablity(context);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).textTheme.headline6!.color,
                          border: Border.all(color:Theme.of(context).primaryColor)
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of('Accept'),
                            style: Theme.of(context).textTheme.button!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  void checkAvailablity(context) {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Accepting request',circularProgressIndicatorColor: Colors.redAccent,
      ),
    );

    DatabaseReference newRideRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile/newtrip');

    newRideRef.once().then((DataSnapshot snapshot) {

      print('Inside DataSnapshot.. On Location drivers/${CustomParameters.currentFirebaseUser.uid}/profile/newtrip');

      //Navigator.pop(context);
      Navigator.pop(context);

      String thisRideID = "";
      if (snapshot.value != null) {
        thisRideID = snapshot.value.toString();
      } else {
        print("Ride not found 1");
      }
      if (thisRideID == tripDetails.rideID) {
        print('thisRideID check pass.');

        newRideRef.set('accepted');
        DatabaseReference newRideRefRideID = FirebaseDatabase.instance
            .reference()
            .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile/rideId');
        newRideRefRideID.set(tripDetails.rideID.trim());
        print('Ride id set to Location : drivers/${CustomParameters.currentFirebaseUser.uid}/profile/rideId');
        CustomParameters.rideRef = FirebaseDatabase.instance
            .reference()
            .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile');
        CustomParameters.rideRef.child("inMiddleOfTrip").set("true");

        DatabaseReference newRideRefRide = FirebaseDatabase.instance
            .reference()
            .child('rideRequest/${tripDetails.rideID.trim()}/status');
        newRideRefRide.set('accepted');
        tripDetails.status = 'accepted';
        tripDetails.bookingID = "NA";
        print('=================== FCM Tran Ended Loading NewTripPage ===================');

        ///This will remove the incoming data stream to him cus he is on a trip
        CommonService.disableHomTabLocationUpdates();

        //changedx1
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PickupScreen(
                tripDetails: tripDetails,
                restartRide: false,
                incomeType: 1,
              ),
            ));


      } else if (thisRideID == 'cancelled') {
        print("Ride has been cancelled");
        cancelOrTimeout(true);
      } else if (thisRideID == 'timeout') {
        cancelOrTimeout(false);
        print("Ride has timed out");
      } else {
        print("Ride not found 2");
      }
    });
  }

  static void showToast(BuildContext context, String text) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text("Contact administrator ERR:  $text"),
        action: SnackBarAction(
            label: 'Hide', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void cancelOrTimeout(bool isCancelled) {
    // after ending ride the drivers newtrip status must set to waiting
    if (tripDetails != null) {
      CustomParameters.rideRef = FirebaseDatabase.instance
          .reference()
          .child('drivers/${CustomParameters.currentDriverInfo.id}/profile');
      CustomParameters.rideRef.child("newtrip").set("waiting");

      CustomParameters.rideRef = FirebaseDatabase.instance
          .reference()
          .child('unCompletedTrips/${CustomParameters.currentDriverInfo.id}');

      String statusStr = "TimeOut";
      if (isCancelled) {
        statusStr = "Cancelled";
      }

      Map cancelledTrip = {
        "rideID": tripDetails.rideID,
        "driverID": CustomParameters.currentFirebaseUser.uid,
        "status": statusStr
      };
      CustomParameters.rideRef.set(cancelledTrip);
    } else {
      // /showToast(context,"ERR_DR_002");
    }
  }

  void _launchMapsUrl(LatLng _originLatLng, LatLng _destinationLatLng) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${_originLatLng.latitude},${_originLatLng.longitude}&destination=${_destinationLatLng.latitude},${_destinationLatLng.longitude}&travelmode=driving';
    if (await canLaunch(url)) {
      print("Launching map.... $url");
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
