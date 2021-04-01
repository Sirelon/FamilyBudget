import 'package:budget/poker/fibonnacci_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class RoomInfo {
  String name;
  int round;

  RoomInfo(this.name, this.round);

  String get roundDoc => "Round $round";
}

class RoundResult {
  final int round;
  final List<UserResultHolder> users;

  RoundResult(this.round, this.users);

  bool get canReveal => users.every((element) => !element.lock);

  double get result {
    final sum = users
        .map((e) => e.value)
        .fold(0, (int previous, current) => previous + current);

    print(sum);

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
  late String _userName;

  late CollectionReference _roomCollection;

  late RoomInfo _info;

  RoomInfo get currentInfo => _info;

  late RoundResult _roundResult;

  RoundResult get roundResult => _roundResult;

  Poker() {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    Future<String> deviceId;
    if (Platform.isAndroid) {
      // TODO:
      // deviceId = deviceInfo.androidInfo.then((value) => value.androidId);
      deviceId = deviceInfo.androidInfo.then((value) => value.model);
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
        round = event.data()!["round"];
      } else {
        prefilInfo();
      }
      _info = RoomInfo(roomName, round);

      connectToRound();

      notifyListeners();
    });
  }

  void connectToRound() {
    _currentRoundDoc().snapshots().listen((event) {
      final data = event.data();

      if (data == null) return;

      final users =
          data.entries.where((element) => element.value != null).map((e) {
        final userData = e.value;
        return UserResultHolder(e.key, userData["number"], userData["lock"]);
      }).toList();

      _roundResult = RoundResult(_info.round, users);
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
    _currentRoundDoc().set({
      _userName: {"number": fibNumber, "lock": true}
    }, SetOptions(merge: true));
  }

  void onCardReveal(int index) {
    final fibNumber = fibonacci(index);
    _currentRoundDoc().update({
      _userName: {"number": fibNumber, "lock": false}
    });
  }

  void removeCard() {
    _currentRoundDoc().update({_userName: null});
  }

  DocumentReference _currentRoundDoc() => _roomCollection.doc(_info.roundDoc);

  void goToNextRound(int round) {
    _roomCollection.doc("info").update({"round": round + 1});
  }

// void unlock() {
//   _roomCollection.doc("Round $_currentRound").update({
//     _userName: {"number": fibNumber, "lock": true}
//   });
// }

}
