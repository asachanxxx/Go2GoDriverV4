import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/driverBalanceViewModel.dart';
import 'package:my_cab_driver/wallet/paymentMethod.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/widgets/devider_widget.dart';
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final f = new DateFormat('yyyy-MM-dd hh:mm');
  double balance = 0.00;
  var legerEntries;
  var formatter = new DateFormat('dd-MM-yyyy');
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
                      color: isError
                          ? Color(0xFFd32f2f)
                          : Theme.of(context).primaryColor,
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

    // Future<bool> saveTrip() async {
    //   Map bodyMap = {"userName": "Asanga", "password": "(z^yP{AHwe2?f}-c"};
    //   String url =
    //       'https://go2goweb20220105044841.azurewebsites.net/api/Token/Authenticate';
    //   var response = await http.post(Uri.parse(url),
    //       headers: {"Content-Type": "application/json"},
    //       body: jsonEncode(
    //           {"userName": "Asanga", "password": "(z^yP{AHwe2?f}-c"}));
    //   print(
    //       "response.statusCode  ${response.statusCode}  response.body ${response.body}");
    //   String urlAddTrip =
    //       "https://go2goweb20220105044841.azurewebsites.net/api/Trip/add-trip/";
    //   //+CustomParameters.currentFirebaseUser.uid;
    //   var responseLegderEntries = await http.post(Uri.parse(urlAddTrip),
    //       headers: {
    //         "Authorization": "Bearer ${response.body}",
    //         "Content-Type": "application/json"
    //       },
    //       body: jsonEncode({
    //         "fKey": "-Ms64Zk9ek37K7L9YTUM",
    //         "driverKey": "7TJKl46iELTK8CFgpw5uNqjTy5z2",
    //         "tripId": 0,
    //         "tripNo": "",
    //         "date": "2021-12-29T20:34:05.317Z",
    //         "distance": 107,
    //         "duration": 255,
    //         "driverId": 10,
    //         "commissionedDriverId": 2,
    //         "commissionedDriverKey": "bjdbAv9XdpfRNFGvG3J4PhUBNpF3",
    //         "vehicleType": 3,
    //         "appPrice": 45,
    //         "commission": 0,
    //         "timePrice": 255,
    //         "totalFare": 5650,
    //         "kmPrice": 5350,
    //         "companyPayable": 0,
    //         "commissionApplicable": true
    //       }));

    //   print(
    //       "responseLegderEntries.statusCode  ${responseLegderEntries.statusCode}  responseLegderEntries.body ${responseLegderEntries.body}");
    //   if (responseLegderEntries.statusCode == 200) {
    //     return Future.value(true);
    //   } else {
    //     return Future.value(false);
    //   }
    // }

    Future<bool> getDriverBalance() async {
      Map bodyMap = {"userName": "Asanga", "password": "(z^yP{AHwe2?f}-c"};
      String url =
          'https://go2goweb20220105044841.azurewebsites.net/api/Token/Authenticate';

      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              {"userName": "Asanga", "password": "(z^yP{AHwe2?f}-c"}));

      print(
          "response.statusCode  ${response.statusCode}  response.body ${response.body}");

      String urlGetBal =
          'https://go2goweb20220105044841.azurewebsites.net/api/UserLedger/get-ledger-balance-for-key/' +
              CustomParameters.currentFirebaseUser.uid.trim();

      print('Bearer ${response.body}');

      var responsegetBal = await http.get(Uri.parse(urlGetBal),
          headers: {"Authorization": "Bearer ${response.body}"});
      print(
          "responsegetBal.statusCode  ${responsegetBal.statusCode}  responsegetBal.body ${responsegetBal.body}");
      if (responsegetBal.statusCode == 200 ||
          responsegetBal.statusCode == 201) {
        balance = jsonDecode(responsegetBal.body)["balance"];
        return Future.value(true);
      } else {
        balance = 0.00;
        return Future.value(false);
      }
    }

    Future<bool> getLedgerEntries() async {
      Map bodyMap = {"userName": "Asanga", "password": "(z^yP{AHwe2?f}-c"};
      String url =
          'https://go2goweb20220105044841.azurewebsites.net/api/Token/Authenticate';

      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              {"userName": "Asanga", "password": "(z^yP{AHwe2?f}-c"}));

      print(
          "response.statusCode  ${response.statusCode}  response.body ${response.body}");
      String urlGetLegderEntries =
          "https://go2goweb20220105044841.azurewebsites.net/api/UserLedger/get-ledger-entries/" +
              CustomParameters.currentFirebaseUser.uid;
      var responseLegderEntries = await http.get(Uri.parse(urlGetLegderEntries),
          headers: {"Authorization": "Bearer ${response.body}"});

      print(
          "responseLegderEntries.statusCode  ${responseLegderEntries.statusCode}  responseLegderEntries.body ${responseLegderEntries.body}");

      if (responseLegderEntries.statusCode == 200 ||
          responseLegderEntries.statusCode == 201) {
        legerEntries = jsonDecode(responseLegderEntries.body);
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    }

    String getFormatedDate(DateTime dateToFormat) {
      var formatter = new DateFormat('dd-MM-yyyy HH-MM');
      String formattedDate = "";
      formattedDate = formatter.format(dateToFormat);
      return formattedDate;
    }

    var builderBalance = FutureBuilder<bool>(
        future: getDriverBalance(), // async work
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var newwidget = Text(
              'LKR $balance',
              style: Theme.of(context).textTheme.headline3!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ConstanceData.secoundryFontColor,
                  fontSize: 30),
            );
            return newwidget;
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });

    var builderParam = FutureBuilder<bool>(
        future: getLedgerEntries(), // async work
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var dPrimaryColor = Color(0xFF455a64);
            var dInfectedColor = Color(0xFFc2185b);
            var dDeathColor = Color(0xFF212121);

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FittedBox(
                child: DataTable(
                  sortColumnIndex: 0,
                  sortAscending: true,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Trip',
                        style: TextStyle(
                          color: dInfectedColor,
                          fontSize: 12.0,
                        ),
                      ),
                      numeric: false,
                      tooltip: "Trip Id",
                    ),
                    DataColumn(
                      label: Text(
                        'Amount',
                        style: TextStyle(
                          color: dInfectedColor,
                          fontSize: 12.0,
                        ),
                      ),
                      numeric: true,
                      tooltip: "Amount",
                    ),
                    DataColumn(
                      label: Text(
                        'Balance',
                        style: TextStyle(
                          color: dInfectedColor,
                          fontSize: 12.0,
                        ),
                      ),
                      numeric: true,
                      tooltip: "Balance",
                    ),
                    DataColumn(
                      label: Text(
                        'Description',
                        style: TextStyle(
                          color: dInfectedColor,
                          fontSize: 12.0,
                        ),
                      ),
                      numeric: false,
                      tooltip: "Description",
                    ),
                  ],
                  rows: legerEntries
                      .map<DataRow>(
                        (country) => DataRow(
                          cells: [
                            DataCell(
                              Container(
                                width: 10,
                                child: Text(
                                  country["tripId"].toString(),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 50,
                                child: Text(
                                  country["amount"].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 50,
                                child: Text(
                                  country["balance"].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 100,
                                child: Text(
                                  country["description"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Container(
            height: 200,
            child: Column(
              children: [
                SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: const CircularProgressIndicator()),
              ],
            ),
          );
        });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
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
        width: MediaQuery.of(context).size.width * 0.75 < 400
            ? MediaQuery.of(context).size.width * 0.75
            : 350,
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
                        builderBalance,
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 14, left: 14, top: 10, bottom: 1),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('PAYMENT HISTORY'),
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
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
                flex: 9,
                child: Padding(
                  padding: EdgeInsets.only(right: 14, left: 14, bottom: 16),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: builderParam),
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
