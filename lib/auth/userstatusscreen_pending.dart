import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cab_driver/Services/authService.dart';
import 'package:my_cab_driver/auth/legacyLoginScreen.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/Driver.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../appTheme.dart';

class UserStatusPendingScreen extends StatefulWidget {
  const UserStatusPendingScreen({Key? key}) : super(key: key);

  @override
  _LegacyLoginScreenState createState() => _LegacyLoginScreenState();
}

class _LegacyLoginScreenState extends State<UserStatusPendingScreen> {
  String countryCode = "+91";
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isId = false;
  late UserCredential userCredential;
  late Future<bool> _future;

  @override
  void initState() {
    _future = initializeAll();
    super.initState();
  }

  Future<bool> initializeAll() async {
    await getCurrentDriverInfo();
    return true;
  }

  ///Getting driver information
  Future<void> getCurrentDriverInfo() async {
    print("Inside getCurrentDriverInfo");
    CustomParameters.currentFirebaseUser = FirebaseAuth.instance.currentUser!;
    DatabaseReference driverRef = FirebaseDatabase.instance
        .reference()
        .child('drivers/${CustomParameters.currentFirebaseUser.uid}/profile');

    driverRef.once().then((DataSnapshot snapshot) {
      print(
          "HomeTab- getCurrentDriverInfo isOnlineStatus =   ${snapshot.value["onlineStatus"]}");
      if (snapshot.value != null) {
        CustomParameters.currentDriverInfo = Driver.fromSnapshot(snapshot);
        print("onlineStatus : ${snapshot.value["onlineStatus"] ?? ""}");
      }
    });
  }

  showAlert(context, message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "Go2Go Messaging",
      desc: message,
      style: AlertStyle(
          descStyle: TextStyle(fontSize: 15),
          titleStyle: TextStyle(color: Color(0xFFEB1465))),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: FutureBuilder<bool>(
              future: _future, // a Future<String> or null
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return loadingIndicators('Waiting for connection....');
                  case ConnectionState.waiting:
                    return loadingIndicators('Initializing....');
                  default:
                    if (snapshot.hasError) {
                      return loadingIndicators('Error: ${snapshot.error}');
                    } else {
                      print("snapshot -> $snapshot");
                      print(
                          "CustomParameters.currentDriverInfo  -> ${CustomParameters.currentDriverInfo}");
                      return Stack(
                        children: <Widget>[
                          Container(
                            height: 300,
                            color: Theme.of(context).primaryColor,
                            child: Animator<Offset>(
                              tween: Tween<Offset>(
                                begin: Offset(0, 0.4),
                                end: Offset(0, 0),
                              ),
                              duration: Duration(seconds: 1),
                              cycles: 1,
                              builder: (context, animate, _) => SlideTransition(
                                position: animate.animation,
                                child: Image.asset(
                                  ConstanceData.splashBackground,
                                  fit: BoxFit.fill,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 14, left: 14, top: 80),
                            child: SingleChildScrollView(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        border: Border.all(
                                            color:
                                                Theme.of(context).primaryColor,
                                            width: 1.5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 18, right: 18),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  AppLocalizations.of('Go2Go'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline4!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .color,
                                                      ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                        ' Driver Pending'),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline6!
                                                                  .color,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white),
                                              child: Column(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Go2Go වෙත සාදරයෙන් පිළිගනිමු.',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(20.0),
                                                    child: Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          'ඔබ දැනටමත් Go2GO සමඟ ගිණුමක් නිර්මාණය කර ඇති නමුත් ගිණුම තවමත් සක්‍රිය කර නොමැත. අපි ඔබේ තොරතුරු සකසා ඔබගේ ගිණුම සක්‍රිය කරන තුරු කරුණාකර රැඳී සිටින්න. සක්‍රිය කිරීමෙන් පසු ඔබට ගිණුමට ලොග් වී සියලු අංග භුක්ති විඳිය හැකිය.',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              'Contact        ',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.roboto(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '+94 011518548 ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.roboto(
                                                                    color: Color(
                                                                        0xFFff6f00),
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              '   Your DriverId  ',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.roboto(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                CustomParameters
                                                                    .currentDriverInfo
                                                                    .driverId,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.roboto(
                                                                    color: Color(
                                                                        0xFFff6f00),
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              ' Your E-Mail  ',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.roboto(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                CustomParameters
                                                                    .currentDriverInfo
                                                                    .email,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: GoogleFonts.roboto(
                                                                    color: Color(
                                                                        0xFFff6f00),
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        InkWell(
                                                          highlightColor: Colors
                                                              .transparent,
                                                          splashColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            AuthService
                                                                .signOut();
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LegacyLoginScreen(),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6!
                                                                  .color,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                AppLocalizations
                                                                    .of('LOGOFF'),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .button!
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        InkWell(
                                                          highlightColor: Colors
                                                              .transparent,
                                                          splashColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            DatabaseReference
                                                                dref =
                                                                FirebaseDatabase
                                                                    .instance
                                                                    .reference()
                                                                    .child(
                                                                        "inquiry")
                                                                    .push();
                                                            Map inqueryMap = {
                                                              'userId':
                                                                  CustomParameters
                                                                      .currentFirebaseUser
                                                                      .uid,
                                                              'type':
                                                                  "AccActivation",
                                                              'des':
                                                                  'Request to activate account'
                                                            };
                                                            dref.set(
                                                                inqueryMap);
                                                            showAlert(context,
                                                                "your inquiry has been submitted successfully.we will get back to you shortly. (ඔබේ ප්‍රශ්නය සාර්ථකව ඉදිරිපත් කර ඇත. අපි ඉක්මනින් ඔබව සම්බන්දකරගන්නෙමු )");
                                                          },
                                                          child: Container(
                                                            height: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6!
                                                                  .color,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                AppLocalizations
                                                                    .of('NOTIFY'),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .button!
                                                                    .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .scaffoldBackgroundColor,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                      flex: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }
                }
              })),
    );
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
            color: AppTheme.isLightTheme
                ? Colors.black.withOpacity(0.2)
                : Colors.white.withOpacity(0.2),
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
          Text(
            AppLocalizations.of(message),
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          )
        ],
      ),
    ));
  }

  String getCountryString(String str) {
    var newString = '';
    var isFirstdot = false;
    for (var i = 0; i < str.length; i++) {
      if (isFirstdot == false) {
        if (str[i] != ',') {
          newString = newString + str[i];
        } else {
          isFirstdot = true;
        }
      }
    }
    return newString;
  }
}
