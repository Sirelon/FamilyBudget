import 'package:budget/poker/cards_list_page.dart';
import 'package:budget/poker/ripple_animation.dart';
import 'package:flutter/material.dart';

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
            child: Center(child: RipplesAnimation()),
          );
    final titleText = toReveal ? "Tap to close" : "Ready. Tap to view.";
    return Scaffold(
      appBar: AppBar(title: Text(titleText)),
      body: SafeArea(
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
      )),
    );
  }
}
