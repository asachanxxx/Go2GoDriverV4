import 'dart:async';
import 'dart:io';


// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/TripDetails.dart';
import 'package:my_cab_driver/widgets/wgt_notificationdialog.dart';
import 'package:my_cab_driver/widgets/wgt_progressdialog.dart';


class PushNotificationService {
  //final FirebaseMessaging fcm = FirebaseMessaging();
  late String rideID;

  FutureOr<dynamic> setToken(String? token) {
    print('token1: $token');

    CustomParameters.token = token!;
    DatabaseReference tokenRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile/token');
    tokenRef.set(CustomParameters.token);

  }



  Future initialize(context, LatLng pos) async {

    print('=================== Initialize FCM Started ===================');
    Stream<String> _tokenStream;
    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('message ${message.messageId}');
      print('========================  Remote message Received ==================');
      RemoteNotification? notification = message.notification;
      if(message !=null) {
        print('message.dataSet ${message.data}');
        print('ride_id ${message.data != null? message.data['ride_id'] : " ride_id is null"}');
        rideID = message.data != null? message.data['ride_id'] : "empty";
      }else{
        print('Message object is null');
      }


      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        CustomParameters.flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            message.data['ride_id'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                CustomParameters.channel.id,
                CustomParameters.channel.name,
                channelDescription: CustomParameters.channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
                color: Colors.redAccent,
                playSound: true,
              ),
            ));
      }

      if(rideID != 'empty'){
        print('ride id not empty preceding to fetchRideInfo');
        fetchRideInfo(message.data['ride_id'], context, pos);
      }else{
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) => Text("Problem with the ride request.")
        );
      }
    });
  }

  void fetchRideInfo(String rideID, context, LatLng pos) {
    print('Inside the fetchRideInfo');
    if (!CustomParameters.isOnline) {
      print('Driver is not online. existing the system');
      return;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          ProgressDialog(
            status: 'Fetching details',circularProgressIndicatorColor: Colors.redAccent
          ),
    );

    DatabaseReference rideRef =
    FirebaseDatabase.instance.reference().child('rideRequest/$rideID');
    rideRef.once().then((DataSnapshot snapshot) {
      Navigator.pop(context);

      if (snapshot.value != null) {

        // CustomParameters.assetsAudioPlayer.open(
        //   Audio('sounds/alert.mp3'),
        //   loopMode: LoopMode.single,
        // );
        // CustomParameters.assetsAudioPlayer.play();



        print('Inside Data SnapShot....');
        if (snapshot != null) {
          if (snapshot.value != null) {

            double pickupLat =
            double.parse(snapshot.value['location']['latitude'].toString());
            double pickupLng =
            double.parse(snapshot.value['location']['longitude'].toString());
            String pickupAddress = snapshot.value['pickup_address'].toString();
            double destinationLat =
            double.parse(snapshot.value['destination']['latitude'].toString());
            double destinationLng =
            double.parse(snapshot.value['destination']['longitude'].toString());

            print('Extracted pickup and destination locations....');

            String destinationAddress = snapshot.value['destination_address'];
            String paymentMethod = snapshot.value['payment_method'];
            String riderName = snapshot.value['rider_name'];
            String riderPhone = snapshot.value['rider_phone'];
            TripDetails tripDetails = TripDetails(
                pickupAddress: pickupAddress,
                rideID: rideID,
                destinationAddress: destinationAddress,
                destination:  LatLng(destinationLat, destinationLng),
                pickup: LatLng(pickupLat, pickupLng),
                paymentMethod: paymentMethod,
                riderName: riderName,
                riderPhone: riderPhone,
                status: '', bookingID:  "");

            print('TripDetails object created....');


            if (snapshot.value['ownDriver'] != null) {
              tripDetails.commissionedDriverId = "system";
              tripDetails.commissionApplicable = false;
            } else if (snapshot.value['ownDriver'] == "system") {
              tripDetails.commissionedDriverId = "system";
              tripDetails.commissionApplicable = false;
            } else {
              tripDetails.commissionedDriverId = snapshot.value['ownDriver'];
              tripDetails.commissionApplicable = true;
            }

            print('Fetch Ride Info: driverID= ${tripDetails.commissionedDriverId} commissionApplicable = ${tripDetails.commissionApplicable}');

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) =>
                  NotificationDialog(
                    tripDetails: tripDetails,
                  ),
            );
          } else {
            print('Data SnapShot value is null');
          }
        } else {
          print('Data SnapShot is null');
        }
      }
    });
  }

  String getRideID(Map<String, dynamic> message) {
    String rideID = '';

    if (Platform.isAndroid) {
      rideID = message['data']['ride_id'];
    } else {
      rideID = message['ride_id'];
      print('ride_id: $rideID');
    }
    print('getRideID ride_id : $rideID');
    return rideID;
  }
}
