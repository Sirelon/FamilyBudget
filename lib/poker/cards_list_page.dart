import 'package:budget/poker/fibonnacci_card_widget.dart';
import 'package:budget/poker/result_page.dart';
import 'package:budget/poker/ripple_animation.dart';
import 'package:budget/ui_utils.dart';
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
            child: Text("Reconnect"),
          )
        ],
      ));
    }
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      child: new SystemPadding(
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
    setState(() {

    });
  }
}
