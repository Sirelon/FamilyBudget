import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
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
                return MyHomePage(title: 'Flutter Demo Home Page');
              }

              // Otherwise, show something whilst waiting for initialization to complete
              return CircularProgressIndicator();
            }));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final currentMonth = FirebaseFirestore.instance.collection("january");

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    // import();
    addExpenses(500, "clothes", "Shoes");
  }

  void addExpenses(int total, String category, String description) {
    final data = {
      "date": FieldValue.serverTimestamp(),
      "description": description,
      "price": total,
      "platform": Platform.isAndroid ? "Android" : "IOS"
    };
    currentMonth.doc(category).collection("expenses").doc().set(data);
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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BudgetTable(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class BudgetTable extends StatelessWidget {
  final currentMonth = FirebaseFirestore.instance.collection("january");

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: currentMonth.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                tableCellHeader("Категория"),
                tableCellHeader("Лимит"),
                tableCellHeader("Расстраты"),
                tableCellHeader("Остаток")
              ],
            ),
            for (var item in snapshot.data.docs)
              TableRow(children: [
                tableCell(item.data()['title']),
                tableCell(item.data()['limit'].toString()),
                tableCellClickable(
                    item.data()['expensesTotal'].toString(), item.id),
                balanceCell(item),
              ])
          ],
        );
      },
    );
  }

  Widget balanceCell(QueryDocumentSnapshot item) {
    var limit = item.data()['limit'];
    var expensesTotal = item.data()['expensesTotal'];
    var data = limit - expensesTotal;
    var style = TextStyle(color: data > 0 ? Colors.green : Colors.red);
    return tableCellStyled(data.toString(), style);
  }

  Widget tableCellClickable(String data, String id) {
    return TableCell(
        child: InkWell(
      onTap: () => onRowTap(id),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(data),
      ),
    ));
  }

  Widget tableCell(String data) {
    return tableCellStyled(data, TextStyle(fontWeight: FontWeight.normal));
  }

  Widget tableCellHeader(String data) {
    return tableCellStyled(data, TextStyle(fontWeight: FontWeight.bold));
  }

  Widget tableCellStyled(String data, TextStyle style) {
    return TableCell(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        data,
        style: style,
      ),
    ));
  }

  onRowTap(String id) {}
}
