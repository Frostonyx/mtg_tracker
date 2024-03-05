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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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

  Color _getColorFromManaType(String manaType) {
    switch (manaType) {
      case 'Red':
        return Colors.red;
      case 'Blue':
        return Colors.blue;
      case 'Black':
        return Colors.black;
      case 'Green':
        return Colors.green;
      case 'White':
        return Colors.white;
      case 'Colorless':
        return Colors.grey;
      default:
        return Colors.black; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double halfScreenHeight = screenHeight / 2;
    double quarterScreenHeight = screenHeight / 6;

    return Scaffold(
      appBar: AppBar(
        title: Text('Magic Tracker'),
      ),
      body: Column(
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
              color: const Color.fromARGB(255, 56, 56, 56),
              child: Center(
                child: Text(
                  '$life',
                  style: TextStyle(fontSize: 164),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: const Color.fromARGB(255, 56, 56, 56),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: manaCount.keys.map((color) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => _updateMana(
                                color, false), // Increase when tapped
                            onLongPress: _resetStormAndMana,
                            child: Text(
                              '${manaCount[color] ?? 0}',
                              style: TextStyle(fontSize: 64),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _updateMana(
                                color, true), // Decrease when tapped
                            onLongPress: _resetStormAndMana,
                            child: Icon(Icons.circle,
                                color: _getColorFromManaType(color), size: 64),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                                Container(
                  height: quarterScreenHeight,
                  color: const Color.fromARGB(255, 56, 56, 56),
                  child: GestureDetector(
                    onTap: _updateStormCount,
                    onLongPress: _resetStormAndMana,
                    child: Center(
                      child: Text(
                        'Storm Count: $stormCount',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
