import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:animator/animator.dart';
import 'package:background_location/background_location.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab_driver/Services/commonService.dart';
import 'package:my_cab_driver/Services/financeServices.dart';
import 'package:my_cab_driver/Services/mapKitHelperService.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/DateWiseSummary.dart';
import 'package:my_cab_driver/models/DirectionDetails.dart';
import 'package:my_cab_driver/models/Driver.dart';
import 'package:my_cab_driver/models/PaymentDetails.dart';
import 'package:my_cab_driver/models/PushNotificationService.dart';
import 'package:my_cab_driver/models/TripDetails.dart';
import 'package:my_cab_driver/models/VehicleInfomation.dart';
import 'package:my_cab_driver/widgets/wgt_collectpaymentdialog.dart';
import 'package:my_cab_driver/widgets/wgt_progressdialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import '../appTheme.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

enum DistanceType { Miles, Kilometers }

class PickupScreen extends StatefulWidget {
  static const String Id = 'newtrippage';
  final TripDetails tripDetails;
  final bool restartRide;
  final int incomeType;
  PickupScreen({required this.tripDetails, required this.restartRide, required this.incomeType});
  @override
  _PickupScreenState createState() => _PickupScreenState();
}


class _PickupScreenState extends State<PickupScreen> {
  late Future<bool> _future;
  bool isOffline = false;

  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polyLines = Set<Polyline>();

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  late BitmapDescriptor bitmapDescriptorStartLocation;
  late BitmapDescriptor bitmapDescriptorStartLocation2;
  late BitmapDescriptor bitmapDescriptorStartLocation3;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  late GoogleMapController mapController;
  bool cancelLocationUpdate = false;
  late DatabaseReference tripRequestRef;
  double earnings = 0.0;
  var inMiddleOfTrip = false;
  var existingRideId = "";
  final Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor movingMarkerIcon;


  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
      timeInterval: 1);


  late Position myPosition;
  String status = 'init';
  String durationString = '0';
  String DistanceString = '0';
  bool isRequestingDirection = false;
  String buttonTitle = 'Drive to Customer';
  Color buttonColor = Color(0xFFff7043);
  late Timer timer;
  int durationCounter = 0;
  var timeBaseDistance = 0.0;
  String TimeSpent = "0:0";

  double cumDistance = 0;
  double cumDistanceGro = 0;
  var oldPositionLatlng;
  var oldTime;


  double totalFare = 0.00;
  double totalTime = 0;
  double totalWaiting = 0;
  double totalDistance = 0.00;
  double totalSpeed = 0;
  double kmPrice = 45;
  String infoPanel =  "Meter Ready..";
  String accuracy = "0";
  late Location oldPosition2;
  bool startSwitch = true;
  bool isWaited = true;
  bool isStopTimer = false;
  String startButtonText = "START";
  String waitButtonText = "WAIT";


  String getTimeString(DateTime dateTime) {
    return dateTime.hour.toString() +
        ":" +
        dateTime.minute.toString() +
        ":" +
        dateTime.second.toString() +
        ":" +
        dateTime.microsecond.toString();
  }

  @override
  void initState() {
    _future = initializeAll();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published! $message');
    });
    super.initState();
  }

  ///Getting driver information
  Future<void> getCurrentDriverInfo(Location currentPositionx) async {
    print("Inside getCurrentDriverInfo");
    CustomParameters.currentFirebaseUser = FirebaseAuth.instance.currentUser!;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile');

    driverRef.once().then((DataSnapshot snapshot) {
      print("HomeTab- getCurrentDriverInfo isOnlineStatus =   ${snapshot.value["onlineStatus"]}");

      if (snapshot.value != null) {
        CustomParameters.currentDriverInfo = Driver.fromSnapshot(snapshot);
        print("onlineStatus : ${snapshot.value["onlineStatus"] ?? ""}");

        if (snapshot.value["onlineStatus"] != null &&
            snapshot.value["onlineStatus"] == "online") {
          print("HomeTab- getCurrentDriverInfo Set isOnlineStatus =  True");
          isOffline = false;
        }
        if (snapshot.value["earnings"] != null) {
          print("earnings ${snapshot.value["earnings"].toString()}");
          earnings = double.tryParse(snapshot.value["earnings"].toString())!;
        }

        if (snapshot.value["inMiddleOfTrip"] != null) {
          print("inMiddleOfTrip ${snapshot.value["inMiddleOfTrip"].toString()}");
          inMiddleOfTrip =  snapshot.value["inMiddleOfTrip"].toString().toLowerCase() =='true';
        }
        if (snapshot.value["rideId"] != null) {
          print("existingRideId  ${snapshot.value["rideId"].toString()}");
          existingRideId = snapshot.value["rideId"];
        }
        if (inMiddleOfTrip) {
          //restartRide();
        }
        //availabilityButtonPress();
      }
    });

    DataSnapshot vehicleRef = await FirebaseDatabase.instance
        .reference()
        .child(
        'drivers/${CustomParameters.currentFirebaseUser.uid}/vehicle_details')
        .once();

    CustomParameters.currentVehicleInfomation = VehicleInfomation.fromShapShot(vehicleRef);
    print("Vehicle type VtypeConverter :- ${CustomParameters.VtypeConverter(CustomParameters.currentVehicleInfomation.vehicleType)}");

    var latlng = LatLng(currentPositionx.latitude!, currentPositionx.longitude!);
    PushNotificationService pushNotificationService = PushNotificationService();
    pushNotificationService.initialize(context, latlng);
  }

  Future<bool> initializeAll() async {
    print("New trip Point 1");
    ///Create movingMarkerIcon
    movingMarkerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 48)),
        (Platform.isIOS)
            ? 'images/car_ios.png'
            : 'images/car_android.png');

    print("New trip Point 2");
    //Create startLocationUpdate
    await startLocationUpdate();
    await acceptTrip();
    return Future.value(true);

    return true;
  }


  @override
  Widget build(BuildContext context) {
    seticonimage(context);
    seticonimage2(context);
    seticonimage3(context);
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: FutureBuilder<bool>(
          future: _future, // a Future<String> or null
          builder: (BuildContext context,
              AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return loadingIndicators('Waiting for connection....');
              case ConnectionState.waiting:
                return loadingIndicators('Initializing....');
              default:
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return loadingIndicators('Error: ${snapshot.error}');
                }
                else {
                  return SafeArea(
                    child: Scaffold(
                      key: _scaffoldKey,
                      body: Stack(
                        children: <Widget>[
                          GoogleMap(
                            mapType: MapType.normal,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: true,
                            compassEnabled: true,
                            mapToolbarEnabled: true,
                            trafficEnabled: true,
                            circles: _circles,
                            markers: _markers,
                            polylines: _polyLines,

                            initialCameraPosition: CustomParameters.googlePlex,
                            onMapCreated: (GoogleMapController controller)  async {
                              _controller.complete(controller);
                              mapController = controller;
                              setLDMapStyle();

                              var currentLatLng =
                              LatLng(CustomParameters.currentPosition.latitude!, CustomParameters.currentPosition.longitude!);
                              var pickupLatLng = widget.tripDetails.pickup;
                              await getDirection(currentLatLng, pickupLatLng);
                              print("End Loading map");
                            },
                            // markers: Set<Marker>.of(getMarkerList(context).values),
                            // polylines: Set<Polyline>.of(
                            //     getPolyLine(context).values),
                          ),

                          Column(
                            children: <Widget>[
                              offLineMode(),
                              Expanded(
                                child: SizedBox(),
                              ),
                              myLocation(),
                              SizedBox(
                                height: 10,
                              ),
                              offLineModeDetail(),
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .padding
                                    .bottom,
                                color: Theme
                                    .of(context)
                                    .scaffoldBackgroundColor,
                              )
                            ],
                          )

                          // !isOffline
                          //     ? Column(
                          //   children: <Widget>[
                          //     offLineMode(),
                          //     Expanded(
                          //       child: SizedBox(),
                          //     ),
                          //     myLocation(),
                          //     SizedBox(
                          //       height: 10,
                          //     ),
                          //     offLineModeDetail(),
                          //     Container(
                          //       height: MediaQuery
                          //           .of(context)
                          //           .padding
                          //           .bottom,
                          //       color: Theme
                          //           .of(context)
                          //           .scaffoldBackgroundColor,
                          //     )
                          //   ],
                          // )
                          //     : Column(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: <Widget>[
                          //     Expanded(
                          //       child: SizedBox(),
                          //     ),
                          //     myLocation(),
                          //     SizedBox(
                          //       height: 10,
                          //     ),
                          //     offLineModeDetail(),
                          //     //onLineModeDetail(),
                          //   ],
                          // ),






                        ],
                      ),
                    ),
                  );
                }
            }
          },
        )
    );
  }


  Widget offLineMode() {
    return Animator<double>(
      duration: Duration(milliseconds: 400),
      cycles: 1,
      builder: (_, animatorState, __) => SizeTransition(
        sizeFactor: animatorState.animation,
        axis: Axis.horizontal,
        child: Container(
          height: AppBar().preferredSize.height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(right: 14, left: 14),
            child: Row(
              children: <Widget>[
                DottedBorder(
                  color: ConstanceData.secoundryFontColor,
                  borderType: BorderType.Circle,
                  strokeWidth: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child:
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: AssetImage(
                        ConstanceData.userImage,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(widget.tripDetails.riderName),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ConstanceData.secoundryFontColor,
                      ),
                    ),
                    Text(
                      AppLocalizations.of('${widget.tripDetails.riderPhone} - GOLD Customer'),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: ConstanceData.secoundryFontColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myLocation() {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor,
                  blurRadius: 12,
                  spreadRadius: -5,
                  offset: new Offset(0.0, 0),
                )
              ],
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Icon(
                Icons.my_location,
                color: Theme.of(context).textTheme.headline6!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///Bottom part of the Screen when offline
  Widget offLineModeDetail() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),


            Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          Icons.circle,
                          color: Color(0xfff57f17),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Icon(
                          Icons.circle,
                          color: Color(0xff0277bd),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${widget.tripDetails.pickupAddress}',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF00001f)),
                        ),
                        new SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          '${widget.tripDetails.destinationAddress}',
                          style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF00001f)),
                        ),
                      ],
                    ),
                  ],
                ),

              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 14 , top: 5 , right: 14 , bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          '$totalDistance',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: ConstanceData.secoundryFontColor,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              //earning
                              AppLocalizations.of('KM'),
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          '$totalSpeed',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: ConstanceData.secoundryFontColor,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('KM/H'),
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          '$durationCounter',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: ConstanceData.secoundryFontColor,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('MINUTES'),
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 8,
            ),
            Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).backgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 2 , top: 7 , right: 2 , bottom: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          launch("tel://${widget.tripDetails.riderPhone}");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular((25))),
                                border: Border.all(
                                    width: 2.0, color: Colors.redAccent),
                              ),
                              child: Icon(Icons.call,
                                  color: Colors.redAccent),
                            ),
                            Text(
                              "Call",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if(status == 'init'){
                            var driverLocation = LatLng(CustomParameters.currentPosition.latitude!,
                                CustomParameters.currentPosition.longitude!);
                            _launchMapsUrl(
                                driverLocation, widget.tripDetails.pickup);
                          }
                          if(status == 'arrived' || status == 'ontrip'){
                            _launchMapsUrl(widget.tripDetails.pickup,
                                widget.tripDetails.destination);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular((25))),
                                border: Border.all(
                                    width: 2.0, color: Theme.of(context).primaryColor),
                              ),
                              child: Icon(Icons.navigation_outlined,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Text(
                              "Navigation",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          launch("tel://${widget.tripDetails.riderPhone}");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular((25))),
                                border: Border.all(
                                    width: 2.0, color: Theme.of(context).primaryColor),
                              ),
                              child: Icon(Icons.play_arrow,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Text(
                              "Voice Trip",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          launch("tel://${widget.tripDetails.riderPhone}");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular((25))),
                                border: Border.all(
                                    width: 2.0, color: Theme.of(context).primaryColor),
                              ),
                              child: Icon(Icons.report_gmailerrorred_outlined,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Text(
                              "Report",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () async {
                doRide();
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).textTheme.headline6!.color,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(buttonTitle),
                    style: Theme.of(context).textTheme.button!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),


          ],
        ),
      ),
    );
  }


  void setLDMapStyle() async {
    // ignore: unnecessary_null_comparison
    if (mapController != null) {
      if (AppTheme.isLightTheme) {
        mapController.setMapStyle(await DefaultAssetBundle.of(context).loadString("jsonFile/lightmapstyle.json"));
      } else {
        mapController.setMapStyle(await DefaultAssetBundle.of(context).loadString("jsonFile/darkmapstyle.json"));
      }
    }
  }








  @override
  void deactivate() {
    //mapController.dispose();
    super.deactivate();
  }

  /*
    Dispose is called when the State object is removed, which is permanent.
    This method is where you should unsubscribe and cancel all animations, streams, etc.
    */
  @override
  void dispose() {
    CustomParameters.homeTabPositionStream!.cancel();
    super.dispose();
  }

  /// OLD SRC Methods ************************************************************************************************************************************************************************************
  /// ************************************************************************************************************************************************************************************
  /// ************************************************************************************************************************************************************************************

  ///Show alerts /*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*/
  showAlert(context, message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Go2Go Messaging",
      desc: message,
      style: AlertStyle(
          descStyle: TextStyle(fontSize: 15),
          titleStyle: TextStyle(color: Color(0xFFEB1465))
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color(0xFF222222),
        )
      ],
    ).show();
  }

  ///Widget for loading indications/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*/
  Widget loadingIndicators(String message) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              new BoxShadow(
                color: AppTheme.isLightTheme ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
                blurRadius: 12,
              ),
            ],
          ),

          child: Column(
            // Vertically center the widget inside the column
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cloud_download_outlined,
                color: Theme.of(context).primaryColor,
                size: 100,
              ),
              Text(AppLocalizations.of(message),
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme
                      .of(context)
                      .primaryColor,
                ),
              )

            ],
          ),
        ));
  }

  Future seticonimage3(BuildContext context) async {
    // ignore: unnecessary_null_comparison
    // if (bitmapDescriptorStartLocation3 == null) {
    final ImageConfiguration imagesStartConfiguration3 = createLocalImageConfiguration(context);
    bitmapDescriptorStartLocation3 = await BitmapDescriptor.fromAssetImage(
      imagesStartConfiguration3,
      ConstanceData.mylocation3,
    );
    setState(() {});
    // }
  }

  Future seticonimage2(BuildContext context) async {
    // ignore: unnecessary_null_comparison
    // if (bitmapDescriptorStartLocation2 == null) {
    final ImageConfiguration imagesStartConfiguration2 = createLocalImageConfiguration(context);
    bitmapDescriptorStartLocation2 = await BitmapDescriptor.fromAssetImage(
      imagesStartConfiguration2,
      ConstanceData.mylocation2,
    );
    setState(() {});
    // }
  }

  Future seticonimage(BuildContext context) async {
    // ignore: unnecessary_null_comparison
    // if (bitmapDescriptorStartLocation == null) {
    final ImageConfiguration imagesStartConfiguration = createLocalImageConfiguration(context);
    bitmapDescriptorStartLocation = await BitmapDescriptor.fromAssetImage(
      imagesStartConfiguration,
      ConstanceData.mylocation1,
    );
    setState(() {});
    // }
  }

  Future<void> startLocationUpdate() async{
    // FirebaseService.logtoGPSData('=================================================================================================');
    // FirebaseService.logtoGPSData('=================================== GPS based Distance tracking is on ===========================');
    // FirebaseService.logtoGPSData('=================================================================================================');
    print("New trip Point 3");
    oldPosition2 = Location(longitude: CustomParameters.currentPosition.longitude, latitude: CustomParameters.currentPosition.latitude);
    isWaited = false;
    waitButtonText = "WAIT";

    print("New trip Point 4");
    var permission = await Permission.locationAlways.isGranted;
    if(!permission){
      var permisisonState = await Permission.locationAlways.request();
      if(permisisonState.isDenied || permisisonState.isPermanentlyDenied){
        //showToast(context,"Permission has not granted to use location.");
        print("New trip Point 5");
        Navigator.pop(context);
        //return;
      }
    }else{
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
      try {
        CustomParameters.currentPosition = location;
        LatLng pos = LatLng(location.latitude!, location.longitude!);
        var rotation = MapKitHelperService.getMarkerRotation(oldPosition2.latitude,
            oldPosition2.longitude, pos.latitude, pos.longitude);
        setState(() {
          this.accuracy = location.accuracy!.toStringAsFixed(0);
          infoPanel = "On Trip";
          totalSpeed = location.speed!;
          var oldPos = oldPosition2 != null ? oldPosition2 : location;
          totalDistance = totalDistance + calculateDistance(oldPos.latitude,oldPos.longitude, location.latitude,location.longitude );
          print("distance  $totalDistance");
        });
        oldPosition2 = location;
      }
      catch(e){
        print('Error in updates ${e}');
      }
    });
    print("New trip Point 9");
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  double CalDistance(Location pos1, Location pos2, DistanceType type){
    print("pos1 : ${pos1.latitude} pos2: ${pos2.latitude}");
    double R = (type == DistanceType.Miles) ? 3960 : 6371;
    double dLat = this.toRadian(pos2.latitude! - pos1.latitude!);
    double dLon = this.toRadian(pos2.longitude! - pos1.longitude!);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(this.toRadian(pos1.latitude!)) * cos(this.toRadian(pos2.latitude!)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * asin(min(1, sqrt(a)));
    double d = R * c;
    return d;
  }

  double toRadian(double val) {
    return (pi / 180) * val;
  }

  void resetTelemetryValues(){
    setState(() {
      totalSpeed = 0.00;
      totalDistance = 0.00;
      totalTime = 0;
      durationCounter = 0;
    });

  }

  void updateTripDetails(Location location) async {
    print('Inside : updateTripDetails');

    //this if statement will track another trip reqest is on the line if so will skip this entire process
    if (!isRequestingDirection) {
      LatLng destinationLatLng;
      isRequestingDirection = true;

      // if (location == null) {
      //   return;
      // }

      var positionLatLng = LatLng(location.latitude!, location.longitude!);

      if (status == 'accepted') {
        /*
        * This means we arrived the pickup location
        * */
        destinationLatLng = widget.tripDetails.pickup;
      } else {
        destinationLatLng = widget.tripDetails.destination;
      }

      //This is awaitable for to await till directiond details came back from firestore
      var directionDetails = await CommonService.getDirectionDetails(
          positionLatLng, destinationLatLng);

      if (directionDetails != null) {
        print(directionDetails.durationText);

        setState(() {
          //This will update the duration to go in the screen with direction details realtime
          durationString = directionDetails.durationText;
          DistanceString = directionDetails.distanceText;
        });
      } else {
        print('Direction Details are empty');
      }
      isRequestingDirection = false;
    }
  }


  Future<void> acceptTrip() async {
    print("New trip Point acceptTrip 1");
    print("Inside acceptTrip status = $status" );
    CustomParameters.paymentDetails = PaymentDetails(pickupAddress: "",
        destinationAddress: "",
        rideID: "",
        kmPrice: 0.00,
        appPrice: 0.00,
        timePrice: 0.00, totalFare: totalFare, companyPayable: 0.00, commissionApplicable: false, commission: 0.00);
    if (widget.tripDetails != null) {
      if (CustomParameters.currentDriverInfo != null) {
        if(widget.tripDetails.rideID != null) {
          print("RideId is ok and trip details not null");

          String rideID = widget.tripDetails.rideID;
          CustomParameters.rideRef =
              FirebaseDatabase.instance.reference().child(
                  'rideRequest/$rideID');

          ///Setting variables that not setted when ride request created
          CustomParameters.rideRef.child('driver_phone').set(CustomParameters.currentDriverInfo.phone);
          ///Drivers location may change now so we update drivers current to riderequest obejct
          Map locationMap = {
            'latitude': CustomParameters.currentPosition.latitude.toString(),
            'longitude': CustomParameters.currentPosition.longitude.toString(),
          };
          CustomParameters.rideRef.child('driver_location').set(locationMap);

          if (widget.restartRide) {
            print("Inside Restart Ride  ${widget.tripDetails.status}");
            status = widget.tripDetails.status;
            if (status == 'accepted') {
              CustomParameters.rideRef.child('status').set(('accepted'));
              setState(() {
                buttonTitle = 'ARRIVED';
                buttonColor = Colors.purpleAccent;
              });
              print(
                  "LatLng pos.longitude ${CustomParameters.currentPosition.longitude}");
              print(
                  "LatLng pos.latitude ${CustomParameters.currentPosition.latitude}");
              var driverLocation = LatLng(CustomParameters.currentPosition.latitude!,
                  CustomParameters.currentPosition.longitude!);
              _launchMapsUrl(
                  driverLocation, widget.tripDetails.pickup);
            }
            else if (status == 'arrived') {
              print("status == 'arrived' condition");

              _launchMapsUrl(widget.tripDetails.pickup,
                  widget.tripDetails.destination);

              status = 'arrived';
              TimeSpent = "0.00";

              setState(() {
                cumDistance = 0.0;
                //distancex = "0.00";
                cumDistanceGro = 0.0;

                buttonTitle = 'ARRIVED';
                buttonColor = Colors.red;
              });

              if(widget.tripDetails.bookingID != "NA"){
                DatabaseReference instanceBase = FirebaseDatabase.instance.reference()
                    .child('rideBookings/${widget.tripDetails.bookingID}/');
                instanceBase.child("status").set("Arrived");
              }
              //To count how many minutes spend on a trip
              startTimer();
            }
            else if (status == 'ontrip') {
              print("status == 'ontrip' condition");
              _launchMapsUrl(widget.tripDetails.pickup,
                  widget.tripDetails.destination);

              status = 'ontrip';
              TimeSpent = "0.00";

              setState(() {
                cumDistance = 0.0;
                //distancex = "0.00";
                cumDistanceGro = 0.0;
                buttonTitle = 'END TRIP';
                buttonColor = Colors.red;
              });

              if(widget.tripDetails.bookingID != "NA"){
                DatabaseReference instanceBase = FirebaseDatabase.instance.reference()
                    .child('rideBookings/${widget.tripDetails.bookingID}/');
                instanceBase.child("status").set("OnTrip");
              }
              //To count how many minutes spend on a trip
              startTimer();
            }
          }
          print("New trip Point acceptTrip End");
        }else{
          print("ERR_DR_005");
          print("acceptTrip-> widget.tripDetails.rideID is null");
        }
      } else {
        print("ERR_DR_002");
        print("acceptTrip-> currentDriverInfo is null");
      }
    } else {
      print("ERR_DR_001");
      print("acceptTrip-> widget.tripDetails is null");
    }


  }

  void startTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      setState(() {
        durationCounter++;
        //TimeSpent = ReturnTimeString(durationCounter);
      });
    });
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

  void stopLocationUpdates(){
    print('=================================== END Of GPS based Distance tracking===========================');

    isWaited = false;
    waitButtonText = "WAIT";
    BackgroundLocation.stopLocationService();
    setState(() {
      infoPanel = "Meter Ready..";
      this.accuracy = "Waiting....";
      totalSpeed = 0;
      totalFare = 0.00;
      totalWaiting = 0;

    });
  }

  void endTrip() async {
    if (timer != null) {
      timer.cancel();
    }
    stopLocationUpdates();

    if (widget.tripDetails != null) {
      CommonService.showProgressDialog(context);

      myPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      var directionDetails = await CommonService.getDirectionDetails(
          widget.tripDetails.pickup, currentLatLng);
      Navigator.pop(context);

      var timeInMinutes = durationCounter/60;

      DirectionDetails directionDetailsGPS = new DirectionDetails(
          distanceValue: totalDistance!= null? totalDistance.toInt(): 0,
          distanceText: totalDistance!=null? totalDistance.toInt().toString() :"0",
          durationValue:timeInMinutes!=null? timeInMinutes.toInt(): 0,
          durationText: timeInMinutes!=null? timeInMinutes.toInt().toString(): "0",encodedPoints: ""
      );

      totalDistance = 0.00;
      totalTime = 0;


      int fares = CommonService.estimateFares(
          directionDetailsGPS, CommonService.VtypeConverter(CustomParameters.currentVehicleInfomation.vehicleType), widget.tripDetails);

      CustomParameters.rideRef.child('fares').set(fares.toString());
      CustomParameters.rideRef.child('status').set('ended');

      /// after ending ride the drivers newtrip status must set to waiting
      CustomParameters.rideRef = FirebaseDatabase.instance
          .reference()
          .child('drivers/${CustomParameters.currentDriverInfo.id}/profile');
      CustomParameters.rideRef.child("newtrip").set("waiting");

      CustomParameters.rideRef = FirebaseDatabase.instance
          .reference()
          .child('drivers/${CustomParameters.currentDriverInfo.id}/profile');
      CustomParameters.rideRef.child("rideId").set("");

      CustomParameters.rideRef = FirebaseDatabase.instance
          .reference()
          .child('drivers/${CustomParameters.currentDriverInfo.id}/profile');
      CustomParameters.rideRef.child("inMiddleOfTrip").set("false");

      ///This will cumilatly increment the earnings of the driver
      topUpEarnings(fares);

      ///Saving the Trip history
      driverTripHistory(widget.tripDetails, fares, directionDetails! ,directionDetailsGPS);

      ///Saving the Payment Details
      driverPaymentHistory(widget.tripDetails, directionDetails, directionDetailsGPS);

      if(widget.tripDetails.bookingID != "NA"){
        doBookingRelatedCleanups(widget.tripDetails.bookingID);
      }

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => CollectPayment(
            paymentMethod: widget.tripDetails.paymentMethod,
            fares: fares,
          ));


    } else {
      print('widget.tripDetails is null');
    }
  }

  void doBookingRelatedCleanups(String bookingID){
    print("snapshot came ===>>> $bookingID");
    DatabaseReference earningsRef = FirebaseDatabase.instance
        .reference()
        .child('rideBookings/$bookingID');
    ///Backup the booking
    earningsRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        print("snapshot came2 ===>>> ${snapshot.value}");
        DatabaseReference earningsRef2 = FirebaseDatabase.instance
            .reference()
            .child('Backups/rideBookings/$bookingID');
        earningsRef2.set(snapshot.value);

        DateTime now = DateTime.now();
        DatabaseReference instanceBase = FirebaseDatabase.instance.reference()
            .child('rideBookings/$bookingID/');
        instanceBase.child("status").set("Completed");
        instanceBase.child("completedTime").set(now.toLocal().toString());
      }
    });

    ///Remove the booking entity
    FirebaseDatabase.instance.reference().child('rideBookings/$bookingID/').remove();
  }


  void updateCashFlows(TripDetails tripDetailsx) {
    DatabaseReference earningsRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/cashflows/cr');
    earningsRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        ///Top up credit value is one avaiblable
        double oldEarnings = double.parse(snapshot.value.toString());
        double adjustedEarnings =
            (CustomParameters.paymentDetails.companyPayable.toDouble()) + oldEarnings;
        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      } else {
        ///Create new value if not available
        double adjustedEarnings = (CustomParameters.paymentDetails.companyPayable.toDouble());
        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      }
    });
  }

  void driverTripHistory(TripDetails tripDetails, int fare, DirectionDetails directionDetails,DirectionDetails directionDetailsGPS) {
    if (tripDetails != null) {
      print("inside driverTripHistory $CustomParameters.currentFirebaseUser.uid");
      DatabaseReference earningsRef = FirebaseDatabase.instance.reference().child(
          'drivers/${CustomParameters.currentFirebaseUser.uid}/tripHistory/${tripDetails.rideID}');

      Map pickupMap = {
        'latitude': tripDetails.pickup!= null? tripDetails.pickup.latitude.toString():CustomParameters.defaultLocationLat,
        'longitude': tripDetails.pickup!= null? tripDetails.pickup.longitude.toString():CustomParameters.defaultLocationLng,
      };

      Map destinationMap = {
        'latitude': tripDetails.destination!= null ? tripDetails.destination.latitude.toString():CustomParameters.defaultLocationLat ,
        'longitude': tripDetails.destination!= null ? tripDetails.destination.longitude.toString():CustomParameters.defaultLocationLng,
      };

      Map directionMap = {
        'distanceText': directionDetailsGPS!= null? directionDetailsGPS.distanceText.toString():"0",
        'distanceValue': directionDetailsGPS!= null? directionDetailsGPS.distanceValue.toString():"0",
        'durationValue': directionDetailsGPS!= null?directionDetailsGPS.durationValue.toString():"0",
        'durationText': directionDetailsGPS!= null? directionDetailsGPS.durationText.toString():"0",
      };

      Map directionMapGoogle = {
        'distanceText':directionDetails!= null?  directionDetails.distanceText.toString():"0",
        'distanceValue': directionDetails!= null? directionDetails.distanceValue.toString():"0",
        'durationValue':directionDetails!= null? directionDetails.durationValue.toString():"0",
        'durationText':directionDetails!= null? directionDetails.durationText.toString():"0",
      };

      Map historyMap = {
        "rideID": tripDetails !=null? tripDetails.rideID :"",
        "pickup": pickupMap,
        "destination": destinationMap,
        "directionDetails": directionMap,
        "directionDetailsGoogle": directionMapGoogle,
        "pickupAddress": tripDetails !=null? tripDetails.pickupAddress :"",
        "destinationAddress":  tripDetails !=null?tripDetails.destinationAddress :"",
        "fare": fare,
        "date": DateTime.now().toString()
      };
      earningsRef.set(historyMap);
    } else {
      print("ERR_DR_004");
    }
  }

  void driverPaymentHistory(TripDetails tripDetailsx, DirectionDetails directionDetails,DirectionDetails directionDetailsGPS) async {
    print("inside driverTripHistory $CustomParameters.currentFirebaseUser.uid");
    DatabaseReference earningsRef = FirebaseDatabase.instance.reference().child(
        'drivers/${CustomParameters.currentFirebaseUser
            .uid}/paymentHistory/${tripDetailsx.rideID}');


    if (tripDetailsx.commissionedDriverId != "") {
      if (tripDetailsx.commissionedDriverId.trim() != "system") {
        Map commissionMap = {
          'comValue': CustomParameters.paymentDetails.commission,
          'rideId': tripDetailsx.rideID,
          'handled': false,
        };
        var refCommission = FirebaseDatabase.instance.reference().child(
            "drivers/${tripDetailsx.commissionedDriverId}/commission").push();
        refCommission.set(commissionMap);
      }
    }

    Map directionMap = {
      'distanceText': directionDetailsGPS.distanceText.toString(),
      'distanceValue': directionDetailsGPS.distanceValue.toString(),
      'durationValue': directionDetailsGPS.durationValue.toString(),
      'durationText': directionDetailsGPS.durationText.toString(),
    };

    Map directionMapGoogle = {
      'distanceText': directionDetails.distanceText.toString(),
      'distanceValue': directionDetails.distanceValue.toString(),
      'durationValue': directionDetails.durationValue.toString(),
      'durationText': directionDetails.durationText.toString(),
    };

    Map paymentHistoryMap = {
      "rideID": CustomParameters.paymentDetails.rideID,
      "commission": CustomParameters.paymentDetails.commission,
      "commissionApplicable": CustomParameters.paymentDetails
          .commissionApplicable,
      "companyPayable": CustomParameters.paymentDetails.companyPayable,
      "totalFare": CustomParameters.paymentDetails.totalFare,
      "appPrice": CustomParameters.paymentDetails.appPrice,
      "kmPrice": CustomParameters.paymentDetails.kmPrice,
      "timePrice": CustomParameters.paymentDetails.timePrice,
      "destinationAddress": CustomParameters.paymentDetails.destinationAddress,
      "pickupAddress": CustomParameters.paymentDetails.pickupAddress,
      "date": DateTime.now().toString(),
      "pickupAddress": tripDetailsx != null ? tripDetailsx.pickupAddress : "",
      "destinationAddress": tripDetailsx != null ? tripDetailsx
          .destinationAddress : "",
      "directionDetails": directionMap,
      "directionDetailsGoogle": directionMapGoogle
    };
    earningsRef.set(paymentHistoryMap);

    var summary = DateWiseSummary(
        CustomParameters.paymentDetails.commission,
        CustomParameters.paymentDetails.kmPrice +
            CustomParameters.paymentDetails.timePrice,
        directionDetails.distanceValue / 1000,
        0,
        CustomParameters.paymentDetails.kmPrice,
        CustomParameters.paymentDetails.totalFare,
        CustomParameters.paymentDetails.timePrice
    );
    await FinanceService.updatedateWiseSummary(summary);

    var cf = CashFlows(CustomParameters.paymentDetails.companyPayable, 0);
    await FinanceService.updateCashFlows(cf);

    // await SalesService.updateEarningOnly(paymentDetails.kmPrice + paymentDetails.timePrice);
    // if(paymentDetails.commissionApplicable){
    //   await SalesService.updateCommissionOnly(paymentDetails.commission);
    // }
    // await SalesService.updateKMs(directionDetails.distanceValue/1000);
    // await SalesService.updateKMs(directionDetails.durationValue/60);


    ///Driver's own Accounting REF
    DatabaseReference journalsRef = FirebaseDatabase.instance.reference().child(
        'Accounting/${CustomParameters.currentFirebaseUser
            .uid}/driverWisejournals/').push();

    ///Driver's own Accounting
    Map driverWisejournalsCP = {
      'Key': journalsRef.key,
      'TripID': tripDetailsx.rideID,
      'Code': 'CP',
      'Value': CustomParameters.paymentDetails.companyPayable,
    };
    journalsRef.set(driverWisejournalsCP);

    DatabaseReference journalsRefDE = FirebaseDatabase.instance.reference()
        .child(
        'Accounting/${CustomParameters.currentFirebaseUser
            .uid}/driverWisejournals/')
        .push();

    Map driverWisejournalsDE = {
      'Key': journalsRef.key,
      'TripID': tripDetailsx.rideID,
      'DE': 'DE',
      'Value': CustomParameters.paymentDetails.kmPrice +
          CustomParameters.paymentDetails.timePrice,
    };
    journalsRefDE.set(driverWisejournalsDE);


    ///Driver's commission apply
    if (tripDetailsx.commissionedDriverId != "") {
      if (tripDetailsx.commissionedDriverId.trim() != "system") {
        DatabaseReference journalsRefCommission = FirebaseDatabase.instance
            .reference().child(
            'Accounting/${tripDetailsx.commissionedDriverId }/driverWisejournals/').push();
        Map driverWisejournalsCM = {
          'Key': journalsRefCommission.key,
          'TripID': tripDetailsx.rideID,
          'CM': 'CM',
          'Value': CustomParameters.paymentDetails.commission,
        };
        journalsRefCommission.set(driverWisejournalsCM);
      }
    }
  }

  void topUpEarnings(int fares) {
    DatabaseReference earningsRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile/earnings');
    earningsRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        double oldEarnings = double.parse(snapshot.value.toString());

        double adjustedEarnings = (fares.toDouble() * 0.85) + oldEarnings;

        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      } else {
        double adjustedEarnings = (fares.toDouble() * 0.85);
        earningsRef.set(adjustedEarnings.toStringAsFixed(2));
      }
    });
  }

///Migrated method ******************************************************************************************************************************************************
///**********************************************************************************************************************************************************************
///**********************************************************************************************************************************************************************

  Future<void> getDirection(LatLng pickupLatLng, LatLng destinationLatLng) async {
    BuildContext dialogContext = context;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          dialogContext = context;
          return ProgressDialog(
            status: 'Please wait...2', circularProgressIndicatorColor: Colors.redAccent,
          );
        });

    var thisDetails = await CommonService.getDirectionDetails(
        pickupLatLng, destinationLatLng);

    if(widget.incomeType ==1){
      print('Calling Navigator.pop cus incomeType ==1');
      //Navigator.pop(context);
    }
    Navigator.pop(dialogContext);
    print('getDirection - Create Polyline');
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
    polylinePoints.decodePolyline(thisDetails!.encodedPoints);

    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      // loop through all PointLatLng points and convert them
      // to a list of LatLng, required by the Polyline
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    _polyLines.clear();
    print('getDirection - Set state');
    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId('polyid'),
        color: Color.fromARGB(255, 95, 109, 237),
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polyLines.add(polyline);
    });

    // make polyline to fit into the map
    LatLngBounds bounds;

    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
          northeast:
          LatLng(destinationLatLng.latitude, pickupLatLng.longitude));
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
        northeast: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      bounds =
          LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }

    print('getDirection - creating markers');

    Marker pickupMarker = Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(pickupMarker);
      _markers.add(destinationMarker);
    });
    print('getDirection - creating Circles');
    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: Theme.of(context).primaryColor,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: Theme.of(context).primaryColor,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: Theme.of(context).primaryColor,
    );

    setState(() {
      _circles.add(pickupCircle);
      _circles.add(destinationCircle);
    });
    print('getDirection - End');
  }

  doRide() async {
    await CustomParameters.homeTabPositionStream!.cancel();

    CustomParameters.rideRef = FirebaseDatabase.instance
        .reference()
        .child("rideRequest/${widget.tripDetails.rideID}");
    print(
        "onPress status $status");

    if (status == 'init') {
      status = 'accepted';
      CustomParameters.rideRef.child('status').set(('accepted'));

      setState(() {
        buttonTitle = 'ARRIVED';
        buttonColor = Color(0xFFf4511e);
      });
      print(
          "LatLng pos.longitude ${CustomParameters.currentPosition.longitude}");
      print(
          "LatLng pos.latitude ${CustomParameters.currentPosition.latitude}");

    }

    else if (status == 'accepted') {
      status = 'arrived';
      CustomParameters.rideRef.child('status').set(('arrived'));

      setState(() {
        buttonTitle = 'START TRIP';
        buttonColor = Color(0xFF263238);
      });

      BuildContext dialogContext = context;
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            dialogContext = context;
            return ProgressDialog(
              status: 'Please wait...2', circularProgressIndicatorColor: Colors.redAccent,
            );
          });

      await getDirection(widget.tripDetails.pickup,
          widget.tripDetails.destination);
      print('Calling Navigator.pop on Point 1');

      if(widget.tripDetails.bookingID != "NA"){
        DatabaseReference instanceBase = FirebaseDatabase.instance.reference()
            .child('rideBookings/${widget.tripDetails.bookingID}/');
        instanceBase.child("status").set("Arrived");
      }
      Navigator.pop(dialogContext);

    }

    else if (status == 'arrived') {
      resetTelemetryValues();
      // _launchMapsUrl(widget.tripDetails.pickup,
      //     widget.tripDetails.destination);

      status = 'ontrip';
      //Update the firebase status
      CustomParameters.rideRef.child('status').set('ontrip');
      TimeSpent = "0.00";

      setState(() {
        cumDistance = 0.0;
        //distancex = "0.00";
        cumDistanceGro = 0.0;
        buttonTitle = 'END TRIP';
        buttonColor = Color(0xFF263238);
      });

      if(widget.tripDetails.bookingID != "NA"){
        DatabaseReference instanceBase = FirebaseDatabase.instance.reference()
            .child('rideBookings/${widget.tripDetails.bookingID}/');
        instanceBase.child("status").set("OnTrip");
      }
      //To count how many minutes spend on a trip
      startTimer();
    }
    else if (status == 'ontrip') {
      endTrip();
    }

  }



}
