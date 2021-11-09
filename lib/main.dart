import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_cab_driver/Services/authService.dart';
import 'package:my_cab_driver/auth/legacyLoginScreen.dart';
import 'package:my_cab_driver/constance/constance.dart';
import 'package:my_cab_driver/auth/loginScreen.dart';
import 'package:my_cab_driver/models/CustomParameters.dart';
import 'package:my_cab_driver/setting/settingScreen.dart';
import 'package:my_cab_driver/splashScreen.dart';
import 'appTheme.dart';
import 'auth/signUpScreen.dart';
import 'history/historyScreen.dart';
import 'home/homeScreen.dart';
import 'introduction/LocationScreen.dart';
import 'introduction/introductionScreen.dart';
import 'inviteFriend/inviteFriendScreen.dart';
import 'notification/notificationScree.dart';
import 'package:my_cab_driver/wallet/myWallet.dart';
import 'constance/constance.dart' as constance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) => runApp(new MyApp()));
}

class MyApp extends StatefulWidget {
  static setCustomeTheme(BuildContext context, int index) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setCustomeTheme(index);
  }

  static setCustomeLanguage(BuildContext context, String languageCode) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLanguage(languageCode);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].

   static String  name = 'go2go';

   static FirebaseOptions  firebaseOptions = const FirebaseOptions(
    appId: '1:151650714439:android:d4df71ac0251690d63c262',
    apiKey: 'AIzaSyAZENrJd5IZp7sISusn7UTuHiwx14yRtws',
    messagingSenderId: '297855924061',
    projectId: 'go2go-dev-5534c',
    databaseURL: 'https://go2go-dev-5534c-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(name: name, options: firebaseOptions);

  ///Set theme values
  setCustomeTheme(int index) {
    if (index == 6) {
      setState(() {
        AppTheme.isLightTheme = true;
      });
    } else if (index == 7) {
      setState(() {
        AppTheme.isLightTheme = false;
      });
    } else {
      setState(() {
        constance.colorsIndex = index;
        constance.primaryColorString = ConstanceData().colors[constance.colorsIndex];
        constance.secondaryColorString = constance.primaryColorString;
      });
    }
  }

  String locale = "en";

  setLanguage(String languageCode) {
    setState(() {
      locale = languageCode;
      constance.locale = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    constance.locale = locale;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
      statusBarBrightness: AppTheme.isLightTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: AppTheme.isLightTheme ? Colors.white : Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
    ));
    return FutureBuilder(
      /// Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        /// Check for errors
        if (snapshot.hasError) {
          return new Directionality(
              textDirection: TextDirection.ltr,
              child: loading(context,'Connection error with the servers.Please contact the GO2Go support team')
          );
        }
        /// Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {

          var currentRouteName = handleInitializeEvents();
          print("currentRouteName $currentRouteName");

          return MaterialApp(
            title: 'Go2Go Driver',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(),
            routes: routes,
            initialRoute: currentRouteName,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return new Directionality(
            textDirection: TextDirection.ltr,
            child: loading(context,'Go2Go Driver')
        );
      },
    );
  }

  handleInitializeEvents() {
    ///we need to check if the current FirebaseAuth.instance.currentUser
    /// is on the drivers node. if node we have to direct to register
    var currentFirebaseUser = FirebaseAuth.instance.currentUser;
    var routeName = Routes.LOGIN2;
    print("currentFirebaseUser $currentFirebaseUser");

    if (currentFirebaseUser == null) {
      return routeName;
    } else {
      CustomParameters.currentFirebaseUser = currentFirebaseUser!;
      var hasAssociateDriverAccount =  AuthService()
          .getCheckUidHasDriverAccount(currentFirebaseUser.uid);
    }
    return routeName;
  }


  var routes = <String, WidgetBuilder>{
    Routes.LOGIN2: (BuildContext context) => LegacyLoginScreen(),
    Routes.INTRODUCTION: (BuildContext context) => new IntroductionScreen(),
    Routes.ENABLELOCATION: (BuildContext context) => new EnableLocation(),
    Routes.AUTH: (BuildContext context) => new SignUpScreen(),
    Routes.HOME: (BuildContext context) => new HomeScreen(),
    Routes.HISTORY: (BuildContext context) => new HistoryScreen(),
    Routes.NOTIFICATION: (BuildContext context) => new NotificationScreen(),
    Routes.INVITE: (BuildContext context) => new InviteFriendScreen(),
    Routes.SETTING: (BuildContext context) => new SettingScreen(),
    Routes.WALLET: (BuildContext context) => new MyWallet(),
    Routes.LOGIN: (BuildContext context) => new LoginScreen(),
  };
}

class Routes {
  static const String LOGIN2 = "auth/legacyLoginScreen";
  static const String INTRODUCTION = "/introduction/introductionScreen";
  static const String ENABLELOCATION = "/introduction/LocationScreen";
  static const String AUTH = "/auth/signUpScreen";
  static const String LOGIN = "/auth/loginScreen";
  static const String HOME = "/home/homeScreen";
  static const String HISTORY = "/history/historyScreen";
  static const String NOTIFICATION = "/notification/notificationScree";
  static const String INVITE = "/inviteFriend/inviteFriendScreen";
  static const String SETTING = "/setting/settingScreen";
  static const String WALLET = "/wallet/myWallet";
}

loading(context, testToDisplay){
  return new MediaQuery(
    data: new MediaQueryData(),
    child: Scaffold(
      backgroundColor: Color(0xFFFF6767),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            SizedBox(
              height: 2.1,
            ),
            Container(
              height: 1,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 5,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              testToDisplay,
              style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Color(0xFFFFFFFFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: SizedBox(),
              flex: 2,
            ),
          ],
        ),
      ),
    ),
  );
}