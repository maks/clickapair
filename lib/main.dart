import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' show radians;

void main() => runApp(App());
const appName = 'Click-A-Pair';
final rng = math.Random();
const List<String> images = [
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
  "👒",
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

class App extends StatelessWidget {
  App({Key key}) : super(key: key);
  Future<String> _load(BuildContext context) async {
    return await DefaultAssetBundle.of(context).loadString('assets/cards.json');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Object>(
          future: _load(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final d = List<dynamic>.from(json.decode(snapshot.data));
              final cardsData = d.map((card) => List<int>.from(card)).toList();
              return GameBoard(
                cards: cardsData,
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class GameStateProvider extends InheritedWidget {
  final _GameBoardState gameState;
  GameStateProvider({Key key, child, this.gameState})
      : super(key: key, child: child);
  Map<String, int> get score => gameState.score;
  void updateScore(String playerName) {
    gameState.setState(() {
      gameState.score[playerName]++;
    });
  }

  bool isMatchingRoundItem(int index) => index == gameState.roundMatchItem;
  static GameStateProvider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(GameStateProvider)
        as GameStateProvider);
  }

  @override
  bool updateShouldNotify(GameStateProvider oldWidget) => true;
}

class GameBoard extends StatefulWidget {
  final List<List<int>> cards;
  GameBoard({
    Key key,
    this.cards,
  }) : super(key: key);
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  int roundMatchItem;
  final Map<String, int> score = {
    "Player 1": 0,
    "Player 2": 0,
  };
  List<int> _randomCard(int idx) {
    return widget.cards.elementAt(idx).map((c) => c).toList();
  }

  int _roundItem(List<int> a, List<int> b) {
    return a.firstWhere((x) => b.contains(x));
  }

  @override
  Widget build(BuildContext context) {
    final a = rng.nextInt(55);
    int b;
    do {
      b = rng.nextInt(55);
    } while (a == b);
    final itemsA = _randomCard(a);
    final itemsB = _randomCard(b);
    roundMatchItem = _roundItem(itemsA, itemsB);
    return GameStateProvider(
      gameState: this,
      child: Scaffold(
        appBar: AppBar(
          title: Text(appName),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GameCard(
              id: score.keys.first,
              items: itemsA,
            ),
            Divider(
              color: Colors.black,
            ),
            GameCard(
              id: score.keys.last,
              items: itemsB,
            ),
          ],
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String id;
  final List<int> items;
  const GameCard({
    Key key,
    this.id,
    this.items,
  }) : super(key: key);
  _getRow(name, items, start, end) =>
      CardRow(id: name, rowItems: items.sublist(start, end));
  @override
  Widget build(BuildContext context) {
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
                    _getRow(id, items, 0, 3),
                    _getRow(id, items, 3, 6),
                    _getRow(id, items, 6, 8),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment(1, 1),
            child: CardScore(name: id),
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
        "${this.name}:\n${GameStateProvider.of(context).score[name]}",
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }
}

class CardRow extends StatelessWidget {
  final String id;
  final List<int> rowItems;
  CardRow({Key key, this.id, this.rowItems}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CardItem(
            index: rowItems[0],
            name: id,
          ),
          CardItem(
            index: rowItems[1],
            name: id,
          ),
          rowItems.length == 3
              ? CardItem(
                  index: rowItems[2],
                  name: id,
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
          if (GameStateProvider.of(context).isMatchingRoundItem(index)) {
            GameStateProvider.of(context).updateScore(this.name);
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
          style: TextStyle(
            fontSize: _randomFontSize(),
          ),
        ),
      ),
    );
  }
}
