import 'package:budget/data.dart';
import 'package:budget/main.dart';
import 'package:budget/network.dart';
import 'package:budget/pages/images_fullscreen_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budget/utils.dart';

class ExpensesInfoPage extends StatefulWidget {
  final String category;

  ExpensesInfoPage(this.category);

  @override
  _ExpensesInfoPageState createState() => _ExpensesInfoPageState();
}

class _ExpensesInfoPageState extends State<ExpensesInfoPage> {
  late Future<List<Expenses>> expensesFuture;

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
        builder: (context, AsyncSnapshot<List<Expenses>> snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Text("ERROR ${snapshot.error}");
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            var list = snapshot.requireData;
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

    ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      expenses.total.toString(),
                      style: theme.textTheme.headline6,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    expenses.description,
                    style: theme.textTheme.bodyText2,
                  ),
                  Text(
                    expenses.dateTime.toIso8601String(),
                    style: theme.textTheme.caption,
                  )
                ],
              ),
            ),
            image != null
                ? Expanded(
                    child: _buildImageWidget(image, context),
                    flex: 1,
                  )
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
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (c, a1, a2) => ImagesFullScreenPage(images)));
  }
}
