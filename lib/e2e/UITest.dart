import 'dart:async';
import 'dart:math';

import 'package:background_location/background_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab_driver/Services/commonService.dart';
import 'package:my_cab_driver/auth/documentInfo.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/documentManagement/docManagementScreen.dart';
import 'package:my_cab_driver/documentManagement/drivingLicenseScreen.dart';
import 'package:my_cab_driver/history/historyScreen.dart';
import 'package:my_cab_driver/home/chatScreen.dart';
import 'package:my_cab_driver/home/homeScreen.dart';
import 'package:my_cab_driver/home/riderList.dart';
import 'package:my_cab_driver/home/userDetail.dart';
import 'package:my_cab_driver/introduction/LocationScreen.dart';
import 'package:my_cab_driver/introduction/introductionScreen.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/Driver.dart';
import 'package:my_cab_driver/models/PushNotificationService.dart';
import 'package:my_cab_driver/models/TripDetails.dart';
import 'package:my_cab_driver/models/VehicleInfomation.dart';
import 'package:my_cab_driver/notification/notificationScree.dart';
import 'package:my_cab_driver/pickup/pickupScreen.dart';
import 'package:my_cab_driver/pickup/ticketScreen.dart';
import 'package:my_cab_driver/setting/myProfile.dart';
import 'package:my_cab_driver/setting/settingScreen.dart';
import 'package:my_cab_driver/vehicalManagement/addVehicalScreen.dart';
import 'package:my_cab_driver/vehicalManagement/vehicalmanagementScreen.dart';
import 'package:my_cab_driver/wallet/myWallet.dart';
import 'package:my_cab_driver/wallet/paymentMethod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';

class UiTest extends StatefulWidget {
  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<UiTest> {
  var appBarheight = 20.0;
  int _counter = 0;
  late Location oldPosition2;
  late double totalDistance = 0.00;

  String latitude = 'waiting...';
  String longitude = 'waiting...';
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';


  @override
  Widget build(BuildContext context) {
    appBarheight = AppBar().preferredSize.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child:
        Center(
          child: ListView(
            children: <Widget>[
              locationData('Latitude: ' + latitude),
              locationData('Longitude: ' + longitude),
              locationData('Altitude: ' + altitude),
              locationData('Accuracy: ' + accuracy),
              locationData('Bearing: ' + bearing),
              locationData('Speed: ' + speed),
              locationData('Time: ' + time),
              ElevatedButton(
                  onPressed: () async {
                    await startLocationUpdate();

                  },
                  child: Text('Start Location Service')),
              ElevatedButton(
                  onPressed: () {
                    BackgroundLocation.stopLocationService();
                  },
                  child: Text('Stop Location Service')),
              ElevatedButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  child: Text('Get Current Location')),
              ElevatedButton(
                  onPressed: () async {
                    final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
                    var serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
                    //Position? position = await Geolocator.getLastKnownPosition();
                    print("position $serviceEnabled");


                  },
                  child: Text('GetStatic Loc')),
            ],
          ),
        ),



        // SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.only(right: 14, left: 14),
        //     child: Column(
        //       children: <Widget>[
        //         Padding(
        //           padding: const EdgeInsets.only(right: 32, left: 32),
        //           child: Column(
        //             children: <Widget>[
        //               SizedBox(height: 40,),
        //
        //
        //               // Row(
        //               //   crossAxisAlignment: CrossAxisAlignment.end,
        //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //   children: <Widget>[
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => ChatScreen(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('ChatScreen'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => RiderList(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('RiderList'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //   ],
        //               // ),
        //               // SizedBox(height: 10,),
        //               //
        //               // /// ********************************** ********************************** ********************************** ********************************** **********************************
        //               //
        //               // Row(
        //               //   crossAxisAlignment: CrossAxisAlignment.end,
        //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //   children: <Widget>[
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => UserDetailScreen(userId: 1),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('UserDetailScreen'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => HistoryScreen(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('HistoryScreen'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //   ],
        //               // ),
        //               // SizedBox(height: 10,),
        //               // /// ********************************** ********************************** ********************************** ********************************** **********************************
        //               // Row(
        //               //   crossAxisAlignment: CrossAxisAlignment.end,
        //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //   children: <Widget>[
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => IntroductionScreen(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('IntroductionScreen'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => EnableLocation(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('EnableLocation'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //   ],
        //               // ),
        //               // SizedBox(height: 10,),
        //               // /// ********************************** ********************************** ********************************** ********************************** **********************************
        //               // Row(
        //               //   crossAxisAlignment: CrossAxisAlignment.end,
        //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //   children: <Widget>[
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => NotificationScreen(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('NotificationScreen'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         // Navigator.push(
        //               //         //   context,
        //               //         //   MaterialPageRoute(
        //               //         //     builder: (context) => PickupScreen(),
        //               //         //   ),
        //               //         // );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('PickupScreen'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //   ],
        //               // ),
        //               // SizedBox(height: 10,),
        //               // /// ********************************** ********************************** ********************************** ********************************** **********************************
        //               // Row(
        //               //   crossAxisAlignment: CrossAxisAlignment.end,
        //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //   children: <Widget>[
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => TicketScreen(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('TicketScreen'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => MyProfile(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('MyProfile'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //   ],
        //               // ),
        //               // SizedBox(height: 10,),
        //               // /// ********************************** ********************************** ********************************** ********************************** **********************************
        //               // Row(
        //               //   crossAxisAlignment: CrossAxisAlignment.end,
        //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //   children: <Widget>[
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => SettingScreen(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('SettingScreen'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => AddNewVehical(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('AddNewVehical'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //   ],
        //               // ),
        //               // SizedBox(height: 10,),
        //               // /// ********************************** ********************************** ********************************** ********************************** **********************************
        //               // Row(
        //               //   crossAxisAlignment: CrossAxisAlignment.end,
        //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //   children: <Widget>[
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => VehicalManagement(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('VehicalManagement'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => MyWallet(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('MyWallet'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //   ],
        //               // ),
        //               // SizedBox(height: 10,),
        //               // /// ********************************** ********************************** ********************************** ********************************** **********************************
        //               // Row(
        //               //   crossAxisAlignment: CrossAxisAlignment.end,
        //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //   children: <Widget>[
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => PaymentMethod(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('PaymentMethod'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => DocmanagementScreen(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('Docmanagement'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //   ],
        //               // ),
        //               // SizedBox(height: 10,),
        //               //
        //               // /// ********************************** ********************************** ********************************** ********************************** **********************************
        //               // Row(
        //               //   crossAxisAlignment: CrossAxisAlignment.end,
        //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //   children: <Widget>[
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => DrivingLicenseScreen(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('DrivingLicense'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => DocumentInfo(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('DocumentInfo'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //   ],
        //               // ),
        //               // SizedBox(height: 10,),
        //               // /// ********************************** ********************************** ********************************** ********************************** **********************************
        //               // Row(
        //               //   crossAxisAlignment: CrossAxisAlignment.end,
        //               //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //               //   children: <Widget>[
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         Navigator.push(
        //               //           context,
        //               //           MaterialPageRoute(
        //               //             builder: (context) => HomeScreen(),
        //               //           ),
        //               //         );
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('HomeScreen'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //     InkWell(
        //               //       highlightColor: Colors.transparent,
        //               //       splashColor: Colors.transparent,
        //               //       onTap: () async{
        //               //         checkAvailablity(context);
        //               //       },
        //               //       child: Container(
        //               //         height: 40,
        //               //         width: 150,
        //               //         decoration: BoxDecoration(
        //               //           borderRadius: BorderRadius.circular(10),
        //               //           color: Theme.of(context).textTheme.headline6!.color,
        //               //         ),
        //               //         child: Center(
        //               //           child: Text(
        //               //             AppLocalizations.of('NewTripPage'),
        //               //             style: Theme.of(context).textTheme.button!.copyWith(
        //               //               fontWeight: FontWeight.bold,
        //               //               color: Theme.of(context).scaffoldBackgroundColor,
        //               //             ),
        //               //           ),
        //               //         ),
        //               //       ),
        //               //     ),
        //               //
        //               //   ],
        //               // ),
        //               // SizedBox(height: 10,),
        //
        //
        //
        //
        //
        //
        //
        //
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),




      ),
    );
  }

  Widget locationData(String data) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  void getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print('This is current Location ' + location.toMap().toString());
    });
  }


  Future<void> startLocationUpdate() async {
    double totalFare = 0.00;
    double totalTime = 0;
    double totalWaiting = 0;
    double totalSpeed = 0;
    double kmPrice = 45;
    String accuracy = "0";
    CustomParameters.currentPosition =
        Location(longitude: 6.877317676732788, latitude: 79.9899282496178);
    oldPosition2 = Location(
        longitude: CustomParameters.currentPosition.longitude,
        latitude: CustomParameters.currentPosition.latitude);
    print("New trip Point 4");
    var permission = await Permission.locationAlways.isGranted;
    if (!permission) {
      var permisisonState = await Permission.locationAlways.request();
      if (permisisonState.isDenied || permisisonState.isPermanentlyDenied) {
        //showToast(context,"Permission has not granted to use location.");
        print("New trip Point 5");
        Navigator.pop(context);
        //return;
      }
    } else {
      //showToast(context,"Permission has not granted to use location.");
      //Navigator.pop(context);
      //return;
      print("New trip Point 6");
    }
    print("New trip Point 7");
    BackgroundLocation.stopLocationService();
    BackgroundLocation.setAndroidConfiguration(2000);
    await BackgroundLocation.setAndroidNotification(
      title: "Go2Go Background location",
      message: "Go2Go Background location in progress",
      icon: "@mipmap/ic_launcher",
    );
    print("New trip Point 8");
    await BackgroundLocation.startLocationService(distanceFilter: 20);

    BackgroundLocation.getLocationUpdates((location) {
      print("New trip Point 9");
      try {
        CustomParameters.currentPosition = location;
        LatLng pos = LatLng(location.latitude!, location.longitude!);
        setState(() {
          accuracy = location.accuracy!.toStringAsFixed(0);
          totalSpeed = location.speed! as double;
          var oldPos = oldPosition2 ?? location;
          totalDistance = totalDistance + calculateDistance(
              oldPos.latitude, oldPos.longitude, location.latitude,
              location.longitude);
          print("distance  $totalDistance");
        });
        oldPosition2 = location;
      }
      catch (e) {
        print('Error in updates ${e}');
      }
    });
    print("New trip Point 10");
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double CalDistance(Location pos1, Location pos2, DistanceType type) {
    print("pos1 : ${pos1.latitude} pos2: ${pos2.latitude}");
    double R = (type == DistanceType.Miles) ? 3960 : 6371;
    double dLat = toRadian(pos2.latitude! - pos1.latitude!);
    double dLon = toRadian(pos2.longitude! - pos1.longitude!);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadian(pos1.latitude!)) * cos(toRadian(pos2.latitude!)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * asin(min(1, sqrt(a)));
    double d = R * c;
    return d;
  }

  double toRadian(double val) {
    return (pi / 180) * val;
  }






  void checkAvailablity(context) {
    DatabaseReference rideRef =
    FirebaseDatabase.instance.reference().child('rideRequest/-MnzFxHE5Rx0DOACowpj');
    rideRef.once().then((DataSnapshot snapshot) {
      // Navigator.pop(context);
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

        String destinationAddress = snapshot.value['destination_address'];
        String paymentMethod = snapshot.value['payment_method'];
        String riderName = snapshot.value['rider_name'];
        String riderPhone = snapshot.value['rider_phone'];

        TripDetails tripDetails = TripDetails(pickupAddress: pickupAddress,
            rideID: '-MnzFxHE5Rx0DOACowpj',
            destinationAddress: destinationAddress,
            destination: LatLng(destinationLat, destinationLng),
            pickup: LatLng(pickupLat, pickupLng),
            paymentMethod: paymentMethod,
            riderName: riderName,
            riderPhone: riderPhone,
            status: '',
            bookingID: "NA"

        );

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
        CustomParameters.currentPosition =
            Location(longitude: 6.877317676732788, latitude: 79.9899282496178);
        //getLocationUpdates();
        Navigator.pop(context);
        //CommonService.disableHomTabLocationUpdates();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PickupScreen(
                tripDetails: tripDetails,
                restartRide: true,
                incomeType: 1,
              ),
            ));
      }else{
        var ref = FirebaseDatabase.instance.reference().child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile/inMiddleOfTrip');
        ref.set(false);
        Navigator.pop(context);
      }
    });
  }

  double earnings =0.00;

  void getLocationUpdates() {
    CustomParameters.homeTabPositionStream = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 2)
        .listen((Position position) {
      CustomParameters.currentPosition = new Location(longitude: position.longitude,latitude: position.latitude);
      Geofire.setLocation(
          CustomParameters.currentFirebaseUser.uid, position.latitude, position.longitude);
      LatLng pos = LatLng(position.latitude, position.longitude);

    });
  }


}
