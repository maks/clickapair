import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' show radians;

void main() => runApp(App());

const name = '📱Click-A-Pair';
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
  "🎁",
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
  "🌶",
  "🕰",
  "🎻",
  "🎨",
];

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Map<String, int> gameScore = {
    "Player 1": 0,
    "Player 2": 0,
  };

  void updateScore(String playerName) {
    setState(() {
      gameScore[playerName]++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GameState(
        child: MyHomePage(title: name),
        score: gameScore,
        appState: this,
      ),
    );
  }
}

class GameState extends InheritedWidget {
  final List<List<int>> cards = List();
  final List<int> roundMatch = List(1);
  final Map<String, int> score;
  final _AppState appState;

  GameState({Key key, child, this.score, this.appState})
      : super(key: key, child: child);

  static GameState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GameState) as GameState);
  }

  @override
  bool updateShouldNotify(GameState oldWidget) => true;
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  Future<String> _loadCards(BuildContext context) async {
    print("loading card data");
    return await DefaultAssetBundle.of(context).loadString('assets/cards.json');
  }

  List<int> _randomCard(BuildContext context) {
    return GameState.of(context)
            .cards
            .elementAt(rng.nextInt(55))
            ?.map((c) => c)
            ?.toList() ??
        [];
  }

  int roundItem(List<int> a, List<int> b) {
    return a.firstWhere((x) => b.contains(x));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
          future: _loadCards(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final d = List<dynamic>.from(json.decode(snapshot.data));
              GameState.of(context).cards.clear();
              d.forEach((card) {
                final a = List<int>.from(card);
                GameState.of(context).cards.add(a);
              });

              // TODO: need to make sure random doesn't get 2 identical cards from deck
              final itemsA = _randomCard(context);
              final itemsB = _randomCard(context);
              GameState.of(context).roundMatch[0] = roundItem(itemsA, itemsB);
              print("Match: ${GameState.of(context).roundMatch[0]}");

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GameCard(
                    cardName: GameState.of(context).score.keys.first,
                    items: itemsA,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  GameCard(
                    cardName: GameState.of(context).score.keys.last,
                    items: itemsB,
                  ),
                ],
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

    return Expanded(
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CardRow(
                      cardName: cardName,
                      rowItems: items.sublist(0, 3),
                    ),
                    CardRow(
                      cardName: cardName,
                      rowItems: items.sublist(3, 6),
                    ),
                    CardRow(
                      cardName: cardName,
                      rowItems: items.sublist(6, 8),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment(1, 1),
            child: CardScore(name: cardName),
          )
        ],
      ),
    );
  }
}

class CardScore extends StatelessWidget {
  final String name;

  CardScore({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        "${this.name}:\n ${GameState.of(context).score[name]}",
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class CardRow extends StatelessWidget {
  final String cardName;
  final List<int> rowItems;

  CardRow({Key key, this.cardName, this.rowItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      ),
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
    return ((rng.nextInt(4) * 9) + 22).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
        angle: radians(_randAngle()),
        child: GestureDetector(
          onTap: () {
            if (index == GameState.of(context).roundMatch[0]) {
              //GameState.of(context).score[name]++;
              GameState.of(context).appState.updateScore(this.name);
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
        ));
  }
}
