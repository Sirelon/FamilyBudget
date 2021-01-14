import 'package:flutter/material.dart';

class CardsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scrum poker")),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(12, (index) => cardItem(context, index)),
        ),
      )),
    );
  }

  Widget cardItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (c, a1, a2) => CardFullPage(number: index)));
      },
      child: FibonacciCardWidget(
        number: index,
        big: false,
      ),
    );
  }
}

int fibonacci(int n) {
  if (n == 0) return 0;
  if (n == 1) return 1;
  if (n == 2) return 2;
  return fibonacci(n - 2) + fibonacci(n - 1);
}

class FibonacciCardWidget extends StatelessWidget {
  final int number;

  final big;

  FibonacciCardWidget({Key key, this.number, this.big}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = fibonacci(number).toString();
    var textStyle = big
        ? Theme.of(context).textTheme.headline2.apply(color: Colors.white)
        : Theme.of(context).textTheme.headline5.apply(color: Colors.white);
    return Hero(
      tag: text,
      child: Card(
        color: Colors.blueGrey,
        child: Center(
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

class CardFullPage extends StatefulWidget {
  final int number;

  const CardFullPage({Key key, this.number}) : super(key: key);

  @override
  _CardFullPageState createState() => _CardFullPageState();
}

class _CardFullPageState extends State<CardFullPage> {
  // 0 - hide
  // 1 - reveal
  var toReveal = false;

  @override
  Widget build(BuildContext context) {
    final body = toReveal
        ? FibonacciCardWidget(
            number: widget.number,
            big: true,
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.deepOrangeAccent,
            child: Center(
                child: Text("Tap to reveal",
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .apply(color: Colors.white))),
          );
    final titleText = toReveal ? "Tap to close" : "Ready. Tap to view.";
    return Scaffold(
      appBar: AppBar(title: Text(titleText)),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          child: body,
          onTap: () {
            if (toReveal) {
              Navigator.pop(context);
            } else {
              setState(() {
                toReveal = true;
              });
            }
          },
        ),
      )),
    );
  }
}
