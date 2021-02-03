import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class Poker extends ChangeNotifier {
  String _userName;

  CollectionReference _roomCollection;

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
    _roomCollection.doc(_userName).set({"connect":"on"});
  }

  String getRoomName() => _roomCollection?.id;


}
