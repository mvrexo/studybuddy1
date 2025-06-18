import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  color: Colors.orange[200]!,
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
  int unlockedLevel = 0;

  late List<Map<String, String>> currentQuestions;
  late List<String> choices;

  Map<String, String> matched = {};
  Map<String, bool> correct = {};
  Map<String, bool> attempted = {};
  Map<int, int> starsEarned = {};
  Map<int, int> attemptsCount = {};
  Stopwatch levelTimer = Stopwatch();

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    unlockedLevel = prefs.getInt('unlockedLevel') ?? 0;
    final starsMap = prefs.getStringList('stars') ?? [];

    for (var entry in starsMap) {
      final split = entry.split(':');
      starsEarned[int.parse(split[0])] = int.parse(split[1]);
    }

    setState(() {
      currentLevel = 0;
      loadLevel(currentLevel);
    });
  }

  Future<void> saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unlockedLevel', unlockedLevel);

    final starsList =
        starsEarned.entries.map((e) => '${e.key}:${e.value}').toList();
    await prefs.setStringList('stars', starsList);
  }

  void loadLevel(int levelIndex) {
    currentQuestions = levels[levelIndex];
    choices = currentQuestions.map((q) => q['answer']!).toList()..shuffle();

    matched = {};
    correct = {};
    attempted = {};
    attemptsCount[levelIndex] = 0;
    levelTimer.reset();
    levelTimer.start();

    setState(() {});
  }

  bool isLevelComplete() {
    return currentQuestions.every((q) =>
        correct[q['question']] != null && correct[q['question']] == true);
  }

  void goToNextLevel() async {
    levelTimer.stop();
    int attempts = attemptsCount[currentLevel] ?? 0;
    int stars = attempts <= 4 ? 3 : attempts <= 6 ? 2 : 1;
    starsEarned[currentLevel] = stars;

    if (currentLevel + 1 < levels.length) {
      if (unlockedLevel < currentLevel + 1) {
        unlockedLevel = currentLevel + 1;
      }
      currentLevel++;
      await saveProgress();
      loadLevel(currentLevel);
    } else {
      await saveProgress();
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

  Widget _buildStars(int level) {
    int stars = starsEarned[level] ?? 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Icon(
          Icons.star,
          color: i < stars ? Colors.orangeAccent : Colors.grey,
          size: 18,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Reduce vertical padding for small screens
    return Scaffold(
      backgroundColor: kThemeBackground,
      appBar: AppBar(
        title: Text(
          'Math Match - Level ${currentLevel + 1}',
          style: const TextStyle(
            fontFamily: kFontFamily,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kThemePrimary,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use SingleChildScrollView to avoid overflow on small screens
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8), // smaller padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 6),
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
                            width: 60, // reduced from 80
                            height: 40, // reduced from 60
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: kThemeAccent, width: 2),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
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
                                fontSize: 16, // reduced from 20
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          DragTarget<String>(
                            builder: (context, candidateData, rejectedData) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 60, // reduced from 80
                                height: 40, // reduced from 60
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: boxColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  matched[question] ?? '',
                                  style: const TextStyle(
                                    fontFamily: kFontFamily,
                                    fontSize: 16, // reduced from 20
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
                                attemptsCount[currentLevel] =
                                    (attemptsCount[currentLevel] ?? 0) + 1;

                                if (data.data == answer) {
                                  matched[question] = data.data;
                                  correct[question] = true;
                                  if (isLevelComplete()) {
                                    Future.delayed(
                                        const Duration(milliseconds: 600), () {
                                      goToNextLevel();
                                    });
                                  }
                                } else {
                                  correct[question] = false;
                                  matched.remove(question);
                                }
                              });
                            },
                          )
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18), // reduced from 36
                  const Text(
                    'Choices',
                    style: TextStyle(
                      fontFamily: kFontFamily,
                      fontSize: 16, // reduced from 18
                      color: kThemeAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8), // reduced from 12
                  Wrap(
                    spacing: 10, // reduced from 18
                    runSpacing: 6, // reduced from 10
                    alignment: WrapAlignment.center,
                    children: choices.map((choice) {
                      final isUsed = matched.containsValue(choice);
                      return isUsed
                          ? const SizedBox(width: 60, height: 40)
                          : Draggable<String>(
                              data: choice,
                              feedback: _buildChoiceCard(choice, true),
                              childWhenDragging: _buildChoiceCard(choice, false),
                              child: _buildChoiceCard(choice, true),
                            );
                    }).toList(),
                  ),
                  const SizedBox(height: 10), // reduced from 16
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 32, // reduced from 36
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: kThemeAccent, width: 1.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: currentLevel,
                          dropdownColor: Colors.white,
                          icon: const Icon(Icons.arrow_drop_down,
                              color: kThemeAccent, size: 18),
                          style: const TextStyle(
                            fontFamily: kFontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: kThemeAccent,
                          ),
                          onChanged: (int? value) {
                            if (value != null &&
                                value <= unlockedLevel &&
                                value != currentLevel) {
                              setState(() {
                                currentLevel = value;
                                loadLevel(currentLevel);
                              });
                            }
                          },
                          items: List.generate(levels.length, (i) {
                            final isUnlocked = i <= unlockedLevel;
                            return DropdownMenuItem(
                              value: i,
                              enabled: isUnlocked,
                              child: Row(
                                children: [
                                  Text(
                                    'Level ${i + 1}',
                                    style: TextStyle(
                                      color: isUnlocked
                                          ? kThemeAccent
                                          : Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildStars(i),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChoiceCard(String value, bool visible) {
    return Container(
      width: 60, // reduced from 80
      height: 40, // reduced from 60
      alignment: Alignment.center,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: visible ? Colors.white : Colors.transparent,
        border: Border.all(color: kThemePrimary, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: visible
            ? [
                const BoxShadow(
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
          fontSize: 18, // reduced from 24
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