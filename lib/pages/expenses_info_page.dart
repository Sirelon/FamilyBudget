import 'package:budget/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpensesInfoPage extends StatefulWidget {
  final String category;

  ExpensesInfoPage(this.category);

  @override
  _ExpensesInfoPageState createState() => _ExpensesInfoPageState();
}

class _ExpensesInfoPageState extends State<ExpensesInfoPage> {
  String selectedCategory;

  @override
  void initState() {
    selectedCategory = widget.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO:
    var expenses = Expenses(12000, "rent", DateTime.now(), "Оплата за квартиру",
        ["https://images.unsplash.com/photo-1553524789-59ac0ed1d2d2"]);

    final list = List.generate(10, (i) => expenses);

    Widget body = ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          Expenses item = list.elementAt(index);
          return ExpensesInfoItem(item);
        });

    return Scaffold(
      appBar: AppBar(title: Text("Траты категории $selectedCategory")),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: body,
      )),
    );
  }
}

// ignore: must_be_immutable
class ExpensesInfoItem extends StatelessWidget {
  Expenses expenses;

  ExpensesInfoItem(this.expenses);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(expenses.total.toString()),
              Text(expenses.description),
              Text(expenses.dateTime.toIso8601String())
            ],
          ),
          SizedBox(
            child: Image.network(
              expenses.images.first,
            ),
            width: 100,
            height: 100,
          )
        ],
      ),
    );
  }
}
