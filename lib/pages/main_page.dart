import 'package:budget/network.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BudgetMainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Family Budget app"),
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

  void _incrementCounter() {
    // import();
    DataManager.instance.addExpenses(500, "clothes", "Shoes");
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
              ]),
            totalRow(snapshot)
          ],
        );
      },
    );
  }

  TableRow totalRow(AsyncSnapshot<QuerySnapshot> snapshot) {
    var limit = 0;
    var expensesTotal = 0;
    for (var item in snapshot.data.docs) {
      limit += item.data()['limit'];
      expensesTotal += item.data()['expensesTotal'];
    }

    final limitTotal = limit - expensesTotal;
    var limitStyle = TextStyle(
        color: limitTotal > 0 ? Colors.green : Colors.red,
        fontWeight: FontWeight.w900);

    return TableRow(children: [
      tableCellHeader("Итого"),
      tableCellHeader(limit.toString()),
      tableCellHeader(expensesTotal.toString()),
      tableCellStyled(limitTotal.toString(), limitStyle),
    ]);
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
