import 'dart:io' show File, Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class DataManager {
  static final DataManager _singleton = DataManager._internal();

  static DataManager get instance => _singleton;

  factory DataManager() {
    return _singleton;
  }

  DataManager._internal();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentMonth = FirebaseFirestore.instance.collection("january");

  Future<String> saveImage(File image) async {
    var path = currentMonth.id + "/" + basename(image.path);
    await FirebaseStorage.instance.ref(path).putFile(image);

    return FirebaseStorage.instance.ref(path).getDownloadURL();
  }

  Future<void> addExpenses(int total, String category, DateTime dateTime,
      String description, List<String> images) async {
    final data = {
      "date": dateTime,
      "description": description,
      "price": total,
      "images": images,
      "platform": Platform.isAndroid ? "Android" : "IOS"
    };
    final currentCategory = currentMonth.doc(category);
    currentCategory.collection("expenses").doc().set(data);
    final currentDoc = await currentCategory.get();
    final expensiveTotal = currentDoc.data()['expensesTotal'] + total;
    currentCategory.update({'expensesTotal': expensiveTotal});
  }

  void import() async {
    var data = await firestore.collection("preset").get();
    data.docs.forEach((element) {
      var data = element.data();
      data.putIfAbsent("expensesTotal", () => 0);
      var doc = currentMonth.doc(element.id);
      doc.collection("expenses");
      doc.set(data);
    });
  }

  Future<List<String>> getCategories() {
    return currentMonth.get().then((value) =>
        value.docs.map((e) => e.data()["title"].toString()).toList());
  }

  Future<String> getIdByTitle(String title) {
    return currentMonth
        .get()
        .then((value) => value.docs
            .firstWhere((element) => element.data()['title'] == title))
        .then((value) => value.id);
  }
}
