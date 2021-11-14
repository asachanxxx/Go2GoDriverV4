import 'package:animator/animator.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_cab_driver/Services/serialService.dart';
import 'package:my_cab_driver/auth/documentInfo.dart';
import 'package:my_cab_driver/auth/legacyLoginScreen.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/auth/phoneAuthScreen.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'loginScreen.dart';

class VehicleInfo extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<VehicleInfo> {
  var appBarheight = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  late DateTime selectedDate;
  final plateNoContoller = TextEditingController();
  final modelContoller = TextEditingController();
  final makeContoller = TextEditingController();
  final colorContoller = TextEditingController();
  final insuranceNumberContoller = TextEditingController();
  final insuranceExpiryDateContoller = TextEditingController();
  String accountname = 'Select a vehicle type';

  List<String> accountNames = [
    "Select a vehicle type",
    "Tuk",
    "Nano",
    "Alto",
    "WagonR",
    "Classic",
    "Deluxe",
    "Mini-Van",
    "Van",
  ];

  @override
  void initState() {
    selectedDate = DateTime.now();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    appBarheight = AppBar().preferredSize.height + MediaQuery
        .of(context)
        .padding
        .top;
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
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
                      color: Theme
                          .of(context)
                          .scaffoldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .primaryColor,
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of('Go2Go'),
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headline4!
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: ConstanceData
                                                  .secoundryFontColor,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10),
                                            child: Text(
                                              AppLocalizations.of(' Driver'),
                                              style: Theme
                                                  .of(context)
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: <Widget>[
                                          Text(
                                            AppLocalizations.of(
                                                ' Vehicle information'),
                                            style: Theme
                                                .of(context)
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: Theme
                                        .of(context)
                                        .dividerColor),
                                    color: Theme
                                        .of(context)
                                        .backgroundColor,
                                  ),
                                  child: TextFormField(
                                    controller: plateNoContoller,
                                    autofocus: true,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6!
                                          .color,
                                    ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Plate No (EX: BCD-6555)',
                                      prefixIcon: Icon(
                                        Icons.drive_file_rename_outline,
                                        size: 20,
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                      hintStyle: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                          color: Theme
                                              .of(context)
                                              .textTheme
                                              .headline1!
                                              .color
                                      ),
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: Theme
                                        .of(context)
                                        .dividerColor),
                                    color: Theme
                                        .of(context)
                                        .backgroundColor,
                                  ),
                                  child: TextFormField(
                                    controller: makeContoller,
                                    autofocus: true,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6!
                                          .color,
                                    ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Vehicle Make (EX: Suzuki)',
                                      prefixIcon: Icon(
                                        Icons.email,
                                        size: 20,
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                      hintStyle: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                          color: Theme
                                              .of(context)
                                              .textTheme
                                              .headline1!
                                              .color
                                      ),
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: Theme
                                        .of(context)
                                        .dividerColor),
                                    color: Theme
                                        .of(context)
                                        .backgroundColor,
                                  ),
                                  child: TextFormField(
                                    controller: modelContoller,
                                    autofocus: true,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6!
                                          .color,
                                    ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Vehicle Model (EX: Alto)',
                                      prefixIcon: Icon(
                                        Icons.mobile_friendly,
                                        size: 20,
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                      hintStyle: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                          color: Theme
                                              .of(context)
                                              .textTheme
                                              .headline1!
                                              .color
                                      ),
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: Theme
                                        .of(context)
                                        .dividerColor),
                                    color: Theme
                                        .of(context)
                                        .backgroundColor,
                                  ),
                                  child: TextFormField(
                                    controller: colorContoller,
                                    autofocus: true,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6!
                                          .color,
                                    ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Vehicle Color (EX: Red)',
                                      prefixIcon: Icon(
                                        Icons.vpn_key_sharp,
                                        size: 20,
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                      hintStyle: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                          color: Theme
                                              .of(context)
                                              .textTheme
                                              .headline1!
                                              .color
                                      ),
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                    border: Border.all(color: Theme
                                        .of(context)
                                        .dividerColor),
                                    color: Theme
                                        .of(context)
                                        .backgroundColor,
                                  ),
                                  child: TextFormField(
                                    controller: insuranceNumberContoller,
                                    autofocus: true,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6!
                                          .color,
                                    ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Insurance No(EX: MCCNH200441011)',
                                      prefixIcon: Icon(
                                        Icons.card_membership,
                                        size: 20,
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                      hintStyle: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                          color: Theme
                                              .of(context)
                                              .textTheme
                                              .headline1!
                                              .color
                                      ),
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
                                    registerVehicle();
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6!
                                          .color,
                                    ),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of('NEXT'),
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .button!
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme
                                              .of(context)
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
                          style: Theme
                              .of(context)
                              .textTheme
                              .button!
                              .copyWith(
                            color: Theme
                                .of(context)
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
                            style: Theme
                                .of(context)
                                .textTheme
                                .button!
                                .copyWith(
                              color: Theme
                                  .of(context)
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

  void registerVehicle() async {
    print("FirebaseAuth.instance.currentUser ${FirebaseAuth.instance
        .currentUser}");
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        DatabaseReference dbRef2 = FirebaseDatabase.instance.reference().child(
            'drivers/${FirebaseAuth.instance.currentUser!
                .uid}/profile/accountStatus');
        dbRef2.set("NoImageDet");
        //dbRef2 = null;

        DatabaseReference dbRef3 = FirebaseDatabase.instance.reference().child(
            'listTree/driverList/${FirebaseAuth.instance.currentUser!
                .uid}/accountStatus');
        dbRef3.set("NoImageDet");
        //dbRef3 = null;

        DatabaseReference dbRef = FirebaseDatabase.instance.reference().child(
            'drivers/${FirebaseAuth.instance.currentUser!
                .uid}/vehicle_details');

        Map vehicleMap = {
          'fleetNo': plateNoContoller.text,
          'make': makeContoller.text,
          'model': modelContoller.text,
          'color': colorContoller.text,
          'insuranceNo': insuranceNumberContoller.text,
          'vehicleType': accountname,
          //'insuranceExpire': "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}"
        };

        dbRef.set(vehicleMap);
        print('Save Done');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentInfo(),
          ),
        );
      } else {
        print('Current User nUll');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }


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
