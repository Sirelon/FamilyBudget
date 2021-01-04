import 'package:budget/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddExpensivePage extends StatefulWidget {
  final String category;

  AddExpensivePage(this.category);

  @override
  _AddExpensivePageState createState() => _AddExpensivePageState();
}

class _AddExpensivePageState extends State<AddExpensivePage> {
  String selectedCategory;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<String> categories;

  final descriptionController = TextEditingController();
  final costController = TextEditingController();
  bool _costNotValid = false;
  FocusNode _costFocus;

  @override
  void dispose() {
    _costFocus.dispose();
    costController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _costFocus = FocusNode();
    DataManager.instance.getCategories().then((value) {
      print(value);
      setState(() {
        selectedCategory = widget.category;
        // if (value.contains(selectedCategory)) {
        categories = value;
        // }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (categories == null) {
      widget = Text("Loading...");
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
        key: _scaffoldKey,
        appBar: AppBar(title: const Text("Добавление трат")),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              widget,
              TextField(
                focusNode: _costFocus,
                controller: costController,
                decoration: InputDecoration(
                  labelText: "Сколько стоит? :)",
                  errorText:
                      _costNotValid ? 'Нужно обязательно указать цену' : null,
                ),
                keyboardType: TextInputType.number,
                maxLength: 7,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.singleLineFormatter
                ],
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Для нотаток"),
                keyboardType: TextInputType.multiline,
                maxLines: 12,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(child: Text("Охрана, отмена"), onPressed: cancel),
                  RaisedButton(child: Text("Сохранить"), onPressed: saveExpanse)
                ],
              )
            ],
          ),
        )));
  }

  void saveExpanse() {
    if (selectedCategory == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Выбери категорию для начала."),
        duration: Duration(seconds: 1),
      ));
      return;
    }

    final total = costController.text;
    if (total.isEmpty) {
      setState(() {
        _costFocus.requestFocus();
        _costNotValid = true;
      });
      return;
    }
  }

  void cancel() {
    Navigator.pop(context);
  }
}
