import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/TripDetails.dart';
import 'package:my_cab_driver/pickup/pickupScreen.dart';
import 'package:my_cab_driver/widgets/devider_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../appTheme.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<BookingScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Location location = Location();
  PermissionStatus? _permissionGranted;
  bool? _serviceEnabled;

  @override
  Widget build(BuildContext context) {
    Widget returnControlMessage(
        String message1, String message2, bool isError) {
      return Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Text(
                  message1,
                  style: GoogleFonts.roboto(
                      fontSize: 15,
                      color: isError ? Color(0xFFd32f2f) : Color(0xFFff6f00),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                BrandDivider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  message2,
                  style: GoogleFonts.roboto(fontSize: 15),
                ),
              ],
            ),
          ));
    }

    var builderParam = StreamBuilder(
        stream: FirebaseDatabase.instance
            .reference()
            .child('rideBookings/')
            .orderByChild("AcceptedDriver")
            .equalTo(CustomParameters.currentFirebaseUser.uid)
            .limitToLast(10)
            .onValue, // async work
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget newwidget;
          List<dynamic> list;
          if (snapshot != null) {
            if (snapshot.data != null) {
              if (snapshot.data.snapshot != null) {
                if (snapshot.data.snapshot.value != null) {
                  if (snapshot.hasData) {
                    newwidget = new Container(
                      child: Text("Hello"),
                    );
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        newwidget = Text("Loading......");
                        break;
                      default:
                        Map<dynamic, dynamic> map =
                            snapshot.data.snapshot.value;
                        list = map.values.toList();
                        print("rideBookingsdriverList snapshot list $list");
                        newwidget = ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(" rideBookingsdriverList ${list[index]}");
                            var mType = list[index]["type"] != null
                                ? list[index]["type"]
                                : "Message";
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                shape: new RoundedRectangleBorder(
                                    side: new BorderSide(
                                        color: Theme.of(context).primaryColor,
                                        width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0)),
                                color: Color(0xFFfafafa),
                                child: Container(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          radius: 24,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Theme.of(context)
                                                .backgroundColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "From",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  list[index]["PickUp"]
                                                      ["placeName"],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .color,
                                                      ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "To     ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  list[index]["Drop"]
                                                      ["placeName"],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .color,
                                                      ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "Time ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${list[index]["tripDate"]["year"]}/${list[index]["tripDate"]["month"]}/${list[index]["tripDate"]["day"]} ${list[index]["triptime"]["hour"]}:${list[index]["triptime"]["minutes"]} PM",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .color,
                                                      ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "UpAndDown ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${list[index]["upAndDown"] == true ? 'Yes' : 'No'}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .color,
                                                      ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Trip For ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "${list[index]["tripMethod"] == 'passenger' ? 'Passenger' : 'Delivery'}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .color,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            InkWell(
                                              highlightColor:
                                                  Colors.transparent,
                                              splashColor: Colors.transparent,
                                              onTap: () async {
                                                showAlertDialog(
                                                    context, list, index);
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    AppLocalizations.of(
                                                        'Start Ride'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .button!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Theme.of(
                                                                  context)
                                                              .scaffoldBackgroundColor,
                                                        ),
                                                  ),
                                                ),
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
                          },
                        );
                        break;
                    }
                  } else {
                    newwidget = Text("Loading......");
                  }
                } else {
                  newwidget = returnControlMessage(
                      "No Messages1", "No messages Found.", false);
                }
              } else {
                newwidget = returnControlMessage(
                    "No Messages2", "No messages Found.", false);
              }
            } else {
              newwidget = returnControlMessage(
                  "No Messages3", "No messages Found.", false);
            }
          } else {
            newwidget = returnControlMessage(
                "No Messages4", "No messages Found.", false);
          }
          return newwidget;
        });

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400
            ? MediaQuery.of(context).size.width * 0.75
            : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'booking',
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
                      color: Theme.of(context).textTheme.headline6!.color,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of('Trip Bookings'),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).backgroundColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: AppBar().preferredSize.height,
              width: AppBar().preferredSize.height + 40,
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: builderParam),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          )
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, list, index) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        print("Cancelled");
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        print("Continue");

        await _checkPermissions();
        if (_permissionGranted != PermissionStatus.granted) {
          await _requestPermission();
        }
        await _checkService();
        if (_serviceEnabled != true) {
          await _requestService();
        }
        location.enableBackgroundMode(enable: true);

        print("list ${list[index]}");
        acceptBooking(context, list[index]);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Go2Go Messaging"),
      content: Text("Do you want to start the booked trip?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void acceptBooking(context, dynamic rideList) async {
    ///need to calculate initial fires for the ride or we can calculate it and save in the booking
    /// need to get the Rider phone number and the Name

    Map destination = {
      "latitude": rideList["Drop"]["latitude"],
      "longitude": rideList["Drop"]["longitude"],
    };
    Map location = {
      "latitude": rideList["PickUp"]["latitude"],
      "longitude": rideList["PickUp"]["longitude"],
    };
    Map driver_location = {
      "latitude": 6.8538166,
      "longitude": 79.88508759999999,
    };

    DatabaseReference rideRef =
        FirebaseDatabase.instance.reference().child('rideRequest').push();
    var rideId = rideRef.key;
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd').add_jm();
    final String formattedDate = formatter.format(now);

    Map rideMap = {
      "key": rideId,
      "created_at": formattedDate,
      "destination": destination,
      "destination_address": rideList["Drop"]["placeName"],
      "driver_id": "waiting",
      "driver_location": driver_location,
      "fares": 0.00,
      "location": location,
      "ownDriver": "system",
      "payment_method": "Cash",
      "pickup_address": rideList["PickUp"]["placeName"],
      "rider_name": rideList["customer"]["name"],
      "rider_Id": rideList["customer"]["id"],
      "rider_phone": rideList["customer"]["phoneNumber"],
      "status": "ended",
      "bookingID": rideList["key"]
    };
    rideRef.set(rideMap);
    print("rideMap ---> $rideMap");

    //writing data to booking records
    DatabaseReference instanceBase = FirebaseDatabase.instance
        .reference()
        .child('rideBookings/${rideList["key"]}/');
    instanceBase.child("status").set("TripStarted");

    var acceptedDriver = rideList["AcceptedDriver"].toString().trim();
    double pickupLat = rideList["PickUp"]["latitude"];
    double pickupLng = rideList["PickUp"]["longitude"];
    String pickupAddress = rideList["PickUp"]["placeName"];

    double destinationLat = rideList["Drop"]["latitude"];
    double destinationLng = rideList["Drop"]["longitude"];
    String destinationAddress = rideList["Drop"]["placeName"];

    String paymentMethod = "Cash";
    String riderName = rideList["customer"]["name"];
    String riderPhone = rideList["customer"]["phoneNumber"];

    TripDetails tripDetails = TripDetails(
        pickupAddress: pickupAddress,
        rideID: rideId,
        destinationAddress: destinationAddress,
        destination: LatLng(destinationLat, destinationLng),
        pickup: LatLng(pickupLat, pickupLng),
        paymentMethod: paymentMethod,
        riderName: riderName,
        riderPhone: riderPhone,
        status: 'init',
        bookingID: rideList["key"]);

    if (acceptedDriver != "system") {
      tripDetails.commissionedDriverId =
          rideList["requestedDriverId"].toString().trim();
      tripDetails.commissionApplicable = true;
    } else {
      tripDetails.commissionedDriverId = "system";
      tripDetails.commissionApplicable = false;
    }
    Navigator.pop(context);
    print(
        "tripDetails.commissionedDriverId = ${tripDetails.commissionedDriverId} tripDetails.commissionApplicable = ${tripDetails.commissionApplicable}");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PickupScreen(
            tripDetails: tripDetails,
            restartRide: true,
            incomeType: 2,
          ),
        ));
  }

  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
    }
  }

  Future<void> _checkService() async {
    final bool serviceEnabledResult = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = serviceEnabledResult;
    });
  }

  Future<void> _requestService() async {
    if (_serviceEnabled == true) {
      return;
    }
    final bool serviceRequestedResult = await location.requestService();
    setState(() {
      _serviceEnabled = serviceRequestedResult;
    });
  }
}
