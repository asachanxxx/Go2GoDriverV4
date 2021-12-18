import 'dart:async';
import 'dart:io';
import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_cab_driver/Language/appLocalizations.dart';
import 'package:my_cab_driver/Services/serialService.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/drawer/drawer.dart';
import 'package:my_cab_driver/main.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/models/Customer.dart';
import 'package:my_cab_driver/widgets/devider_widget.dart';
import 'package:my_cab_driver/widgets/wgt_predictiontile.dart';
import 'package:my_cab_driver/widgets/wgt_progressdialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

/*
 * This is an example showing how to record to a Dart Stream.
 * It writes all the recorded data from a Stream to a File, which is completely stupid:
 * if an App wants to record something to a File, it must not use Streams.
 *
 * The real interest of recording to a Stream is for example to feed a
 * Speech-to-Text engine, or for processing the Live data in Dart in real time.
 *
 */
enum SingingCharacter { passenger, delivery }

///
typedef _Fn = void Function();

/// Example app.
class MyCustomers extends StatefulWidget {
  static const String Id = 'soundrecxx';

  @override
  _SimpleRecorderState createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<MyCustomers> {
  SingingCharacter? _character = SingingCharacter.passenger;

  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  late String _mPath;
  bool recordStarted = false;
  bool upandDownStatus = false;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool? isNew = false;
  final ValueNotifier<bool> isNewrecord = ValueNotifier<bool>(false);
  late Future<bool> _future;
  bool isOffline = false;
  bool isUpAndDown = false;
  bool isDelivery = false;

  IconData recorderIcon = Icons.mic;

  @override
  void initState() {
    super.initState();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    print("initState()");
    _mPlayer.openAudioSession().then((value) {
      print("openAudioSession()");
      setState(() {
        _mPlayerIsInited = true;
      });
    });
    openTheRecorder().then((value) {
      print("openTheRecorder()");
      setState(() {
        _mRecorderIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    stopPlayer();
    _mPlayer.closeAudioSession();
    _mPlayer.dispositionStream();

    stopRecorder();
    _mRecorder.closeAudioSession();
    _mRecorder.dispositionStream();
    if (_mPath != null) {
      var outputFile = File(_mPath);
      if (outputFile.existsSync()) {
        outputFile.delete();
      }
    }
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    var tempDir = await getTemporaryDirectory();
    _mPath = '${tempDir.path}/flutter_sound_example.aac';
    var outputFile = File(_mPath);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await _mRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  Future<void> record() async {
    assert(_mRecorderIsInited && _mPlayer.isStopped);
    await _mRecorder.startRecorder(
      toFile: _mPath,
      codec: Codec.aacADTS,
    );
    setState(() {});
  }

  Future<void> stopRecorder() async {
    await _mRecorder.stopRecorder();
    _mplaybackReady = true;
  }

  void play() async {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder.isStopped &&
        _mPlayer.isStopped);
    await _mPlayer.startPlayer(
        fromURI: _mPath,
        codec: Codec.aacADTS,
        whenFinished: () {
          setState(() {});
        });
    setState(() {});
  }

  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
  }

// ----------------------------- UI --------------------------------------------

  _Fn getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      //return null;
    }
    return _mRecorder.isStopped
        ? record
        : () {
      stopRecorder().then((value) => setState(() {}));
    };
  }

  _Fn getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
      //return null;
    }
    return _mPlayer.isStopped
        ? play
        : () {
      stopPlayer().then((value) => setState(() {}));
    };
  }


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

    var futureBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child('customersTemp')
          .orderByChild('driverID')
          .equalTo(CustomParameters.currentFirebaseUser.uid)
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Widget newwidget;
        List<dynamic> list;
        if (snapshot != null) {
          if (snapshot.data != null) {
            if (snapshot.data.snapshot != null) {
              if (snapshot.data.snapshot.value != null) {
                print("point 1");
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    newwidget = returnControlMessage(
                        "Please wait until loading the data (කරුණාකර දත්ත පූරණය වන තෙක් රැඳී සිටින්න)",
                        "",
                        true);
                    break;
                  case ConnectionState.waiting:
                    print("Waiting .........");
                    newwidget = returnControlMessage(
                        "Please wait until loading the data (කරුණාකර දත්ත පූරණය වන තෙක් රැඳී සිටින්න)",
                        "",
                        true);
                    break;
                  default:
                    if (snapshot.hasError)
                      newwidget = returnControlMessage(
                          "Problem when loading saved trip details(ඇතුලත් කරන ලද  චාරිකා ව්ස්තර ලබාගැනීමේ ගැටළුවක් ඇත )",
                          "The customer list cannot be shown at the moment. please try later( චාරිකා ව්ස්තර මේ මොහොතේ පෙන්විය නොහැක. කරුණාකර පසුව උත්සාහ කරන්න)",
                          true);
                    else
                      print("Point 2 Value ${snapshot.data.snapshot.value}");
                    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                    list = map.values.toList();
                    print("Key : ${snapshot.data.snapshot.value}");
                    newwidget = ListView.builder(

                      itemCount: list.length, //snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Customer cus = Customer(
                            phoneNumber: list[index]["phoneNumber"],
                            fullName: list[index]["fullName"],
                            driverID: list[index]["driverID"],
                            Id: list[index]["Id"],
                            CustomerID: list[index]["key"],
                            nicName:list[index]["nicName"] != null? list[index]["nicName"]: ""
                        );

                        print("Customer ID on Customer Tab $cus");
                        return SearchCustomerTile(
                          custommerObj: cus,
                          isPickUpSearch: true,
                          parentContext: context,
                        );
                      },
                  );
                }
              } else {
                print("No Customers .........");
                newwidget = returnControlMessage(
                    'No Trips Found(කිසිඳු චාරිකාවක්  හමු නොවීය)',
                    'Please Use plus signed button to add your trip(ඔබේ චාරිකාව ඇතුලත් කිරීමට කරුණාකර පහත බොත්තම භාවිතා කරන්න)',
                    false);
              }
            } else {
              print("No Customers .........");
              newwidget = returnControlMessage(
                  'No Trips Found(කිසිඳු චාරිකාවක් හමු නොවීය)',
                  'Please Use plus signed button to add your trip(ඔබේ චාරිකාව ඇතුලත් කිරීමට කරුණාකර පහත බොත්තම භාවිතා කරන්න)',
                  false);
            }
          } else {
            print("No Customers .........");
            newwidget = returnControlMessage(
                'No Trips Found(කිසිඳු චාරිකාවක්  හමු නොවීය)',
                'Please Use plus signed button to add your trip(ඔබේ චාරිකාව ඇතුලත් කිරීමට කරුණාකර පහත බොත්තම භාවිතා කරන්න)',
                false);
          }
        } else {
          print("No Customers .........");
          newwidget = returnControlMessage(
              'No Trips Found(කිසිඳු චාරිකාවක්  හමු නොවීය)',
              'Please Use plus signed button to add your trip(ඔබේ චාරිකාව ඇතුලත් කිරීමට කරුණාකර පහත බොත්තම භාවිතා කරන්න)',
              false);

          // }
        }
        return newwidget;
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      drawer: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.75 < 400 ? MediaQuery
            .of(context)
            .size
            .width * 0.75 : 350,
        child: Drawer(
          child: AppDrawer(
            selectItemName: 'Customers',
          ),
        ),
      ),
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
                padding: const EdgeInsets.only(left: 8.0 , right: 8.0, ),
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
                AppLocalizations.of('My Customers'),
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
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              //offLineMode(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 500,
                      decoration: BoxDecoration(
                        color: Color(0xFFeeeeee),
                                                                                                                                                                                                                       borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1.0, color: Color(0xFFe0e0e0)),
                      ),
                      child: ValueListenableBuilder(
                        //TODO 2nd: listen playerPointsToAdd
                        valueListenable: isNewrecord,
                        builder: (context, value, widget) {
                          //TODO here you can setState or whatever you need
                          return value == true
                              ? returnControlMessage(
                              "Message must contains following",
                              "1.Customer name(Nickname or Full name will be good)\n" +
                                  "2.Must contain Pickup and drop locations \n" +
                                  "3.Must contain Time of Pickup \n" +
                                  "4.You can specify vehicle type ",
                              false)
                              : futureBuilder;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child:Container(
                  height: 40,
                  child:InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () async {
                      Navigator.pushNamed(context, Routes.ADDCUSTOMERS);
                    },
                    child:
                    Container(
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
              ),
            ],
          )
        ],
      ),
    );
  }
  ///Show alerts /*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*/
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

  Widget offLineMode() {
    return Animator<double>(
      duration: Duration(milliseconds: 400),
      cycles: 1,
      builder: (_, animatorState, __) => SizeTransition(
        sizeFactor: animatorState.animation,
        //axis: Axis.horizontal,
        child: Container(
          height: AppBar().preferredSize.height +60,
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(right: 14, left: 14),
            child: Column(
              children: <Widget>[



              ],
            ),
          ),
        ),
      ),
    );
  }

  void insertRequestVoice() async {
    BuildContext dialogContext = context;

    showDialog(
        barrierDismissible: false,
        context: dialogContext,
        builder: (BuildContext context) {
          dialogContext = context;
          return ProgressDialog(
            status: 'Please wait...2', circularProgressIndicatorColor: Theme
              .of(context)
              .primaryColor,
          );
        });
    //status: 'Creating customer.....',
    try {
      print("Driver name :${CustomParameters.currentDriverInfo.fullName}");

      DatabaseReference listUsers = FirebaseDatabase.instance
          .reference()
          .child('listTree/requestListVoice/')
          .push();

      var outputFile = File(_mPath);
      print("Audio File is = ${outputFile.path}");
      uploadFile(outputFile, listUsers.key);
      var serial = await SerialService.getSerial(SetialTypes.voiceRideRequest);

      print(
          '_character ==========> ${_character.toString().substring(
              _character.toString().indexOf('.') + 1)}');

      Map fullMap = {
        'key': listUsers.key,
        'Id': serial,
        'tripMethod': isDelivery?"delivery" : "passenger",
        'requestedDriverId': CustomParameters.currentFirebaseUser.uid,
        'requestedDriver': CustomParameters.currentDriverInfo.fullName,
        'attended': false,
        'completed': false,
        'time': DateTime.now().toString(),
        'upAndDown': isUpAndDown,
        'status': 'Created'
      };
      print('fullMap ==========> ${fullMap}');

      listUsers.set(fullMap);
    } on FirebaseAuthException catch (e) {
      //Navigator.pop(context);
      if (e.code == 'weak-password') {
        showAlert(context,'Oops! The password provided is too weak.');
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showAlert(context, 'Oops! The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      //Navigator.pop(context);
      print(e);
      showAlert(context,'Oops! There is a problem! Try again later.');
    }

    Navigator.pop(dialogContext);
  }

  void uploadFile(File autioFile, String reqId) async {
    String ImageFileName = reqId + ".acc";
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('${CustomParameters.userAudioPath}/$ImageFileName')
          .putFile(autioFile);
      isNew = false;
      isNewrecord.value = false;
      print(
          "Image Upload Done To ${CustomParameters
              .userAudioPath}/$ImageFileName");
      print("Getting image from web");
      //Navigator.pop(context);
      //getImage();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("FirebaseException : ${e.code}");
    }
  }

  // ///Widget for loading indications/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*//*/*/*/*/*/*/*/
  // Widget loadingIndicators(String message) {
  //   return Scaffold(
  //       body: Container(
  //         width: double.infinity,
  //         decoration: BoxDecoration(
  //           color: Theme
  //               .of(context)
  //               .scaffoldBackgroundColor,
  //           borderRadius: BorderRadius.circular(12),
  //           boxShadow: [
  //             new BoxShadow(
  //               color: AppTheme.isLightTheme
  //                   ? Colors.black.withOpacity(0.2)
  //                   : Colors.white.withOpacity(0.2),
  //               blurRadius: 12,
  //             ),
  //           ],
  //         ),
  //
  //         child: Column(
  //           // Vertically center the widget inside the column
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Icon(
  //               Icons.cloud_download_outlined,
  //               color: Theme
  //                   .of(context)
  //                   .primaryColor,
  //               size: 100,
  //             ),
  //             Text(AppLocalizations.of(message),
  //               style: Theme
  //                   .of(context)
  //                   .textTheme
  //                   .subtitle2!
  //                   .copyWith(
  //                 fontWeight: FontWeight.bold,
  //                 color: Theme
  //                     .of(context)
  //                     .primaryColor,
  //               ),
  //             )
  //
  //           ],
  //         ),
  //       ));
  // }
  // void offLineOnline(status) {
  //   if (status) {} else {}
  // }



}
