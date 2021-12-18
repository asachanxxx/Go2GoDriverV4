import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/wallet/paymentMethod.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/widgets/devider_widget.dart';
import 'package:intl/intl.dart';

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final f = new DateFormat('yyyy-MM-dd hh:mm');

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
                      color: isError ? Color(0xFFd32f2f) : Theme.of(context).primaryColor,
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
            .child('drivers/${CustomParameters.currentFirebaseUser.uid}/paymentHistory')
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
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: <Widget>[
                                                CircleAvatar(
                                                  radius: 24,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(40),
                                                    child: Image.asset(
                                                      ConstanceData.user5,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 16,
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      AppLocalizations.of(
                                                          f.format(new DateTime.fromMillisecondsSinceEpoch(DateTime.parse(list[index]["date"]).microsecond*1000))
                                                      ),
                                                      style: Theme.of(context).textTheme.headline6!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Theme.of(context).textTheme.headline6!.color,
                                                      ),
                                                    ),
                                                    Text(
                                                      '#6467488',
                                                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).disabledColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(child: SizedBox()),
                                                Text(
                                                  '\$25.00',
                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).textTheme.headline6!.color,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 0.5,
                                            color: Theme.of(context).disabledColor,
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
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar:

      AppBar(
        elevation: 0,
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
                      color: ConstanceData.secoundryFontColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of('My Wallet'),
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ConstanceData.secoundryFontColor,
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

      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75 < 400 ? MediaQuery.of(context).size.width * 0.75 : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Wallet',
          ),
        ),
      ),


      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            border: Border.all(
                              color: ConstanceData.secoundryFontColor,
                            ),
                          ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14, left: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '\$325.00',
                          style: Theme.of(context).textTheme.headline3!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: ConstanceData.secoundryFontColor,
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
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14, left: 14, top: 23, bottom: 1),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('PAYMENT HISTORY'),
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child:Padding(
                  padding: EdgeInsets.only(right: 14, left: 14, bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: builderParam
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: SizedBox(),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40, left: 40),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethod(),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            radius: 24,
                            child: Icon(
                              FontAwesomeIcons.dollarSign,
                              color: ConstanceData.secoundryFontColor,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            AppLocalizations.of('Payment method'),
                            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.headline6!.color,
                                ),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Theme.of(context).disabledColor,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
                flex: 15,
              )
            ],
          )
        ],
      ),
    );
  }
}
