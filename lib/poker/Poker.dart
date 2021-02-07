import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class Poker extends ChangeNotifier {
  String _userName;

  CollectionReference _roomCollection;

  var _currentRound = 1;

  int get currentRound => _currentRound;

  Poker() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    Future<String> deviceId;
    if (Platform.isAndroid) {
      deviceId = deviceInfo.androidInfo.then((value) => value.androidId);
    } else {
      deviceId = deviceInfo.iosInfo.then((value) => value.identifierForVendor);
    }
    deviceId.then((value) => _userName = value);
  }

  void connectToRoom(String roomName) {
    _roomCollection = FirebaseFirestore.instance.collection(roomName);
    // _roomCollection.doc(_userName).set({"connect": "on"});
    _roomCollection.doc("info").snapshots().listen((event) {
      print(event.exists);
      if (event.exists) {
        readInfo(event);
      } else {
        prefilInfo();
      }
    });
  }

  String getRoomName() => _roomCollection?.id;

  void connectionChanged(bool conected) {
    if (conected) {
      _roomCollection.doc(_userName).set({"connect": "on"});
    } else {
      _roomCollection.doc(_userName).set({"connect": "off"});
    }
  }

  void prefilInfo() {
    _roomCollection.doc("info").update({"round": 1});
  }

  void readInfo(DocumentSnapshot event) {
    _currentRound = event.data()["round"];
    notifyListeners();
  }
}
