import 'package:budget/pages/add_expensive_page.dart';
import 'package:budget/pages/main_page.dart';
import 'package:budget/poker/Poker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'network.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BudgetApp());
}

class BudgetApp extends StatefulWidget {
  @override
  _BudgetAppState createState() => _BudgetAppState();
}

class _BudgetAppState extends State<BudgetApp> with WidgetsBindingObserver {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme(headline6: TextStyle(color: Colors.black));

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: Poker())],
      child: MaterialApp(
          title: 'Family Budget',
          theme: ThemeData(
              // scaffoldBackgroundColor: Color(0xFF80979A),
              // primarySwatch: Colors.teal,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: textTheme),
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
                  return BudgetMainPage();
                  // return CardsListPage();
                }

                // Otherwise, show something whilst waiting for initialization to complete
                return CircularProgressIndicator();
              })),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // var resumed = state == AppLifecycleState.resumed;
    // TODO: I'm not ready to handle app state yet.
    // Provider.of<Poker>(context, listen: false)
    //     .connectionChanged(resumed);
  }
}

class AddExpensiveFAB extends StatelessWidget {
  final String category;

  const AddExpensiveFAB({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _goToAddExpenses(context),
      tooltip: 'Add expenses',
      child: Icon(Icons.add),
    );
  }

  void _goToAddExpenses(BuildContext context) {
    // DataManager.instance.import();
    Navigator.push(context,
        CupertinoPageRoute(builder: (c) => AddExpensivePage(category)));
  }
}
