import 'package:budget/poker/ripple_animation.dart';
import 'package:flutter/material.dart';

class CardsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scrum poker")),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children:
                    List.generate(12, (index) => cardItem(context, index)),
              ),
            ),
            ConnectButtonWidget()
          ],
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

class ConnectButtonWidget extends StatefulWidget {
  @override
  _ConnectButtonWidgetState createState() => _ConnectButtonWidgetState();
}

class _ConnectButtonWidgetState extends State<ConnectButtonWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final room = controller.value.text;
    if (room == null || room.isEmpty) {
      return RaisedButton(
        onPressed: _showDialog,
        child: Text("Connect to room"),
      );
    } else {
      return Center(
          child: Column(
        children: [
          Text("You're connected to $room"),
          RaisedButton(
            onPressed: _showDialog,
            child: Text("Reconect"),
          )
        ],
      ));
    }
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Room name', hintText: 'eg. Android Sprint 3'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('Connect'), onPressed: _connectToRoom)
          ],
        ),
      ),
    );
  }

  _connectToRoom() {
    Navigator.pop(context);
    setState(() {});
  }
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

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
