import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_cab_driver/auth/legacyLoginScreen.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/home/homeScreen.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/widgets/buttons_widget.dart';
import 'package:my_cab_driver/widgets/devider_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class DocumentInfo extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<DocumentInfo> {
  var appBarheight = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime selectedDate = DateTime.now();

  final picker = ImagePicker();

  var docCRMV;
  var docDriversLicense;
  var docinsurance;
  var docVehicleLicense;
  var docAccountDetails;
  var _imageFile;

  Future pickImage(String functionType) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    print("fileName : ${pickedFile!.path}");
    //HelperMethods.showProgressDialog(context);
    setState(() {
      if (functionType == "CRMV") {
        ///Need to handle error The getter 'path' was called on null.
        docCRMV = io.File(pickedFile.path);
      } else if (functionType == "DL") {
        docDriversLicense = io.File(pickedFile.path);
      } else if (functionType == "INS") {
        docinsurance = io.File(pickedFile.path);
      } else if (functionType == "VL") {
        docVehicleLicense = io.File(pickedFile.path);
      } else if (functionType == "ACD") {
        docAccountDetails = io.File(pickedFile.path);
      }
      uploadFile(functionType);
    });
  }

  void uploadFile(String functionType) async {
    String fileName = CustomParameters.currentFirebaseUser.uid + ".jpg";
    String ImageFileName = "";
    try {
      if (functionType == "CRMV") {
        _imageFile = docCRMV;
        ImageFileName = "docCRMV.jpg";
      } else if (functionType == "DL") {
        _imageFile = docDriversLicense;
        ImageFileName = "docDriversLicense.jpg";
      } else if (functionType == "INS") {
        _imageFile = docinsurance;
        ImageFileName = "docinsurance.jpg";
      } else if (functionType == "VL") {
        _imageFile = docVehicleLicense;
        ImageFileName = "docVehicleLicense.jpg";
      } else if (functionType == "ACD") {
        _imageFile = docAccountDetails;
        ImageFileName = "docAccountDetails.jpg";
      }

      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('${CustomParameters.userDocumentPath}/${CustomParameters
          .currentFirebaseUser.uid}/$ImageFileName')
          .putFile(_imageFile);
      print(
          "Image Upload Done To ${CustomParameters
              .userDocumentPath}/${CustomParameters.currentFirebaseUser
              .uid}/$ImageFileName");
      print("Getting image from web");
      //Navigator.pop(context);
      //getImage();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("FirebaseException : ${e.code}");
    }
  }

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
        .top - 20;
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
                    // SizedBox(
                    //   height: appBarheight,
                    // ),
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
                                                ' Additional Documents'),
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

                          ///Certificate of Registration of Motor Vehicle **************************************************************************************
                          ///***********************************************************************************************************************************
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Certificate of Registration of Motor Vehicle(මෝටර් වාහනය ලියාපදිංචි කිරීමේ සහතිකය)',
                                  style: GoogleFonts.roboto(
                                      color: Color(0xFFef6c00),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 400,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFf5f5f5),
                                      border:
                                      Border.all(color: Color(0xFF9e9e9e))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        docCRMV != null
                                            ? Image.file(
                                          docCRMV,
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                            : Image.asset(
                                          "assets/images/icons/booking.png",
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Image details',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              BrandDivider(),
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Click the "Browse Image" button to insert image',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      color: Colors.red,
                                                    ),
                                                    TaxiButtonSmall(
                                                      title: "Browse Image",
                                                      color: Color(0xFF424242),
                                                      onPress: () {
                                                        pickImage("CRMV");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///Drivers License   *****************************************************************************************************************
                          ///***********************************************************************************************************************************
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Drivers License(රියැදුරු බලපත්‍රය)',
                                  style: GoogleFonts.roboto(
                                      color: Color(0xFFef6c00),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 400,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFf5f5f5),
                                      border:
                                      Border.all(color: Color(0xFF9e9e9e))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        docDriversLicense != null
                                            ? Image.file(
                                          docDriversLicense,
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                            : Image.asset(
                                          "assets/images/icons/booking.png",
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Image details',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              BrandDivider(),
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Click the "Browse Image" button to insert image',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      color: Colors.red,
                                                    ),
                                                    TaxiButtonSmall(
                                                      title: "Browse Image",
                                                      color: Color(0xFF424242),
                                                      onPress: () {
                                                        pickImage("DL");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///motor insurance policy   *****************************************************************************************************************
                          ///***********************************************************************************************************************************
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Motor Insurance Policy(මෝටර් වාහන රක්ෂණ ඔප්පුව)',
                                  style: GoogleFonts.roboto(
                                      color: Color(0xFFef6c00),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 400,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFf5f5f5),
                                      border:
                                      Border.all(color: Color(0xFF9e9e9e))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        docinsurance != null
                                            ? Image.file(
                                          docinsurance,
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                            : Image.asset(
                                          "assets/images/icons/booking.png",
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Image details',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              BrandDivider(),
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Click the "Browse Image" button to insert image',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      color: Colors.red,
                                                    ),
                                                    TaxiButtonSmall(
                                                      title: "Browse Image",
                                                      color: Color(0xFF424242),
                                                      onPress: () {
                                                        pickImage("INS");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///Vehicle Revenue License   *****************************************************************************************************************
                          ///***********************************************************************************************************************************
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Vehicle Revenue License(වාහන අදායම් බලපත්‍රය)',
                                  style: GoogleFonts.roboto(
                                      color: Color(0xFFef6c00),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 400,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFf5f5f5),
                                      border:
                                      Border.all(color: Color(0xFF9e9e9e))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        docVehicleLicense != null
                                            ? Image.file(
                                          docVehicleLicense,
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                            : Image.asset(
                                          "assets/images/icons/booking.png",
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Image details',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              BrandDivider(),
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Click the "Browse Image" button to insert image',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      color: Colors.red,
                                                    ),
                                                    TaxiButtonSmall(
                                                      title: "Browse Image",
                                                      color: Color(0xFF424242),
                                                      onPress: () {
                                                        pickImage("VL");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          ///Bank Passbook Copy   *****************************************************************************************************************
                          ///***********************************************************************************************************************************
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Bank Passbook Copy(බැංකු පාස් පොත් පිටපත)',
                                  style: GoogleFonts.roboto(
                                      color: Color(0xFFef6c00),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 400,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFf5f5f5),
                                      border:
                                      Border.all(color: Color(0xFF9e9e9e))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        docAccountDetails != null
                                            ? Image.file(
                                          docAccountDetails,
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                            : Image.asset(
                                          "assets/images/icons/booking.png",
                                          width: 100,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Image details',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                              ),
                                              BrandDivider(),
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Click the "Browse Image" button to insert image',
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      color: Colors.red,
                                                    ),
                                                    TaxiButtonSmall(
                                                      title: "Browse Image",
                                                      color: Color(0xFF424242),
                                                      onPress: () {
                                                        pickImage("ACD");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        addDocuments();
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
              )
            ],
          ),
        ),
      ),
    );
  }

  addDocuments() {
    print("docCRMV path ${docCRMV.toString()}");
    if (docCRMV == null) {
      showAlert(context,
          'Please insert Certificate of Registration of Motor Vehicle (කරුණාකර මෝටර් වාහන ලියාපදිංචි කිරීමේ සහතිකය ඇතුළත් කරන්න)');
      return;
    }
    if (docDriversLicense == null) {
      showAlert(context,
          'Please insert Drivers License (කරුණාකර රියදුරු බලපත්‍රය ඇතුළත් කරන්න)');
      return;
    }
    if (docinsurance == null) {
      showAlert(context,
          'Please insert motor insurance policy (කරුණාකර මෝටර් වාහන රක්ෂණ ඔප්පුව ඇතුළත් කරන්න)');
      return;
    }
    if (docVehicleLicense == null) {
      showAlert(context,
          'Please insert Vehicle Revenue License (කරුණාකර වාහන ආදායම් බලපත්‍රය ඇතුළත් කරන්න)');
    }
    if (docAccountDetails == null) {
      showAlert(context,
          'Please insert Bank Passbook Copy (කරුණාකර බැංකු පාස් පොත් පිටපත ඇතුළත් කරන්න)');
      return;
    }

    DatabaseReference dbRef2 = FirebaseDatabase.instance
        .reference()
        .child(
        'drivers/${FirebaseAuth.instance.currentUser!
            .uid}/profile/accountStatus');
    dbRef2.set("Pending");

    DatabaseReference dbRef3 = FirebaseDatabase.instance
        .reference()
        .child(
        'listTree/driverList/${FirebaseAuth.instance.currentUser!
            .uid}/accountStatus');
    dbRef3.set("Pending");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  showAlert(context , message){
    Alert(
      context: context,
      type: AlertType.error,
      title: "Go2Go Messaging",
      desc: message,
      style: AlertStyle(
          descStyle: TextStyle(fontSize: 15),
          titleStyle: TextStyle(color: Color(0xFFEB1465))
      ) ,
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
