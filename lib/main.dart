import 'package:flutter/material.dart';

void main() => runApp(MyApp());

const name = 'Click-A-Pair';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: name),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            GameCard(cardName: "A"),
            GameCard(cardName: "B"),
          ],
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String cardName;

  const GameCard({Key key, this.cardName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        new CardRow(
          offset: 0,
          cardName: cardName,
        ),
        new CardRow(
          offset: 3,
          cardName: cardName,
        ),
        new CardRow(
          offset: 6,
          cardName: cardName,
        ),
      ],
    );
  }
}

class CardRow extends StatelessWidget {
  final int offset;
  final String cardName;

  const CardRow({Key key, this.offset, this.cardName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int count = offset;
    return Row(
      children: <Widget>[
        getCardItem(count++),
        getCardItem(count++),
        getCardItem(count++),
      ],
    );
  }

  Widget getCardItem(int index) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("$cardName $index"),
      ),
    );
  }
}
