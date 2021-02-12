import 'package:budget/poker/ripple_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Poker.dart';
import 'fibonnacci_card_widget.dart';

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
        ? Column(
            children: [
              Expanded(
                child: FibonacciCardWidget(
                  number: widget.number,
                  big: true,
                ),
              ),
              RoundResultsWidget()
            ],
          )
        : WaitForResultWidget();
    final titleText = toReveal ? "Tap to close" : "Ready. Tap to view.";
    return Scaffold(
      appBar: AppBar(title: Text(titleText)),
      body: SafeArea(
          child: InkWell(
        child: body,
        onTap: () {
          var poker = Provider.of<Poker>(context, listen: false);
          if (toReveal) {
            poker.goToNextRound(poker.currentInfo.round);
            Navigator.pop(context);
          } else {
            poker.onCardReveal(widget.number);

            setState(() {
              toReveal = true;
            });
          }
        },
      )),
    );
  }
}

class WaitForResultWidget extends StatelessWidget {
  const WaitForResultWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.teal,
      child: Center(
          child: Column(
        children: [
          RipplesAnimation(child: Container()),
          RoundResultsWidget(),
        ],
      )),
    );
  }
}

class RoundResultsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Poker>(builder: (context, poker, child) {
      final data = poker.roundResult;
      if (data == null) return Container();
      final usersInfo = data.users.map((e) => _userInfo(data.canReveal, e));

      var title = "Wait for all";
      if (data.canReveal) {
        title = "RESULT IS ${data.result}";
      }
      return Column(
          children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white)),
        ...usersInfo,
      ]);
    });
  }

  Widget _userInfo(bool canReveal, UserResultHolder user) {
    var valueTxt = user.value.toString();
    if (!canReveal) {
      valueTxt = "Ready";
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        Text(
          user.userName,
          style: TextStyle(color: Colors.deepPurple, fontSize: 18),
        ),
        SizedBox(width: 16),
        Text(valueTxt,
            style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 18))
      ]),
    );
  }
}
