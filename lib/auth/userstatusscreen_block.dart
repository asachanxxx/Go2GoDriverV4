import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class UserStatusBlockScreen extends StatefulWidget {
  const UserStatusBlockScreen({Key? key}) : super(key: key);

  @override
  _LegacyLoginScreenState createState() => _LegacyLoginScreenState();
}





class _LegacyLoginScreenState extends State<UserStatusBlockScreen> {
  String countryCode = "+91";
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isId = false;
  late UserCredential userCredential;


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

  @override
  Widget build(BuildContext context) {
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
        child: Stack(
          children: <Widget>[
            Container(
              height: 300,
              color: Theme
                  .of(context)
                  .primaryColor,
              child: Animator<Offset>(
                tween: Tween<Offset>(
                  begin: Offset(0, 0.4),
                  end: Offset(0, 0),
                ),
                duration: Duration(seconds: 1),
                cycles: 1,
                builder: (context, animate, _) =>
                    SlideTransition(
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
              padding: const EdgeInsets.only(right: 14, left: 14, top: 80),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme
                              .of(context)
                              .scaffoldBackgroundColor,
                          border: Border.all(color: Theme
                              .of(context)
                              .primaryColor, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 18, right: 18),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('Go2Go'),
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6!
                                          .color,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      AppLocalizations.of(' Driver Blocked'),
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .headline6!
                                            .color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'ඔබගේ ගිණුම තාවකාලිකව අක්‍රීය කර ඇත',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Text(
                                            'ඔබගේ ගිණුම අක්‍රීය කර ඇත. එබැවින් ඔබට පුරනය(login) වීමට නොහැකි වනු ඇත. කරුණාකර ගිණුමක් අක්‍රිය වීමට හේතු බොහෝමයක් ඇති බව මතක තබා ගන්න, අපි සියලු කරුණු ඉතා ප්‍රවේශමෙන් සොයා බලමු. මේ අතර, වැඩි විස්තර සඳහා අපි පසුව ඔබ හා සම්බන්ධ වෙමු',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.roboto(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                'Contact        ',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '+94 011518548 ',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.roboto(
                                                      color: Color(0xFFff6f00),
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '   Hotline  ',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '  +94 0778151151',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.roboto(
                                                      color: Color(0xFFff6f00),
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                '    E-Mail  ',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'inquery@gotogo.com',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.roboto(
                                                      color: Color(0xFFff6f00),
                                                      fontSize: 15,
                                                      fontWeight: FontWeight
                                                          .bold),
                                                ),
                                              ),
                                            ],
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
        ),
      ),
    );
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



