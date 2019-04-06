import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' show radians;

void main() => runApp(MyApp());

const name = '📱Click-A-Pair';
final rng = math.Random();
int roundMatch;
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
  "🃏",
  "🏁",
  "🇦🇺",
  "💯",
  "🔔",
  "📡",
  "📺",
  "⏰",
  "✏️",
  "💎",
  "🕶",
  "💾",
  "🔔",
  "🔑",
  "💡",
  "🏊‍",
  "🦄",
  "️🎲",
  "🎱",
  "🏠",
  "🏛",
  "🐱",
  "🐧",
  "🐦",
  "🐔",
  "🐞",
  "🦀",
  "📱",
  "🚜",
  "⚓",
  "️🍍",
  "🍏",
  "🍓",
  "🍒",
  "🍭",
  "🥕",
  "🕰",
  "🎻",
  "🎨",
];

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
  List<List<int>> cards;

  Future<String> _loadCards(BuildContext context) async {
    return await DefaultAssetBundle.of(context).loadString('assets/cards.json');
  }

  List<int> _randomCard() {
    return this.cards?.elementAt(rng.nextInt(55))?.map((c) => c)?.toList() ??
        [];
  }

  int roundItem(List<int> a, List<int> b) {
    return a.firstWhere((x) => b.contains(x));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: _loadCards(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final d = List<dynamic>.from(json.decode(snapshot.data));
              cards = d.map((card) {
                final a = List<int>.from(card);
                return a;
              }).toList();

              // TODO: need to make sure random doesn't get 2 identical cards from deck
              final itemsA = _randomCard();
              final itemsB = _randomCard();
              roundMatch = roundItem(itemsA, itemsB);
              print("Match: $roundMatch");

              return Center(
                child: Column(
                  children: <Widget>[
                    GameCard(
                      cardName: "Player 1",
                      items: itemsA,
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    GameCard(
                      cardName: "Player 2",
                      items: itemsB,
                    ),
                  ],
                ),
              );
            } else {
              return Text(name);
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
          cardName: cardName,
          rowItems: items.sublist(0, 3),
        ),
        new CardRow(
          cardName: cardName,
          rowItems: items.sublist(3, 6),
        ),
        new CardRow(
          cardName: cardName,
          rowItems: items.sublist(6, 8),
        ),
      ],
    );
  }
}

class CardRow extends StatelessWidget {
  final String cardName;
  final List<int> rowItems;

  CardRow({Key key, this.cardName, this.rowItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CardItem(
          index: rowItems[0],
          name: cardName,
        ),
        CardItem(
          index: rowItems[1],
          name: cardName,
        ),
        rowItems.length == 3
            ? CardItem(
                index: rowItems[2],
                name: cardName,
              )
            : Text(""),
      ],
    );
  }
}

class CardItem extends StatelessWidget {
  final int index;
  final String name;

  const CardItem({Key key, this.index, this.name}) : super(key: key);

  double _randAngle() {
    return rng.nextInt(360).toDouble();
  }

  double _randomFontSize() {
    return ((rng.nextInt(4) * 7) + 24).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Transform.rotate(
          angle: radians(_randAngle()),
          child: GestureDetector(
            onTap: () {
              if (index == roundMatch) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("$name Wins!"),
                        actions: <Widget>[
                          new FlatButton(
                            child: Text("Next Round!"),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      );
                    });
              }
            },
            child: Text(
              images[index],
              style: TextStyle(fontSize: _randomFontSize()),
            ),
          )),
    );
  }
}
