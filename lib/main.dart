import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MagicTrackerApp());
}

class MagicTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Tracker',
      theme: ThemeData.dark(),
      home: MagicTrackerScreen(),
    );
  }
}

class MagicTrackerScreen extends StatefulWidget {
  @override
  _MagicTrackerScreenState createState() => _MagicTrackerScreenState();
}

class _MagicTrackerScreenState extends State<MagicTrackerScreen> {
  int life = 20;
  int stormCount = 0;

  Map<String, bool> manaVisibility = {
    'Red': true,
    'Blue': true,
    'Black': true,
    'Green': true,
    'White': true,
    'Colorless': true,
  };

  Map<String, int> manaCount = {
    'Red': 0,
    'Blue': 0,
    'Black': 0,
    'Green': 0,
    'White': 0,
    'Colorless': 0,
  };

  void _updateLife(bool increase) {
    setState(() {
      increase ? life++ : life--;
    });
  }

  void _resetStormAndMana() {
    setState(() {
      stormCount = 0;
      manaCount = {
        'Red': 0,
        'Blue': 0,
        'Black': 0,
        'Green': 0,
        'White': 0,
        'Colorless': 0,
      };
    });
  }

  void _resetLife() {
    setState(() {
      life = 20;
    });
  }

  void _updateStormCount() {
    setState(() {
      stormCount++;
    });
  }

  void _updateMana(String color, bool increase) {
    setState(() {
      increase
          ? manaCount[color] = (manaCount[color] ?? 0) + 1
          : manaCount[color] = (manaCount[color] ?? 0) - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double halfScreenHeight = screenHeight / 2;
    double quarterScreenHeight = screenHeight / 7;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('MtG Tracker'),
      ),
       drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Mana Counters',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            for (var manaType in manaVisibility.keys)
              CheckboxListTile(
                title: Text(manaType),
                value: manaVisibility[manaType],
                onChanged: (value) {
                  setState(() {
                    manaVisibility[manaType] = value!;
                  });
                },
              ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            GestureDetector(
              onTapUp: (details) {
                if (details.localPosition.dx <
                    MediaQuery.of(context).size.width / 2) {
                  _updateLife(false); // Decrease if tapped on left half
                } else {
                  _updateLife(true); // Increase if tapped on right half
                }
              },
              onLongPress: _resetLife,
              child: Container(
                height: halfScreenHeight,
                child: Center(
                  child: Text(
                    '$life',
                    style: const TextStyle(fontSize: 300, fontFamily: 'HUGEBRUSH'),
                  ),
                ),
              ),
            ),
          
                Expanded(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Expanded(
        child: Center(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: manaCount.keys.where((color) => manaVisibility[color]!).map((color) {

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _updateMana(color, false),
                        onLongPress: _resetStormAndMana,
                        child: Text(
                          '${manaCount[color] ?? 0}',
                          style: TextStyle(fontSize: 64),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _updateMana(color, true),
                        onLongPress: _resetStormAndMana,
                        child: Image.asset('assets/images/$color.png',
                             height: 64, width: 64),
                      ),
                    ],
                  );
              }).toList(),
            ),
          ),
        ),
      ),
      Container(
        height: quarterScreenHeight,
        child: GestureDetector(
          onTap: _updateStormCount,
          onLongPress: _resetStormAndMana,
          child: Center(
            child: Text(
              'Storm Count: $stormCount',
              style: TextStyle(fontSize: 36),
            ),
          ),
        ),
      ),
    ],
  ),
),

          ],
        ),
      ),
    );
  }
}
