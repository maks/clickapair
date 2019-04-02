import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' show radians;

void main() => runApp(MyApp());

const name = 'Click-A-Pair';

final rng = math.Random();

const images = [
  "❤️️",
  "🙂",
  "🌻",
  "🏝",
  "⚡️",
  "☘",
  "☀️",
  "🌏",
  "🚀",
  "🚲",
  "🚢",
  "🚦",
  "🚗",
  "🐧",
  "🏀️",
  "⚽️",
  "🏆",
  "🏎",
  "🥇",
  "🏁",
  "🇦🇺",
  "💯",
  "🔔",
  "📡",
  "📺",
  "⏰",
  "🧦",
  "💎",
  "🕶",
  "💾",
  "🔔",
  "🔑",
  "💡",
  "🏊‍",
  "♀",
  "️🎲",
  "🎱",
  "🏠",
  "🏛",
  "🐱",
  "🐧",
  "🐦",
  "🦕",
  "🦆",
  "🦀",
  "🛷",
  "🚜",
  "⚓",
  "️🥝",
  "🍏",
  "🍓",
  "🍒",
  "🍭",
  "🥕",
  "🕰",
  "🎻",
  "🎨",
];

var cards;

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
  loadCards(BuildContext context) async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/cards.json");
    final jsonResult = json.decode(data);

    cards = jsonResult;
    print("loaded cards");
    print("Card 0: ${jsonResult[3][4]}");
  }

  @override
  Widget build(BuildContext context) {
    loadCards(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            GameCard(cardName: "A"),
            Divider(
              color: Colors.black,
            ),
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

  List<int> randomCard() {
    return cards[rng.nextInt(55)].map((c) => (c as int)).toList();
  }

  @override
  Widget build(BuildContext context) {
    print("Card:"); // ${randomCard()}");

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

  CardRow({Key key, this.offset, this.cardName}) : super(key: key);

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
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Transform.rotate(
          angle: radians(randAngle()),
          child: Text(
            randImage(),
            style: TextStyle(fontSize: randomFontSize()),
          )),
    );
  }

  double randAngle() {
    return rng.nextInt(360).toDouble();
  }

  String randImage() {
    return images[rng.nextInt(images.length)];
  }

  double randomFontSize() {
    return ((rng.nextInt(4) + 2) * 6).toDouble();
  }
}
