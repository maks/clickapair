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
  List<List<int>> cardDeck;

  Future<String> loadCards(BuildContext context) async {
    return await DefaultAssetBundle.of(context).loadString('assets/cards.json');
  }

  List<int> randomCard() {
    return this.cardDeck?.elementAt(rng.nextInt(55))?.map((c) => c)?.toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: loadCards(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final data = json.decode(snapshot.data);

              final d = List<dynamic>.from(data);
              cardDeck = d.map((card) {
                final a = List<int>.from(card);
                return a;
              }).toList();

              // TODO: need to make sure random doesn't get 2 identical cards from deck
              return Center(
                child: Column(
                  children: <Widget>[
                    GameCard(
                      cardName: "A",
                      items: randomCard(),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    GameCard(
                      cardName: "B",
                      items: randomCard(),
                    ),
                  ],
                ),
              );
            } else {
              return Text("Loading...");
            }
          }),
    );
  }
}

class GameCard extends StatelessWidget {
  final String cardName;
  final List<int> items;

  const GameCard({
    Key key,
    this.cardName,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Card $cardName : $items");

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
