import 'package:budget/poker/cards_list_page.dart';
import 'package:budget/poker/cards_list_page.dart';
import 'package:budget/poker/fibonnacci_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'cards_list_page.dart';

class RoomInfo {
  String name;
  int round;

  RoomInfo(this.name, this.round);

  String get roundDoc => "Round $round";
}

class RoundResult {
  final int round;
  List<UserResultHolder> users = [];

  RoundResult(this.round);

  bool get canReveal => users.every((element) => !element.lock);

  double get result {
    final sum = users
        .map((e) => e.value)
        .fold(0, (previous, current) => previous + current);

    return sum / users.length;
  }
}

class UserResultHolder {
  final String userName;
  final int value;
  final bool lock;

  UserResultHolder(this.userName, this.value, this.lock);
}

class Poker extends ChangeNotifier {
  String _userName;

  CollectionReference _roomCollection;

  RoomInfo _info;

  RoomInfo get currentInfo => _info;

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
      var round = 1;
      if (event.exists) {
        round = event.data()["round"];
      } else {
        prefilInfo();
      }
      _info = RoomInfo(roomName, round);
      notifyListeners();
    });
  }

  void connectionChanged(bool conected) {
    if (conected) {
      _roomCollection.doc(_userName).set({"connect": "on"});
    } else {
      _roomCollection.doc(_userName).set({"connect": "off"});
    }
  }

  void prefilInfo() {
    _roomCollection.doc("info").set({"round": 1});
  }

  void onCardChoosed(int index) {
    final fibNumber = fibonacci(index);
    // _roomCollection.doc("Round $_currentRound").get().then((value) => value.)
    _currentRoundDoc().update({
      _userName: {"number": fibNumber, "lock": true}
    });
  }

  void onCardReveal(int fibonacci) {
    _currentRoundDoc().update({
      _userName: {"number": fibonacci, "lock": false}
    });
  }

  void removeCard() {
    _currentRoundDoc().update({_userName: null});
  }

  DocumentReference _currentRoundDoc() => _roomCollection.doc(_info.roundDoc);

// void unlock() {
//   _roomCollection.doc("Round $_currentRound").update({
//     _userName: {"number": fibNumber, "lock": true}
//   });
// }

}
