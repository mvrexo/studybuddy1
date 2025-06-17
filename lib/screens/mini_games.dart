import 'package:flutter/material.dart';

const Color kThemePrimary = Colors.deepOrangeAccent;
const Color kThemeBackground = Color(0xFFFFF5E1);
const Color kThemeAccent = Color(0xFF8B4513);
const String kFontFamily = 'AlfaSlabOne';

class MiniGamesScreen extends StatelessWidget {
  const MiniGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeBackground,
      appBar: AppBar(
        backgroundColor: kThemePrimary,
        title: const Text(
          'Mini Games',
          style: TextStyle(
            fontFamily: kFontFamily,
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a Game',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 28,
                color: kThemeAccent,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _GameCard(
                  icon: Icons.calculate,
                  title: 'Match Math',
                  color: Colors.orange[200]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MathMatchGame(),
                      ),
                    );
                  },
                ),
                _GameCard(
                  icon: Icons.science,
                  title: 'Science Crossword',
                  color: Colors.green[200]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          const scienceCrosswordGame = ScienceCrosswordGame();
                          return scienceCrosswordGame;
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _GameCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(18),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 140,
          height: 170,
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 54, color: kThemeAccent),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 18,
                  color: kThemeAccent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MathMatchGame extends StatefulWidget {
  const MathMatchGame({super.key});

  @override
  State<MathMatchGame> createState() => _MathMatchGameState();
}

class _MathMatchGameState extends State<MathMatchGame> {
  final List<List<Map<String, String>>> levels = [
    [
      {'question': '2 + 2', 'answer': '4'},
      {'question': '2 + 1', 'answer': '3'},
      {'question': '1 + 4', 'answer': '5'},
      {'question': '3 + 4', 'answer': '7'},
    ],
    [
      {'question': '5 - 2', 'answer': '3'},
      {'question': '4 + 4', 'answer': '8'},
      {'question': '6 - 1', 'answer': '5'},
      {'question': '5 + 2', 'answer': '7'},
    ],
    [
      {'question': '2 x 3', 'answer': '6'},
      {'question': '9 - 1', 'answer': '8'},
      {'question': '10 + 5', 'answer': '15'},
      {'question': '10 / 2', 'answer': '5'},
    ]
  ];

  int currentLevel = 0;
  late List<Map<String, String>> currentQuestions;
  late List<String> choices;

  Map<String, String> matched = {};
  Map<String, bool> correct = {};
  Map<String, bool> attempted = {};

  @override
  void initState() {
    super.initState();
    loadLevel(currentLevel);
  }

  void loadLevel(int levelIndex) {
    currentQuestions = levels[levelIndex];
    choices = currentQuestions.map((q) => q['answer']!).toList()..shuffle();

    matched = {};
    correct = {};
    attempted = {};
    setState(() {});
  }

  bool isLevelComplete() {
    return currentQuestions.every((q) =>
        correct[q['question']] != null && correct[q['question']] == true);
  }

  void goToNextLevel() {
    if (!isLevelComplete()) return;
    if (currentLevel + 1 < levels.length) {
      currentLevel++;
      loadLevel(currentLevel);
    } else {
      // Game completed
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('🎉 Congratulations!'),
          content: const Text('You completed all levels!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeBackground,
      appBar: AppBar(
        title: Text(
          'Match Math - Level ${currentLevel + 1}',
          style: const TextStyle(
            fontFamily: kFontFamily,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kThemePrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: currentQuestions.map((q) {
                final question = q['question']!;
                final answer = q['answer']!;
                final isMatched = matched[question] != null;
                final isCorrect = correct[question] == true;

                Color boxColor;
                Color borderColor;
                if (isMatched) {
                  if (isCorrect) {
                    boxColor = Colors.green[200]!;
                    borderColor = Colors.green;
                  } else {
                    boxColor = Colors.red[200]!;
                    borderColor = Colors.red;
                  }
                } else {
                  boxColor = Colors.grey[200]!;
                  borderColor = Colors.grey;
                }

                return Column(
                  children: [
                    Container(
                      width: 80,
                      height: 60,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: kThemeAccent, width: 2),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        question,
                        style: const TextStyle(
                          fontFamily: kFontFamily,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    DragTarget<String>(
                      builder: (context, candidateData, rejectedData) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 80,
                          height: 60,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: borderColor,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            matched[question] ?? '',
                            style: const TextStyle(
                              fontFamily: kFontFamily,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        );
                      },
                      onWillAcceptWithDetails: (data) =>
                          matched[question] == null,
                      onAcceptWithDetails: (data) {
                        setState(() {
                          attempted[question] = true;
                          if (data.data == answer) {
                            matched[question] = data.data;
                            correct[question] = true;
                          } else {
                            correct[question] = false;
                            matched.remove(question); // Reset if wrong
                          }
                        });
                      },
                    )
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 36),
            const Text(
              'Choices',
              style: TextStyle(
                fontFamily: kFontFamily,
                fontSize: 18,
                color: kThemeAccent,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 18,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: choices.map((choice) {
                final isUsed = matched.containsValue(choice);
                return isUsed
                    ? const SizedBox(width: 80, height: 60)
                    : Draggable<String>(
                        data: choice,
                        feedback: _buildChoiceCard(choice, true),
                        childWhenDragging: _buildChoiceCard(choice, false),
                        child: _buildChoiceCard(choice, true),
                      );
              }).toList(),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kThemePrimary,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.menu),
                  label: const Text(
                    'Menu',
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isLevelComplete() ? Colors.green : Colors.grey,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text(
                    'Next Level',
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: isLevelComplete() ? goToNextLevel : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceCard(String value, bool visible) {
    return Container(
      width: 80,
      height: 60,
      alignment: Alignment.center,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: visible ? Colors.white : Colors.transparent,
        border: Border.all(color: kThemePrimary, width: 2),
        borderRadius: BorderRadius.circular(10),
        boxShadow: visible
            ? [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Text(
        visible ? value : '',
        style: TextStyle(
          fontFamily: kFontFamily,
          fontSize: 24,
          color: visible ? kThemePrimary : Colors.transparent,
        ),
      ),
    );
  }
}

class ScienceCrosswordGame extends StatefulWidget {
  const ScienceCrosswordGame({super.key});

  @override
  State<ScienceCrosswordGame> createState() => _ScienceCrosswordGameState();
}

class _ScienceCrosswordGameState extends State<ScienceCrosswordGame> {
  final List<Map<String, dynamic>> levels = [
    {
      'name': 'Animals',
      'grid': [
        [null, 'T', null, null],
        ['L', 'I', 'O', 'N'],
        [null, 'G', null, null],
        [null, 'E', null, null],
        [null, 'R', null, null],
      ],
      'cluesAcross': ['1. Across – King of the jungle'],
      'cluesDown': ['1. Down – Big striped wild cat'],
      'definitions': [
        'LION – A powerful wild cat called the king of the jungle.',
        'TIGER – A large cat with orange fur and black stripes.'
      ]
    },
    {
      'name': 'Plants',
      'grid': [
        [null, null, 'L', null],
        ['T', 'R', 'E', 'E'],
        [null, null, 'A', null],
        [null, null, 'F', null],
        [null, null, null, null],
      ],
      'cluesAcross': ['1. Across – Has leaves and a trunk'],
      'cluesDown': ['1. Down – Makes food using sunlight'],
      'definitions': [
        'TREE – A tall plant with leaves and a trunk.',
        'LEAF – Makes food through photosynthesis.'
      ]
    },
    {
      'name': 'Space',
      'grid': [
        ['E', 'A', 'R', 'T', 'H'],
        [null, null, null, null, null],
        [null, null, null, null, 'M'],
        [null, null, 'S', null, 'O'],
        [null, null, 'K', null, 'O'],
        [null, null, 'Y', null, 'N'],
      ],
      'cluesAcross': ['1. Across – Our planet'],
      'cluesDown': ['1. Down – Night sky object', '2. Down – Blue area above Earth'],
      'definitions': [
        'EARTH – Our home planet.',
        'MOON – The natural satellite of Earth.',
        'SKY – The space we see when we look up.'
      ]
    },
  ];

  int selectedLevelIndex = 0;
  List<List<String>> userInput = [];
  int hintCount = 0;
  final int maxHints = 3;

  @override
  void initState() {
    super.initState();
    _resetGrid();
  }

  void _resetGrid() {
    final grid = levels[selectedLevelIndex]['grid'] as List<List<String?>>;
    userInput = List.generate(grid.length,
        (r) => List.generate(grid[r].length, (_) => '', growable: false),
        growable: false);
    hintCount = 0;
  }

  void _useHint() {
    final correctGrid = levels[selectedLevelIndex]['grid'] as List<List<String?>>;
    for (int r = 0; r < correctGrid.length; r++) {
      for (int c = 0; c < correctGrid[r].length; c++) {
        final correct = correctGrid[r][c];
        if (correct != null && userInput[r][c].toUpperCase() != correct.toUpperCase()) {
          setState(() {
            userInput[r][c] = correct;
            hintCount++;
          });
          return;
        }
      }
    }
  }

  void _checkAnswers() {
    final correctGrid = levels[selectedLevelIndex]['grid'] as List<List<String?>>;
    int total = 0, correct = 0;

    for (int r = 0; r < correctGrid.length; r++) {
      for (int c = 0; c < correctGrid[r].length; c++) {
        final correctChar = correctGrid[r][c];
        if (correctChar != null) {
          total++;
          if (userInput[r][c].toUpperCase() == correctChar.toUpperCase()) {
            correct++;
          }
        }
      }
    }

    String message;
    if (correct == total) {
      message = '🎉 Great job! All correct!\n\n${(levels[selectedLevelIndex]['definitions'] as List<String>).join('\n')}';
    } else if (correct == 0) {
      message = '😕 All answers are wrong. Try again!';
    } else {
      message = '✅ $correct correct out of $total cells.';
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Results'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final level = levels[selectedLevelIndex];
    final grid = level['grid'] as List<List<String?>>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Science Crossword'),
        actions: [
          DropdownButton<int>(
            value: selectedLevelIndex,
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  selectedLevelIndex = val;
                  _resetGrid();
                });
              }
            },
            items: List.generate(
              levels.length,
              (i) => DropdownMenuItem(value: i, child: Text(levels[i]['name'])),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildGrid(grid),
            const SizedBox(height: 16),
            _buildClues(level),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.lightbulb),
                  label: Text('Hint (${maxHints - hintCount})'),
                  onPressed: hintCount < maxHints ? _useHint : null,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Check'),
                  onPressed: _checkAnswers,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<List<String?>> grid) {
    final rowCount = grid.length;
    final colCount = grid[0].length;

    return SizedBox(
      width: colCount * 48,
      height: rowCount * 48,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rowCount * colCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: colCount,
        ),
        itemBuilder: (context, index) {
          final row = index ~/ colCount;
          final col = index % colCount;
          final correctLetter = grid[row][col];

          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: correctLetter != null ? Colors.white : Colors.grey[300],
              border: Border.all(color: Colors.black),
            ),
            child: correctLetter != null
                ? Center(
                    child: TextField(
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(counterText: '', border: InputBorder.none),
                      onChanged: (val) {
                        setState(() {
                          userInput[row][col] = val.toUpperCase();
                        });
                      },
                      controller: TextEditingController.fromValue(
                        TextEditingValue(text: userInput[row][col]),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildClues(Map<String, dynamic> level) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("🡒 Across", style: TextStyle(fontWeight: FontWeight.bold)),
              ...List<Widget>.from(
                (level['cluesAcross'] as List<String>).map((c) => Text("• $c")),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("🡑 Down", style: TextStyle(fontWeight: FontWeight.bold)),
              ...List<Widget>.from(
                (level['cluesDown'] as List<String>).map((c) => Text("• $c")),
              ),
            ],
          ),
        ),
      ],
    );
  }
}