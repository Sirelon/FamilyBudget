import 'package:budget/network.dart';
import 'package:flutter/material.dart';

class AddExpensivePage extends StatefulWidget {
  final String category;

  AddExpensivePage(this.category);

  @override
  _AddExpensivePageState createState() => _AddExpensivePageState();
}

class _AddExpensivePageState extends State<AddExpensivePage> {
  String selectedCategory;

  List<String> categories = [];

  @override
  void initState() {
    selectedCategory = widget.category;
    DataManager.instance.getCategories().then((value) => setState(() {
          categories = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (categories == null) {
      widget = Spacer();
    } else {
      widget = DropdownButton<String>(
        value: selectedCategory,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.green),
        underline: Container(
          height: 2,
          color: Colors.greenAccent,
        ),
        onChanged: (String newValue) {
          setState(() {
            selectedCategory = newValue;
          });
        },
        items: categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }

    return Scaffold(
        appBar: AppBar(title: const Text("Add expensive")),
        body: Center(
          child: widget,
        ));
  }
}
