import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/widgets/buttons_widget.dart';
import 'package:my_cab_driver/widgets/devider_widget.dart';
import '../appTheme.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

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
            .reference()
            .child(
                'rideBookingsdriverList/${CustomParameters.currentFirebaseUser.uid}')
            .orderByChild("accepted")
            .equalTo(false)
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
                                                acceptBooking(
                                                    list[index]["bookingId"]);
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
                                                        'Accept'),
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
                      "No Trip Requests",
                      "There are no trip requests found to accept.( සංචාර ඉල්ලීම් කිසිවක් නැත .)",
                      false);
                }
              } else {
                newwidget = returnControlMessage(
                    "No Trip Requests",
                    "There are no trip requests found to accept.( සංචාර ඉල්ලීම් කිසිවක් නැත .)",
                    false);
              }
            } else {
              newwidget = returnControlMessage(
                  "No Trip Requests",
                  "There are no trip requests found to accept.( සංචාර ඉල්ලීම් කිසිවක් නැත .)",
                  false);
            }
          } else {
            newwidget = returnControlMessage(
                "No Trip Requests",
                "There are no trip requests found to accept.( සංචාර ඉල්ලීම් කිසිවක් නැත .)",
                false);
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
            selectItemName: 'Notification',
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
                AppLocalizations.of('Notifications'),
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

  void acceptBooking(String bookingID) async {
    print("acceptBooking bookingID: $bookingID");
    DatabaseReference instance = FirebaseDatabase.instance
        .reference()
        .child('rideBookings/$bookingID/drivers');
    instance.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        var drivers = snapshot.value;
        snapshot.value.forEach((snapshot) {
          print(
              "accStatus $snapshot Driver ID ${CustomParameters.currentFirebaseUser.uid}");
          DatabaseReference instanceX1 = FirebaseDatabase.instance
              .reference()
              .child('rideBookingsdriverList/$snapshot/$bookingID');
          instanceX1.remove();
        });
      }
    });

    DatabaseReference instanceBase =
        FirebaseDatabase.instance.reference().child('rideBookings/$bookingID/');
    instanceBase.child("status").set("Accepted");
    instanceBase
        .child("AcceptedDriver")
        .set(CustomParameters.currentFirebaseUser.uid);
  }
}














































// Container(
// color: Theme.of(context).scaffoldBackgroundColor,
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Row(
// children: <Widget>[
// CircleAvatar(
// backgroundColor: HexColor("#FED428"),
// radius: 24,
// child: Center(
// child: Padding(
// padding: const EdgeInsets.only(right: 2),
// child: Icon(
// FontAwesomeIcons.ticketAlt,
// size: 22,
// color: Colors.black,
// ),
// ),
// ),
// ),
// SizedBox(
// width: 16,
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Text(
// AppLocalizations.of('Promotion'),
// style: Theme.of(context).textTheme.bodyText2!.copyWith(
// fontWeight: FontWeight.bold,
// color: Theme.of(context).textTheme.headline6!.color,
// ),
// ),
// SizedBox(
// height: 2,
// ),
// Text(
// AppLocalizations.of('Invite friends-GEt 3 coupens each!'),
// style: Theme.of(context).textTheme.subtitle2!.copyWith(
// fontWeight: FontWeight.bold,
// color: Theme.of(context).textTheme.headline6!.color,
// ),
// overflow: TextOverflow.ellipsis,
// ),
// ],
// )
// ],
// ),
// ),
// ),
// Container(
// height: 1,
// color: Theme.of(context).dividerColor,
// ),
// Container(
// color: Theme.of(context).scaffoldBackgroundColor,
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Row(
// children: <Widget>[
// CircleAvatar(
// backgroundColor: HexColor("#F52C56"),
// radius: 24,
// child: Center(
// child: CircleAvatar(
// backgroundColor: Colors.white,
// radius: 12,
// child: Icon(
// Icons.close,
// size: 20,
// color: HexColor("#F52C56"),
// ),
// ),
// ),
// ),
// SizedBox(
// width: 16,
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Text(
// AppLocalizations.of('System'),
// style: Theme.of(context).textTheme.bodyText2!.copyWith(
// fontWeight: FontWeight.bold,
// color: Theme.of(context).textTheme.headline6!.color,
// ),
// ),
// SizedBox(
// height: 2,
// ),
// Text(
// AppLocalizations.of('Booking #156 has been cancelled.'),
// style: Theme.of(context).textTheme.subtitle2!.copyWith(
// fontWeight: FontWeight.bold,
// color: Theme.of(context).textTheme.headline6!.color,
// ),
// overflow: TextOverflow.ellipsis,
// ),
// ],
// )
// ],
// ),
// ),
// ),
// Container(
// height: 1,
// color: Theme.of(context).dividerColor,
// ),
// Container(
// color: Theme.of(context).scaffoldBackgroundColor,
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Row(
// children: <Widget>[
// CircleAvatar(
// backgroundColor: HexColor("#4BE4B0"),
// radius: 24,
// child: Center(
// child: Icon(
// FontAwesomeIcons.wallet,
// size: 22,
// color: Colors.white,
// ),
// ),
// ),
// SizedBox(
// width: 16,
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Text(
// AppLocalizations.of('System'),
// style: Theme.of(context).textTheme.bodyText2!.copyWith(
// fontWeight: FontWeight.bold,
// color: Theme.of(context).textTheme.headline6!.color,
// ),
// ),
// SizedBox(
// height: 2,
// ),
// Text(
// AppLocalizations.of('Thank you Your transaction is done'),
// style: Theme.of(context).textTheme.subtitle2!.copyWith(
// fontWeight: FontWeight.bold,
// color: Theme.of(context).textTheme.headline6!.color,
// ),
// overflow: TextOverflow.clip,
// ),
// ],
// )
// ],
// ),
// ),
// ),
// Container(
// height: 1,
// color: Theme.of(context).dividerColor,
// ),