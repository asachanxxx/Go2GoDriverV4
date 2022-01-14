import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/Services/commonService.dart';
import 'package:my_cab_driver/Services/serialService.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/Customer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddNewCustomer extends StatefulWidget {
  @override
  _AddNewVehicalState createState() => _AddNewVehicalState();
}

class _AddNewVehicalState extends State<AddNewCustomer> {
  final displayNamecontoller = TextEditingController();
  final phonecontoller = TextEditingController();
  final nickNamecontoller = TextEditingController();
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  List<Customer> customerList = [];
  late UserCredential userCredentialx;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).textTheme.headline6!.color,
                ),
              ),
            ),
            Text(
              AppLocalizations.of('Add new customer'),
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).backgroundColor,
                  ),
            ),
            SizedBox(),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 14, left: 14, top: 14),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('Full Name'),
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: displayNamecontoller,
                        keyboardType: TextInputType.text,
                        decoration: CustomParameters.getInputDecorationRegister(
                            context, 'Full Name', Icon(Icons.keyboard)),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('NickName'),
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: nickNamecontoller,
                        keyboardType: TextInputType.text,
                        decoration: CustomParameters.getInputDecorationRegister(
                            context, 'NickName', Icon(Icons.keyboard)),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            AppLocalizations.of('Mobile No'),
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextField(
                        controller: phonecontoller,
                        keyboardType: TextInputType.text,
                        decoration: CustomParameters.getInputDecorationRegister(
                            context, 'Mobile No', Icon(Icons.keyboard)),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 40,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () async {
                  var connectivity = await Connectivity().checkConnectivity();
                  if (connectivity != ConnectivityResult.mobile &&
                      connectivity != ConnectivityResult.wifi) {}
                  if (displayNamecontoller.text.length < 3) {
                    showAlert(
                        context, "Full Name must not empty", AlertType.error);
                    return;
                  }

                  bool containTitle = false;
                  var titleList = [
                    'MR',
                    'MRS',
                    'DR',
                    'HON',
                    'MISS',
                    'SIR',
                    'MS'
                  ];
                  for (var i = 0; i < titleList.length; i++) {
                    if (displayNamecontoller.text
                        .trim()
                        .toUpperCase()
                        .contains(titleList[i])) {
                      containTitle = true;
                    }
                  }

                  if (!containTitle) {
                    showAlert(
                        context,
                        "Full Name must start with either one of these (Mr, Mrs, Dr, Hon ,Miss,Sir,Ms)",
                        AlertType.error);
                    return;
                  }
                  if (phonecontoller.text.length != 10) {
                    showAlert(context, "Phone number must be 10 characters",
                        AlertType.error);
                    return;
                  } else {
                    var driverRef = FirebaseDatabase.instance
                        .reference()
                        .child('customersTemp')
                        .orderByChild("phoneNumber")
                        .equalTo(phonecontoller.text.trim());
                    driverRef.once().then((DataSnapshot snapshot) {
                      print("snapshot=> ${snapshot.value}");
                      if (snapshot.value != null) {
                        showAlert(
                            context,
                            "Customer with same phone number exists in our system.",
                            AlertType.error);
                        return;
                      } else {
                        registerUser();
                      }
                    });
                  }
                },
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of('ADD CUSTOMER'),
                      style: Theme.of(context).textTheme.button!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ConstanceData.secoundryFontColor,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom + 16,
            )
          ],
        ),
      ),
    );
  }

  void registerUser() async {
    var email = emailGenarator();
    var password = getRandomString(10);

    BuildContext dialogContext = context;
    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       dialogContext = context;
    //       return ProgressDialog(
    //         status: 'Creating customer.....',
    //       );
    //     });
    try {
      String _generatedPassword =
          CommonService.generatePassword(true, true, true, false, 17);
      print('temp password" $_generatedPassword');

      var serial = await SerialService.getSerial(SetialTypes.tempCustomer);
      print('serial" $serial');

      var newuser =
          FirebaseDatabase.instance.reference().child('customersTemp/').push();

      Map usermap = {
        'key': newuser.key,
        'Id': serial,
        'fullName': displayNamecontoller.text,
        'nicName': nickNamecontoller.text,
        'email': email,
        'phoneNumber': phonecontoller.text,
        'pass': _generatedPassword,
        'datetime': DateTime.now().toString(),
        'driverID': CustomParameters.currentFirebaseUser.uid,
        'isSystemOwned': false,
        'rating': 5,
      };
      await newuser.set(usermap);
      displayNamecontoller.text = "";
      phonecontoller.text = "";
      nickNamecontoller.text = "";

      //Navigator.pop(dialogContext);
      showAlert(
          context,
          "${displayNamecontoller.text} was added to the system.",
          AlertType.info);
    } on FirebaseAuthException catch (e) {
      //Navigator.pop(context);
      if (e.code == 'weak-password') {
        // showSnackBar('Oops! The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // showSnackBar('Oops! The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      //Navigator.pop(context);
      print(e);
      // showSnackBar('Oops! There is a problem! Try again later.');
    }
    //Navigator.pop(dialogContext12);
  }

  String emailGenarator() {
    String email = "";
    Random rand = Random();
    return "User${rand.nextInt(1000000)}@gmail.com";
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<UserCredential> register(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      userCredentialx = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {}
    await app.delete();
    return Future.sync(() => userCredentialx);
  }

  ///Show alerts /*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*/
  showAlert(context, message, AlertType alertType) {
    Alert(
      context: context,
      type: alertType,
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
}
