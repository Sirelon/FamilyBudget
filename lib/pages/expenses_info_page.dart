import 'package:budget/data.dart';
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
    var expenses = Expenses(120, "rent", DateTime.now(), "Оплата за квартиру",
        ["https://images.unsplash.com/photo-1553524789-59ac0ed1d2d2"]);

    Widget body = ExpensesInfoItem(expenses);

    return Scaffold(
      appBar: AppBar(title: Text("Траты категории $selectedCategory")),
      body: SafeArea(child: body),
    );
  }
}

// ignore: must_be_immutable
class ExpensesInfoItem extends StatelessWidget {
  Expenses expenses;

  ExpensesInfoItem(this.expenses);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
