import 'dart:async';

import 'package:animator/animator.dart';
import 'package:background_location/background_location.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_cab_driver/Services/commonService.dart';
import 'package:my_cab_driver/Services/financeServices.dart';
import 'package:my_cab_driver/Services/serialService.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/home/riderList.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/Driver.dart';
import 'package:my_cab_driver/models/PushNotificationService.dart';
import 'package:my_cab_driver/models/VehicleInfomation.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../appTheme.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<bool> _future;
  bool isOffline = false;

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

  @override
  void initState() {
    _future = initializeAll();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published! $message');
    });
    super.initState();
  }


  void availabilityButtonPress() async {
    print("HomeTab- availabilityButtonPress Start of the method");
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      showAlert(
          context,'No internet connectivity(අන්තර්ජාල සම්බන්ධතාවය විසන්ධි වී ඇත. කරුණාකර නැවත සම්බන්ද කරන්න.)',
          );
      return;
    }

    print("HomeTab- availabilityButtonPress isOnlineStatus =   $isOffline");
    // if (!isOffline) {
    //   goOnline();
    //   //getLocationUpdates();
    //   setState(() {
    //     // CustomParameters.availabilityColor = Colors.greenAccent;
    //     // CustomParameters.availabilityTitle = 'GO OFFLINE';
    //     // isAvailable = true;
    //   });
    // }
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
        availabilityButtonPress();
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
    CustomParameters.rideRef = FirebaseDatabase.instance.reference();
    CustomParameters.posError = LatLng(6.877133555388284, 79.98983549839619);
    ///Serial Service and get Serials
    await SerialService.initSerials();
    ///Get Vehicle types
    CustomParameters.globalVTypes =    (await CommonService().getVehicleTypeInfo())!;
    ///Get positions
    await CommonService.determinePosition();
    CustomParameters.currentPosition =   Location(longitude: 6.877317676732788, latitude: 79.9899282496178,isMock: true,accuracy: 10,altitude: 10,bearing: 160,speed: 0, time: 10);
    ///Need To Implement
    //await getCurrentDriverInfo(CustomParameters.currentPosition);
    CommonService.handleOnlineStatus(CustomParameters.currentFirebaseUser.uid);
    ///Loading system settings
    CustomParameters.systemSettings = (await CommonService().fetchSystemConfigurations())!;
    ///loading current driver information from profile
    await getCurrentDriverInfo(CustomParameters.currentPosition);
    ///Loading daily finance
    CustomParameters.dailyParameters = (await FinanceService.getDailyFinance())!;
    print("CustomParameters.dailyParameters ${CustomParameters.dailyParameters.commission}");

    try {
      //Position position = await HelperMethods.determinePositionRaw();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      CustomParameters.currentPosition = Location(longitude: position.longitude,latitude: position.latitude);
      print("CustomParameters.currentPosition ${ CustomParameters.currentPosition}");
    } catch (e) {
      print('Error: ${e.toString()}');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    seticonimage(context);
    seticonimage2(context);
    seticonimage3(context);
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(title: Text(
                  'You cannot go back from this screen. please close the app if you want to exit(ඔබට මෙම මෙනුවෙන් ඉවතට යා නොහැක. එසේ කිරීමට Go2Go යෙදුම මෙනුවෙන් වසා දමන්න )',
                  style: GoogleFonts.roboto(
                      fontSize: 15, color: Color(0xFFd32f2f)),),
                    actions: <Widget>[
                      ElevatedButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(false)),
                    ]));

        return false;
      },
      child: Container(
        color:Theme.of(context).scaffoldBackgroundColor,
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
                  return loadingIndicators('Error: ${snapshot.error}');
                }
                else {
                  return Scaffold(
                    key: _scaffoldKey,
                    drawer: SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.75 < 400 ? MediaQuery
                          .of(context)
                          .size
                          .width * 0.75 : 350,
                      child: Drawer(
                        child: AppDrawer(
                          selectItemName: 'Home',
                        ),
                      ),
                    ),
                    appBar: AppBar(
                      backgroundColor: isOffline? Theme.of(context).primaryColor : Theme.of(context).scaffoldBackgroundColor ,
                      automaticallyImplyLeading: false,
                      title: Row(
                        children: <Widget>[
                          SizedBox(
                            height: AppBar().preferredSize.height,
                            width: AppBar().preferredSize.height + 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState!.openDrawer();
                                  },
                                  child: Icon(
                                    Icons.dehaze,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline6!
                                        .color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: !isOffline
                                ? Text(
                              AppLocalizations.of('OFFLINE'),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .headline6!
                                    .color,
                              ),
                              textAlign: TextAlign.center,
                            )
                                : Text(
                              AppLocalizations.of('ONLINE'),
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme
                                    .of(context).canvasColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: AppBar().preferredSize.height,
                            width: AppBar().preferredSize.height + 40,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Switch(
                                activeColor: Theme.of(context).disabledColor,
                                value: isOffline,
                                onChanged: (bool value) {
                                  setState(() {
                                    isOffline = !isOffline;
                                    offLineOnline(isOffline);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: Stack(
                      children: <Widget>[
                        GoogleMap(
                          mapType: MapType.normal,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: true,

                          initialCameraPosition: CustomParameters.googlePlex,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                            mapController = controller;
                            setLDMapStyle();
                          },
                          // markers: Set<Marker>.of(getMarkerList(context).values),
                          // polylines: Set<Polyline>.of(
                          //     getPolyLine(context).values),
                        ),
                        !isOffline
                            ? Column(
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
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(),
                            ),
                            myLocation(),
                            SizedBox(
                              height: 10,
                            ),
                            offLineModeDetail(),
                            //onLineModeDetail(),
                          ],
                        ),
                      ],
                    ),
                  );
                }
            }
          },
        )
      ),
    );
  }

  ///Handle online offline status factors /*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*
  void offLineOnline(status) {
    if(status){
      getLocationUpdates();
      CustomParameters.isOnline = true;
      goOnline();
    }else{
      goOffline();
    }
  }

  ///This responsible to go online for the driver. with help of geofire /*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*
  void goOnline() async {
    isOffline = true;
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      showAlert(context,"No internet Connection No internet connectivity(අන්තර්ජාල සම්බන්ධතාවය විසන්ධි වී ඇත. කරුණාකර නැවත සම්බන්ද කරන්න.");
      return;
    }
    print('Inside GoOnline currentPosition.latitude = ${CustomParameters.currentPosition != null ? CustomParameters.currentPosition.latitude : "currentPosition Is empty"} ');
    CustomParameters.isOnline = true;
    cancelLocationUpdate = false;
    Geofire.initialize('driversAvailable');
    print("Geofire Started");
    Geofire.setLocation(
        CustomParameters.currentFirebaseUser.uid,
        CustomParameters.currentPosition != null ? CustomParameters.currentPosition.latitude! : CustomParameters.posError.latitude,
        CustomParameters.currentPosition != null ? CustomParameters.currentPosition.longitude! : CustomParameters.posError.longitude);
    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile/newtrip');
    tripRequestRef.set('waiting');

    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile/onlineStatus');
    tripRequestRef.set('online');

    tripRequestRef.onValue.listen((event) {
      print('tripRequestRef.onValue.listen-> $event');
    });
  }

  ///This responsible to go offline for the driver. with help of geofire /*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*
  void goOffline() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      showAlert(context,"No internet Connection No internet connectivity(අන්තර්ජාල සම්බන්ධතාවය විසන්ධි වී ඇත. කරුණාකර නැවත සම්බන්ද කරන්න.");
      return;
    }
    CustomParameters.isOnline = false;
    cancelLocationUpdate = true;

    Geofire.removeLocation(CustomParameters.currentFirebaseUser.uid);
    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile/newtrip');

    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile/onlineStatus');
    tripRequestRef.set('offline');
    setState(() {
      cancelLocationUpdate = true;
    });
    tripRequestRef.onDisconnect();
  }

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

  ///Bottom part of the Screen when offline
  Widget onLineModeDetail() {
    var bootmPadding = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(right: 10, left: 10, bottom: bootmPadding),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RiderList(),
              fullscreenDialog: true,
            ),
          );
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[

            Animator<Offset>(
              tween: Tween<Offset>(
                begin: Offset(0, 0.4),
                end: Offset(0, 0),
              ),
              duration: Duration(milliseconds: 700),
              cycles: 1,
              builder: (context, animate, _) => SlideTransition(
                position: animate.animation,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        new BoxShadow(
                          color: Theme.of(context).dividerColor,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    ConstanceData.userImage,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('Esther Berry'),
                                      style: Theme.of(context).textTheme.headline6!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6!.color,
                                          ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          height: 24,
                                          width: 74,
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of('ApplePay'),
                                              style: Theme.of(context).textTheme.button!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: ConstanceData.secoundryFontColor,
                                                  ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Container(
                                          height: 24,
                                          width: 74,
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of('Discount'),
                                              style: Theme.of(context).textTheme.button!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: ConstanceData.secoundryFontColor,
                                                  ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: SizedBox(),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      '\$25.00',
                                      style: Theme.of(context).textTheme.headline6!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6!.color,
                                          ),
                                    ),
                                    Text(
                                      '2.2 km',
                                      style: Theme.of(context).textTheme.caption!.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0.5,
                            color: Theme.of(context).disabledColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('PICKUP'),
                                      style: Theme.of(context).textTheme.caption!.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      AppLocalizations.of('79 Swift Village'),
                                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6!.color,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0.5,
                            color: Theme.of(context).disabledColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      AppLocalizations.of('DROP OFF'),
                                      style: Theme.of(context).textTheme.caption!.copyWith(
                                            color: Theme.of(context).disabledColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      AppLocalizations.of('115 William St, Chicago, US'),
                                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).textTheme.headline6!.color,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0.5,
                            color: Theme.of(context).disabledColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: 32,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('Ignore'),
                                      style: Theme.of(context).textTheme.button!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).disabledColor,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 32,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('ACCEPT'),
                                      style: Theme.of(context).textTheme.button!.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: ConstanceData.secoundryFontColor,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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

  ///Bottom part of the Screen when offline
  Widget offLineModeDetail() {
    return Container(
      height: 170,
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
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(
                    ConstanceData.userImage,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(CustomParameters.currentDriverInfo.fullName),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Theme.of(context).textTheme.headline6!.color,
                          ),
                    ),
                    Text(
                      AppLocalizations.of(CustomParameters.currentDriverInfo.driverLevel),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${CustomParameters.dailyParameters.commission>1 ? CustomParameters.dailyParameters.commission : 0.00 } LKR',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline6!.color,
                          ),
                    ),
                    Text(
                      AppLocalizations.of('Commission'),
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.moneyBill,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${CustomParameters.dailyParameters.earning>1 ? CustomParameters.dailyParameters.earning : 0.00 } LKR',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              //earning
                              AppLocalizations.of('EARNINGS'),
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.tachometerAlt,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${CustomParameters.dailyParameters.totalDistance>1 ? CustomParameters.dailyParameters.totalDistance : 0.00 } KM',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('TOTAL DISTANCE'),
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.rocket,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          size: 20,
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${CustomParameters.dailyParameters.totalTrips}',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              AppLocalizations.of('TOTAL TRIPS'),
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                    fontWeight: FontWeight.bold,
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
            )
          ],
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

  // Map<PolylineId, Polyline> getPolyLine(BuildContext context) {
  //   Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  //   if (isOffline) {
  //     List<LatLng> latlng1 = [
  //       LatLng(51.506115, -0.088339),
  //       LatLng(51.507129, -0.087974),
  //       LatLng(51.509693, -0.087075),
  //       LatLng(51.509065, -0.082206),
  //       LatLng(51.509159, -0.081173),
  //       LatLng(51.509346, -0.080675),
  //       LatLng(51.509540, -0.080293),
  //       LatLng(51.509587, -0.080282)
  //     ];
  //     List<LatLng> latlng2 = [LatLng(51.505951, -0.086974), LatLng(51.506051, -0.087634), LatLng(51.506115, -0.088339)];
  //     final PolylineId polylineId = PolylineId('polylineId');
  //     final Polyline polyline = Polyline(
  //       polylineId: polylineId,
  //       color: Theme.of(context).primaryColor,
  //       consumeTapEvents: false,
  //       points: latlng1,
  //       width: 4,
  //       startCap: Cap.roundCap,
  //       endCap: Cap.roundCap,
  //     );
  //
  //     final PolylineId polylineId1 = PolylineId('polylineId1');
  //     List<PatternItem> patterns1 = [PatternItem.dot, PatternItem.gap(1)];
  //     final Polyline polyline1 = Polyline(
  //       polylineId: polylineId1,
  //       color: Theme.of(context).primaryColor,
  //       consumeTapEvents: false,
  //       points: latlng2,
  //       width: 4,
  //       startCap: Cap.roundCap,
  //       endCap: Cap.roundCap,
  //       patterns: patterns1,
  //     );
  //     _polylines.addAll({polylineId: polyline});
  //     _polylines.addAll({polylineId1: polyline1});
  //   }
  //   return _polylines;
  // }
  //
  // Map<MarkerId, Marker> getMarkerList(BuildContext context) {
  //   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  //   final MarkerId markerId1 = MarkerId("markerId1");
  //   final MarkerId markerId2 = MarkerId("markerId2");
  //   final MarkerId markerId3 = MarkerId("markerId3");
  //   final Marker marker1 = Marker(
  //     markerId: markerId1,
  //     position: LatLng(lat, long),
  //     anchor: Offset(0.5, 0.5),
  //     icon: bitmapDescriptorStartLocation,
  //   );
  //   if (isOffline) {
  //     final Marker marker2 = Marker(
  //       markerId: markerId2,
  //       position: LatLng(lat2, long2),
  //       anchor: Offset(0.5, 0.5),
  //       icon: bitmapDescriptorStartLocation3,
  //     );
  //
  //     final Marker marker3 = Marker(
  //       markerId: markerId3,
  //       position: LatLng(lat3, long3),
  //       anchor: Offset(0.5, 0.5),
  //       icon: bitmapDescriptorStartLocation2,
  //     );
  //     markers.addAll({markerId2: marker2});
  //     markers.addAll({markerId3: marker3});
  //   }
  //   markers.addAll({markerId1: marker1});
  //   return markers;
  // }

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
                    child: Icon(
                      FontAwesomeIcons.cloudMoon,
                      color: ConstanceData.secoundryFontColor,
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
                      AppLocalizations.of('You are offline !'),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                    Text(
                      AppLocalizations.of('Go online to strat accepting jobs.'),
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

  /*
  * When our drivers go place to place this steam subs are updating the locations
  * Internally the Geolocator will check if Google Play Services are installed on the device.
  * If they are not installed the Geolocator plugin will automatically switch to the LocationManager
  * implementation. However if you want to force the Geolocator plugin to use the LocationManager
  * implementation even when the Google Play Services are installed you could set this property to true.
  * */

  void getLocationUpdates() {
    print("getLocationUpdates cancelLocationUpdate= $cancelLocationUpdate   isOffline= $isOffline");
    CustomParameters.homeTabPositionStream = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 2)
        .listen((Position position) {
      print("getLocationUpdates Status  Inside= $cancelLocationUpdate   isOffline= $isOffline");
      CustomParameters.currentPosition = new Location(longitude: position.longitude,latitude: position.latitude);

      if (isOffline) {
        //Update the location to the firebase
        print("LocationUpdates -> ${CustomParameters.currentFirebaseUser.uid} ON ${position.latitude.toString()} and ${position.longitude.toString()}");
        Geofire.setLocation(
            CustomParameters.currentFirebaseUser.uid, position.latitude, position.longitude);
      }
      if (cancelLocationUpdate) {
        //changedx1
        //CustomParameters.homeTabPositionStream?.cancel();
      } else {
        LatLng pos = LatLng(position.latitude, position.longitude);
        mapController.animateCamera(CameraUpdate.newLatLng(pos));
      }
    });
  }

  @override
  void deactivate() {
    mapController.dispose();
    super.deactivate();
  }

  /*
    Dispose is called when the State object is removed, which is permanent.
    This method is where you should unsubscribe and cancel all animations, streams, etc.
    */
  @override
  void dispose() {
    if(CustomParameters.homeTabPositionStream != null){
      CustomParameters.homeTabPositionStream!.cancel();
    }
    super.dispose();
  }

}
