import 'package:budget/data.dart';
import 'package:budget/main.dart';
import 'package:budget/network.dart';
import 'package:budget/pages/images_fullscreen_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:budget/utils.dart';

class ExpensesInfoPage extends StatefulWidget {
  final String category;

  ExpensesInfoPage(this.category);

  @override
  _ExpensesInfoPageState createState() => _ExpensesInfoPageState();
}

class _ExpensesInfoPageState extends State<ExpensesInfoPage> {
  Future<List<Expenses>> expensesFuture;

  @override
  void initState() {
    final selectedCategory = widget.category;
    final dataManager = DataManager.instance;
    expensesFuture = dataManager
        .getIdByTitle(selectedCategory)
        .then((value) => dataManager.loadExpenses(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    Widget body = FutureBuilder(
        future: expensesFuture,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Text("ERROR ${snapshot.error}");
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            final list = snapshot.data;
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  Expenses item = list.elementAt(index);
                  return ExpensesInfoItem(item);
                });
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return CircularProgressIndicator();
        });

    return Scaffold(
      appBar: AppBar(title: Text("Траты категории $category")),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: body,
      )),
      floatingActionButton: AddExpensiveFAB(category: category),
    );
  }
}

class ExpensesInfoItem extends StatelessWidget {
  final Expenses expenses;

  const ExpensesInfoItem(this.expenses);

  @override
  Widget build(BuildContext context) {
    final image = expenses.images.firstOrNull;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: image != null
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(expenses.total.toString()),
                Text(expenses.description),
                Text(expenses.dateTime.toIso8601String())
              ],
            ),
            image != null
                ? _buildImageWidget(image, context)
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String image, BuildContext context) {
    return InkWell(
      child: Hero(
        tag: image,
        child: CachedNetworkImage(
          imageUrl: image,
          height: 150,
        ),
      ),
      onTap: () => _showFullScreenImages(context, expenses.images),
    );
  }

  _showFullScreenImages(BuildContext context, List<String> images) {
    Navigator.push(context,
        MaterialPageRoute(builder: (c) => ImagesFullScreenPage(images)));
  }
}
