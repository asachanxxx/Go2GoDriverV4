import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class AuthService {
  Future<dynamic> getCheckUidHasDriverAccount(String uid) async {
    print("getCheckUidHasDriverAccount uid = $uid");
    var checkRef = await FirebaseDatabase.instance
        .reference()
        .child('drivers/$uid/profile')
        .once();
    if (checkRef.value != null) {
      print('getCheckUidHasDriverAccount  ${checkRef.value}');
      return checkRef.value;
    }
    return false;
  }

  static Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }
}

