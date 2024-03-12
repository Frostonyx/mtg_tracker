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
  //DEPRECIATED:

  //Color _getColorFromManaType(String manaType) {
  //  switch (manaType) {
  //    case 'Red':
  //      return Colors.red;
  //    case 'Blue':
  //      return Colors.blue;
  //    case 'Black':
  //      return Colors.black;
  //    case 'Green':
  //      return Color.fromARGB(255, 55, 179, 61);
  //    case 'White':
  //      return Colors.white;
  //    case 'Colorless':
  //      return const Color.fromARGB(255, 204, 204, 204);
  //    default:
  //      return Colors.black; // Default color
  //  }
  //}

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
              decoration: BoxDecoration(
                color: Colors.blue,
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
        color: const Color.fromARGB(255, 138, 137, 137),
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
                color: Color.fromARGB(255, 138, 137, 137),
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
            color: const Color.fromARGB(255, 138, 137, 137),
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
        color: const Color.fromARGB(255, 138, 137, 137),
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
