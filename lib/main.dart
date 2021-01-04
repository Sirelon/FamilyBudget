import 'package:budget/pages/add_expensive_page.dart';
import 'package:budget/pages/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BudgetApp());
}

class BudgetApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Family Budget',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
            // Initialize FlutterFire:
            future: _initialization,
            builder: (context, snapshot) {
              // Check for errors
              if (snapshot.hasError) {
                return Text("ERROR ${snapshot.error}");
              }

              // Once complete, show your application
              if (snapshot.connectionState == ConnectionState.done) {
                // return BudgetMainPage();
                return AddExpensivePage(null);
              }

              // Otherwise, show something whilst waiting for initialization to complete
              return CircularProgressIndicator();
            }));
  }
}
