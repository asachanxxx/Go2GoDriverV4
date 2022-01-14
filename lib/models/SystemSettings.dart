import 'package:flutter/material.dart';

class SystemSettings extends ChangeNotifier {
  String address = "";
  String appName = "";
  String city = "";
  String commissionCutMode = "";
  String companyName = "";
  String country = "";
  int currency = 0;
  String imagePath = "";
  int ODR = 0;
  int SCR = 0;
  bool fireBaseLogEnable = false;
  int minimumKM = 4;
  bool useIdToLogin = false;

  SystemSettings.fromDb(Map<dynamic, dynamic> map) {
    var data = map.values.toList().last;
    address = data['address'];
    appName = data['appName'];
    city = data['city'];
    commissionCutMode = data['commissionCutMode'];
    companyName = data['companyName'];
    country = data['country'];
    currency = data['currency'];
    imagePath = data['imagePath'];
    ODR = data['ODR'];
    SCR = data['SCR'];
    fireBaseLogEnable = data['fireBaseLogEnable'];
    minimumKM = data['minimumKM'];
    useIdToLogin = data['useIdToLogin'];
  }
}
