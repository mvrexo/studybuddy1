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
                  title: 'Plant Diagram',
                  color: Colors.green[200]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ScienceLabelDiagramGame(),
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
  final List<Map<String, dynamic>> questions = [
    {'question': '2 + 2', 'answer': '4'},
    {'question': '2 + 1', 'answer': '3'},
    {'question': '1 + 4', 'answer': '5'},
    {'question': '3 + 4', 'answer': '7'},
  ];

  final List<String> choices = ['5', '3', '7', '4'];

  final Map<String, String> matched = {};
  final Map<String, bool> correct = {};
  final Map<String, bool> attempted = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeBackground,
      appBar: AppBar(
        title: const Text(
          'Match Math',
          style: TextStyle(
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
              children: questions.map((q) {
                final question = q['question'];
                final answer = q['answer'];
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
                      onWillAcceptWithDetails: (data) => matched[question] == null,
                      onAcceptWithDetails: (data) {
                        setState(() {
                          matched[question] = data.data;
                          attempted[question] = true;
                          if (data.data == answer) {
                            correct[question] = true;
                          } else {
                            correct[question] = false;
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
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kThemePrimary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(10, 36),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back, size: 18),
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
              ),
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

class ScienceLabelDiagramGame extends StatefulWidget {
  const ScienceLabelDiagramGame({super.key});

  @override
  State<ScienceLabelDiagramGame> createState() => _ScienceLabelDiagramGameState();
}

class _ScienceLabelDiagramGameState extends State<ScienceLabelDiagramGame> {
  // Positions for drop zones (adjust as needed for your diagram)
  final Map<String, Offset> targetPositions = {
    'Leaf': const Offset(170, 70),
    'Stem': const Offset(110, 170),
    'Root': const Offset(170, 260),
  };

  final List<String> labels = ['Leaf', 'Stem', 'Root'];
  final Map<String, String?> dropped = {}; // label -> dropped value
  final Map<String, bool> correct = {}; // label -> is correct

  @override
  void initState() {
    super.initState();
    for (var label in labels) {
      dropped[label] = null;
      correct[label] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeBackground,
      appBar: AppBar(
        backgroundColor: kThemePrimary,
        title: const Text(
          'Label the Diagram',
          style: TextStyle(
            fontFamily: kFontFamily,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Diagram image placeholder
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/plant_diagram.jpg',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text(
                      'Diagram not found',
                      style: TextStyle(
                        fontFamily: kFontFamily,
                        fontSize: 18,
                        color: kThemeAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Target label drop zones
          ...targetPositions.entries.map((entry) {
            final label = entry.key;
            final droppedValue = dropped[label];
            final isCorrect = correct[label] == true;
            final isAttempted = droppedValue != null;
            Color boxColor;
            Color borderColor;
            if (isAttempted) {
              if (isCorrect) {
                boxColor = Colors.green[300]!;
                borderColor = Colors.green;
              } else {
                boxColor = Colors.red[300]!;
                borderColor = Colors.red;
              }
            } else {
              boxColor = Colors.white;
              borderColor = Colors.black;
            }
            return Positioned(
              left: entry.value.dx,
              top: entry.value.dy,
              child: DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 80,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: boxColor,
                      border: Border.all(
                        color: borderColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      droppedValue ?? '',
                      style: TextStyle(
                        fontFamily: kFontFamily,
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                onWillAcceptWithDetails: (data) => dropped[label] == null,
                onAcceptWithDetails: (data) {
                  setState(() {
                    dropped[label] = data.data;
                    correct[label] = data.data == label;
                  });
                },
              ),
            );
          }),
          // Draggable labels at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: labels.map((label) {
                // Only show labels that haven't been dropped
                if (dropped.containsValue(label)) return const SizedBox(width: 80, height: 40);
                return Draggable<String>(
                  data: label,
                  feedback: _buildLabel(label, true),
                  childWhenDragging: _buildLabel(label, false),
                  child: _buildLabel(label, true),
                );
              }).toList(),
            ),
          ),
          // Score display
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Score: ${correct.values.where((v) => v).length}',
                style: const TextStyle(
                  fontFamily: kFontFamily,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Back button
          Positioned(
            left: 16,
            bottom: 24,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kThemePrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text(
                'Back',
                style: TextStyle(fontFamily: kFontFamily, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, bool visible) {
    return Container(
      width: 80,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: visible ? kThemePrimary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
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
        visible ? text : '',
        style: const TextStyle(
          fontFamily: kFontFamily,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
