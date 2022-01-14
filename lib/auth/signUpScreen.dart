import 'package:animator/animator.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_cab_driver/Services/financeServices.dart';
import 'package:my_cab_driver/Services/serialService.dart';
import 'package:my_cab_driver/auth/legacyLoginScreen.dart';
import 'package:my_cab_driver/auth/vehicleInfo.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/auth/phoneAuthScreen.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/models/dailyParameters.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var appBarheight = 0.0;
  String countryCode = "+91";
  final fullNameController = TextEditingController();
  final phoneContoller = TextEditingController();
  final emailContoller = TextEditingController();
  final passwordContoller = TextEditingController();
  final nicContoller = TextEditingController();
  // Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('IN');

  @override
  Widget build(BuildContext context) {
    appBarheight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 14, left: 14),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: appBarheight,
                    ),
                    Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              children: <Widget>[
                                Animator<Offset>(
                                  tween: Tween<Offset>(
                                    begin: Offset(0, 0.4),
                                    end: Offset(0, 0),
                                  ),
                                  duration: Duration(milliseconds: 700),
                                  cycles: 1,
                                  builder: (context, animate, _) =>
                                      SlideTransition(
                                    position: animate.animation,
                                    child: Image.asset(
                                      ConstanceData.splashBackground,
                                      fit: BoxFit.cover,
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                Padding(
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
                                                  fontWeight: FontWeight.bold,
                                                  color: ConstanceData
                                                      .secoundryFontColor,
                                                ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Text(
                                              AppLocalizations.of(' Driver'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5!
                                                  .copyWith(
                                                    color: ConstanceData
                                                        .secoundryFontColor,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(
                                                ' Sign in with e-mail'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(
                                                  color: ConstanceData
                                                      .secoundryFontColor,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16, left: 16),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Theme.of(context).dividerColor),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                  child: TextFormField(
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(25),
                                    ],
                                    controller: fullNameController,
                                    autofocus: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .color,
                                        ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Full Name',
                                      prefixIcon: Icon(
                                        Icons.drive_file_rename_outline,
                                        size: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .color),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Theme.of(context).dividerColor),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                  child: TextFormField(
                                    controller: emailContoller,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[A-Za-z@.0-9]')),
                                    ],
                                    autofocus: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .color,
                                        ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'E-Mail',
                                      prefixIcon: Icon(
                                        Icons.email,
                                        size: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .color),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Theme.of(context).dividerColor),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                  child: TextFormField(
                                    controller: phoneContoller,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    autofocus: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .color,
                                        ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Mobile No',
                                      prefixIcon: Icon(
                                        Icons.mobile_friendly,
                                        size: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .color),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Theme.of(context).dividerColor),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                  child: TextFormField(
                                    controller: passwordContoller,
                                    autofocus: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .color,
                                        ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      prefixIcon: Icon(
                                        Icons.vpn_key_sharp,
                                        size: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .color),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        color: Theme.of(context).dividerColor),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                  child: TextFormField(
                                    controller: nicContoller,
                                    autofocus: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .color,
                                        ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'ID Card No',
                                      prefixIcon: Icon(
                                        Icons.card_membership,
                                        size: 20,
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .headline1!
                                                  .color),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 36,
                                ),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () async {
                                    await registerDriver(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .color,
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of('NEXT'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .button!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
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
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of('Already have an account?'),
                          style: Theme.of(context).textTheme.button!.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .color,
                              ),
                        ),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LegacyLoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(' Sign In'),
                            style: Theme.of(context).textTheme.button!.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .color,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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

  registerDriver(context) async {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailContoller.text);
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.mobile &&
        connectivity != ConnectivityResult.wifi) {
      print(
          'It seems you are offline.(කරුණාකර ඔබගේ දුරකතනයේ අන්තර්ජාල සම්බන්දතාවය පන ගන්වන්න)');
      return;
    }
    if (fullNameController.text.length < 8) {
      showAlert(context,
          'Full name must be more than 3 characters.(සම්පූර්ණ නම අක්ෂර 8 ට වඩා වැඩි විය යුතුය.)');
      return;
    }
    if (!emailValid) {
      showAlert(context,
          'Invalid E-Mail address.(කරුණාකර වලංගු ඊමේල් ලිපිනයක් ඇතුලත් කරන්න )');
      return;
    }
    if (phoneContoller.text.length != 10) {
      showAlert(context,
          'Phone number must be 10 characters.(දුරකථන අංකය අක්ෂර 10 ක් විය යුතුය)');
      return;
    }

    if (passwordContoller.text.length < 6) {
      showAlert(context,
          'The password must be at least 6 characters.(මුරපදය අවම වශයෙන් අක්ෂර 6 ක් විය යුතුය)');
      return;
    }
    if (!isNicValid(nicContoller.text.trim())) {
      showAlert(context,
          'invalid National Id card number.(කරුණාකර වලංගු ජාතික හැඳුනුම්පත් අංකයක්  ඇතුලත් කරන්න)');
      return;
    }

    registerUser(emailContoller.text, passwordContoller.text);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleInfo(),
      ),
    );
  }

  bool isNicValid(String nic) {
    print("nic: - $nic  Length : ${nic.length}");

    bool nicValid = false;
    if (nic.length <= 10) {
      nicValid = RegExp(r"^(?:[+0]9)?[0-9]{9}[V,X,v,x]$").hasMatch(nic);
    } else {
      nicValid = RegExp(r"^(?:[+0]9)?[0-9]{12}$").hasMatch(nic);
    }
    return nicValid;
  }

  void registerUser(text1, text2) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailContoller.text, password: passwordContoller.text);

      DatabaseReference newuser = FirebaseDatabase.instance
          .reference()
          .child('drivers/${userCredential.user!.uid}/profile');
      var serial = await SerialService.getSerial(SetialTypes.driver);
      print("serial $serial");

      Map usermap = {
        'key': userCredential.user!.uid,
        'id': serial,
        'fullName': fullNameController.text,
        'email': emailContoller.text,
        'phoneNumber': phoneContoller.text,
        'pass': passwordContoller.text,
        'nic': nicContoller.text,
        'accountStatus': "NoVehicleDet",
        'SCR': 10.0,
        'ODR': 5.0,
        'datetime': DateTime.now().toString(),
        'driverLevel': "BasicLevel",
      };
      newuser.set(usermap);

      DatabaseReference listUsers = FirebaseDatabase.instance
          .reference()
          .child('listTree/driverList/${userCredential.user!.uid}');
      listUsers.set(usermap);

      ///Add Empty Account entry
      Map dailyFinanceMap = {
        'earning': 0.00,
        'commission': 0.00,
        'driveHours': 0,
        'totalDistance': 0,
        'totalTrips': 0,
      };
      FinanceService.handleDailyFinance(dailyFinanceMap);

      print('Hurray! Account created successfully');
      //Navigator.pushNamed(context, VehicleInfo.Id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Oops! The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('Oops! The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
      print('Oops! There is a problem! Try again later.');
    }
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
