import 'package:flutter/material.dart';
import 'package:studdybuddy1/screens/dashboard.dart';

class MiniGamesScreen extends StatefulWidget {
  const MiniGamesScreen({super.key});

  @override
  State<MiniGamesScreen> createState() => _MiniGamesScreenState();
}

class _MiniGamesScreenState extends State<MiniGamesScreen> {
  final List<List<String>> solution = [
    ['A', 'P', 'P', 'L', 'E'],
    ['', '', '', 'R', ''],
    ['G', 'R', 'A', 'P', 'E'],
    ['B', '', '', '', ''],
    ['A', 'N', 'A', 'N', 'A'],
  ];

  late List<List<TextEditingController>> controllers;

 final List<String> hintEmojis = [
    '🍎', // Apple
    '🍇', // Grape
    '🍌', // Banana
    '🍊', // Orange
    '🍋', // Lemon
  ];
  
  get hintImages => null;
  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      solution.length,
      (i) => List.generate(
        solution[i].length,
        (j) => TextEditingController(),
      ),
    );
  }

  @override
  void dispose() {
    for (var row in controllers) {
      for (var c in row) {
        c.dispose();
      }
    }
    super.dispose();
  }

  bool checkSolution() {
    for (int i = 0; i < solution.length; i++) {
      for (int j = 0; j < solution[i].length; j++) {
        if (solution[i][j] != '') {
          if (controllers[i][j].text.toUpperCase() != solution[i][j]) {
            return false;
          }
        }
      }
    }
    return true;
  }

  Widget buildCell(int i, int j) {
    if (solution[i][j] == '') {
      return Container(width: 48, height: 48);
    }
    return Container(
      margin: const EdgeInsets.all(2),
      width: 48,
      height: 48,
      child: TextField(
        controller: controllers[i][j],
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily:  'AlfaSlabOne',
          fontSize: 24,
          color: kThemeAccent,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: kThemeBackground,
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: kThemePrimary, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        cursorColor: kThemePrimary,
      ),
    );
  }

  void showResultDialog(bool correct) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: kThemeBackground,
        title: Text(
          correct ? 'Great Job!' : 'Try Again!',
          style: const TextStyle(
            fontFamily: kFontFamily,
            color: kThemePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          correct
              ? 'You solved the crossword!'
              : 'Some answers are incorrect. Keep trying!',
          style: const TextStyle(
            fontFamily: kFontFamily,
            color: kThemeAccent,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                fontFamily: kFontFamily,
                color: kThemePrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHintImages() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: hintImages.map((img) {
        return Image.asset(
          img,
          width: 64,
          height: 64,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeBackground,
      appBar: AppBar(
        backgroundColor: kThemePrimary,
        title: const Text(
          'Fruit Crossword',
          style: TextStyle(
            fontFamily: kFontFamily,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          buildHintImages(),
          const SizedBox(height: 24),
          Table(
            border: TableBorder.all(color: kThemeAccent, width: 2),
            children: List.generate(
              solution.length,
              (i) => TableRow(
                children: List.generate(
                  solution[i].length,
                  (j) => buildCell(i, j),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kThemePrimary,
              foregroundColor: kThemeBackground,
              textStyle: const TextStyle(
                fontFamily: kFontFamily,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            onPressed: () {
              bool correct = checkSolution();
              showResultDialog(correct);
            },
            child: const Text('Check'),
          ),
        ],
      ),
    );
  }
}
