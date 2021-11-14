import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_cab_driver/auth/documentInfo.dart';
import 'package:my_cab_driver/auth/signUpScreen.dart';
import 'package:my_cab_driver/auth/userstatusscreen_block.dart';
import 'package:my_cab_driver/auth/userstatusscreen_pending.dart';
import 'package:my_cab_driver/auth/vehicleInfo.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/home/homeScreen.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class LegacyLoginScreen extends StatefulWidget {
  const LegacyLoginScreen({Key? key}) : super(key: key);

  @override
  _LegacyLoginScreenState createState() => _LegacyLoginScreenState();
}





class _LegacyLoginScreenState extends State<LegacyLoginScreen> {
  String countryCode = "+91";
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isId = false;
  late UserCredential userCredential;

  void login() async {
    //show please wait dialog
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (BuildContext context) => ProgressDialog(
    //     status: 'Logging you in',
    //   ),
    // );

    print("isId = $isId");

    if(isId) {
      final dbRef = FirebaseDatabase.instance.reference().child(
          "listTree/driverList");
      var val = await dbRef.orderByChild("id").equalTo("D00100").once();
      print("val = ${val.value}");
      var email = "No";
      val.value.entries.forEach((snapshot) {
        email = snapshot.value["email"];
      });
      print("email = $email");

      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email, password: passwordController.text)
          .catchError((ex) {
        //check error and display message
        Navigator.pop(context);
        showAlert(context,ex.message);
      });


    }else {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text)
          .catchError((ex) {
        //check error and display message
       // Navigator.pop(context);
        showAlert(context,ex.message);
      });
    }

    User? user = userCredential.user;
    if (user != null) {
      // verify login
      print("user ${userCredential.user}");
      DatabaseReference userRef = FirebaseDatabase.instance
          .reference()
          .child('drivers/${user.uid}/profile');
      userRef.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {

          var accStatus = snapshot.value["accountStatus"];
          print("accStatus $accStatus");
          if (accStatus == "NoVehicleDet") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleInfo(),
              ),
            );
          } else if (accStatus == "NoImageDet") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DocumentInfo(),
              ),
            );
          } else if (accStatus == "Banned") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserStatusBlockScreen(),
              ),
            );
          } else if (accStatus == "Pending") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserStatusPendingScreen(),
              ),
            );
          } else {

            CustomParameters.currentFirebaseUser = FirebaseAuth.instance.currentUser!;
            print("Final Status CHeck $accStatus  CustomParameters.currentFirebaseUser = ${CustomParameters.currentFirebaseUser}");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
        } else {
          //check error and display message
          //Navigator.pop(context);
          showAlert(context,
              "This account has no Associated driver account(මෙම ගිණුමට සම්බන්ද වු ධාවක ගිණුමක් නොමැත)");
        }
      });
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
        child: Stack(
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
              padding: const EdgeInsets.only(right: 14, left: 14 , top: 80),
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
                          color: Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, left: 18, right: 18),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('Go2Go'),
                                    style: Theme.of(context).textTheme.headline4!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      AppLocalizations.of(' Driver'),
                                      style: Theme.of(context).textTheme.headline5!.copyWith(
                                        color: Theme.of(context).textTheme.headline6!.color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalizations.of('log in with e-mail'),
                                    style: Theme.of(context).textTheme.headline5!.copyWith(
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                  color: Theme.of(context).backgroundColor,
                                ),
                                child: TextFormField(
                                  controller: emailController,
                                  autofocus: true,
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Theme.of(context).textTheme.headline6!.color,
                                  ),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'email/Password',
                                    prefixIcon: Icon(
                                      Icons.email,
                                      size: 20,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
                                    hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Theme.of(context).textTheme.headline1!.color
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 20,
                              ),

                              Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Theme.of(context).dividerColor),
                                  color: Theme.of(context).backgroundColor,
                                ),
                                child: TextFormField(
                                  autofocus: false,
                                  controller: passwordController,
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Theme.of(context).textTheme.headline6!.color,
                                  ),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintText: 'password',
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      size: 20,
                                      color: Theme.of(context).textTheme.headline6!.color,
                                    ),
                                    hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
                                      color: Theme.of(context).textTheme.headline1!.color,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () async{
                                  login();
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).textTheme.headline6!.color,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('LOGIN'),
                                      style: Theme.of(context).textTheme.button!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).textTheme.headline6!.color,
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of('SIGNUP'),
                                      style: Theme.of(context).textTheme.button!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
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



