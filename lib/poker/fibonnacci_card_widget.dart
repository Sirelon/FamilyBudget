import 'package:flutter/material.dart';

class FibonacciCardWidget extends StatelessWidget {
  final int number;

  final big;

  FibonacciCardWidget({Key? key, required this.number, this.big}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = fibonacci(number).toString();
    var textStyle = big
        ? Theme.of(context).textTheme.headline2!.apply(color: Colors.white)
        : Theme.of(context).textTheme.headline5!.apply(color: Colors.white);
    return Hero(
      tag: text,
      child: Card(
        color: Color(0x8001AD56),
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

int fibonacci(int n) {
  if (n == 0) return 0;
  if (n == 1) return 1;
  if (n == 2) return 2;
  return fibonacci(n - 2) + fibonacci(n - 1);
}
