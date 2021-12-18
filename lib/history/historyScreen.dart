import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/widgets/devider_widget.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    Widget returnControlMessage(String message1, String message2,
        bool isError) {
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
            .child('drivers/${CustomParameters.currentFirebaseUser.uid}/tripHistory')
            .onValue, // async work
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget newwidget;
          List<dynamic> list;
          if (snapshot != null) {
            if (snapshot.data != null) {
              if (snapshot.data.snapshot != null) {
                if (snapshot.data.snapshot.value != null) {
                  if (snapshot.hasData) {
                    newwidget = new Container(child: Text("Hello"),);
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        newwidget = Text("Loading......");
                        break;
                      default:
                        Map<dynamic, dynamic> map = snapshot.data.snapshot
                            .value;
                        list = map.values.toList();
                        print("rideBookingsdriverList snapshot list $list");
                        newwidget = ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            print(" rideBookingsdriverList ${list[index]}");
                            var mType = list[index]["type"] != null
                                ? list[index]["type"]
                                : "Message";
                            return
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  shape:  new RoundedRectangleBorder(
                                      side: new BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                                      borderRadius: BorderRadius.circular(4.0)),
                                  color: Color(0xFFfafafa),
                                  child:Container(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(16), topStart: Radius.circular(16)),
                                              color: Theme.of(context).dividerColor,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(14),
                                              child: Row(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.asset(
                                                      ConstanceData.userImage,
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        AppLocalizations.of('${list[index]["customerName"] != null ? list[index]["customerName"] : "Go2Go Customer "}'),
                                                        style: Theme.of(context).textTheme.headline6!.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
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
                                                                AppLocalizations.of( 'LKR ${list[index]["fare"]}'),
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
                                                                AppLocalizations.of( '${list[index]["directionDetailsGoogle"]["durationText"]}'),
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
                                                        '${list[index]["directionDetailsGoogle"]["distanceText"]}',
                                                        style: Theme.of(context).textTheme.headline6!.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 13,
                                                          color: Theme.of(context).textTheme.headline6!.color,
                                                        ),
                                                      ),
                                                      // Text(
                                                      //   '${list[index]["directionDetailsGoogle"]["durationText"]}',
                                                      //   style: Theme.of(context).textTheme.caption!.copyWith(
                                                      //     color: Theme.of(context).disabledColor,
                                                      //     fontWeight: FontWeight.bold,
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 1,
                                            width: MediaQuery.of(context).size.width,
                                            color: Theme.of(context).dividerColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 14, left: 14, bottom: 4, top: 4),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  AppLocalizations.of('PICKUP:'),
                                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                                    color: Theme.of(context).primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  AppLocalizations.of(list[index]["destinationAddress"]),
                                                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Theme.of(context).textTheme.headline6!.color,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 14, left: 14),
                                            child: Container(
                                              height: 1,
                                              width: MediaQuery.of(context).size.width,
                                              color: Theme.of(context).dividerColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 14, left: 14, bottom: 4, top: 4),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  AppLocalizations.of('DROP  :'),
                                                  style: Theme.of(context).textTheme.caption!.copyWith(
                                                    color: Theme.of(context).primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  AppLocalizations.of(list[index]["pickupAddress"]),
                                                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Theme.of(context).textTheme.headline6!.color,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
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
        }
    );

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'History',
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
                AppLocalizations.of('Trip History'),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline6!.color,
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
      body:
      Column(
        children: <Widget>[
          Expanded(
              child: builderParam
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 16,
          )
        ],
      ),
    );
  }

  Widget jobsAndEarns() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.carAlt,
                      size: 40,
                      color: ConstanceData.secoundryFontColor,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('Total Job'),
                          style: Theme.of(context).textTheme.button!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
                              ),
                        ),
                        Text(
                          '10',
                          style: Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold,
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
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: ConstanceData.secoundryFontColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.dollarSign,
                      size: 38,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('Earned'),
                          style: Theme.of(context).textTheme.button!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                        Text(
                          '\$325',
                          style: Theme.of(context).textTheme.headline6!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget celanderList() {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Sun'),
                    style: Theme.of(context).textTheme.button!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '1',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Mon'),
                    style: Theme.of(context).textTheme.button!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '2',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Tue'),
                    style: Theme.of(context).textTheme.button!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '3',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Wed'),
                    style: Theme.of(context).textTheme.button!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '4',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Thu'),
                    style: Theme.of(context).textTheme.button!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '5',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Fri'),
                    style: Theme.of(context).textTheme.button!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '6',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Sat'),
                    style: Theme.of(context).textTheme.button!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '7',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of('Sun'),
                    style: Theme.of(context).textTheme.button!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    '8',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            ),
            width: 50,
          ),
        ],
      ),
    );
  }
}
