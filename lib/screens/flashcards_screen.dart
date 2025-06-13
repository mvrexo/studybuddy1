import 'package:flutter/material.dart';
import 'dart:math';

class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  final List<Map<String, dynamic>> allFlashcards = [
    // Science
    {'question': 'What planet do we live on?', 'answer': 'Earth', 'image': 'assets/earth.jpg'},
    {'question': 'What do plants need to make food?', 'answer': 'Sunlight', 'image': 'assets/sunlight.jpg'},
    {'question': 'What gas do humans need to breathe?', 'answer': 'Oxygen', 'image': 'assets/oxygen.jpg'},
    {'question': 'What color is the sky on a sunny day?', 'answer': 'Blue', 'image': 'assets/bluesky.jpg'},
    {'question': 'What is H2O commonly known as?', 'answer': 'Water', 'image': 'assets/water.jpg'},

    // Math
    {'question': 'What is 7 + 6?', 'answer': '13', 'image': 'assets/13.jpg'},
    {'question': 'What shape has 3 sides?', 'answer': 'Triangle', 'image': 'assets/triangle.jpg'},
    {'question': 'What is half of 10?', 'answer': '5', 'image': 'assets/5.jpg'},
    {'question': 'What number comes after 19?', 'answer': '20', 'image': 'assets/20.png'},
    {'question': 'What is 3 x 4?', 'answer': '12', 'image': 'assets/12.png'},

    // Language
    {'question': 'What letter comes after A?', 'answer': 'B', 'image': 'assets/b.png'},
    {'question': 'Which word rhymes with “cat”?', 'answer': 'Hat', 'image': 'assets/hat.jpg'},
    {'question': 'What sound does a dog make?', 'answer': 'Woof', 'image': 'assets/woof.jpg'},
    {'question': 'What do you use to write?', 'answer': 'Pencil', 'image': 'assets/pencil.png'},
    {'question': 'What color is a banana?', 'answer': 'Yellow', 'image': 'assets/banana.jpg'},
  ];

  int currentIndex = 0;
  bool showAnswer = false;
  List<Map<String, dynamic>> selectedFlashcards = [];

  final Color pastelPrimary = const Color.fromARGB(255, 153, 115, 166);
  final Color pastelSecondary = const Color(0xFFFFF5E1);
  final Color pastelButton = const Color(0xFF716488);

  final List<Color> pastelCardColors = [
    const Color(0xFFFFF0F5), // LavenderBlush
    const Color(0xFFFFE4E1), // MistyRose
    const Color(0xFFFFFACD), // LemonChiffon
    const Color(0xFFE0FFFF), // LightCyan
    const Color(0xFFF0FFF0), // Honeydew
    const Color(0xFFF5F5DC), // Beige
  ];

  Color getRandomCardColor(int index) {
    return pastelCardColors[index % pastelCardColors.length];
  }

  @override
  void initState() {
    super.initState();
    allFlashcards.shuffle(Random());
    selectedFlashcards = allFlashcards.take(10).toList();
  }

  void nextCard() {
    setState(() {
      showAnswer = false;
      currentIndex = (currentIndex + 1) % selectedFlashcards.length;
    });
  }

  void previousCard() {
    setState(() {
      showAnswer = false;
      currentIndex = (currentIndex - 1 + selectedFlashcards.length) % selectedFlashcards.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = selectedFlashcards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flashcards',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: pastelPrimary,
      ),
      body: Container(
        color: pastelSecondary,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxHeight: 450,
                    minHeight: 400,
                    maxWidth: 600,
                  ),
                  decoration: BoxDecoration(
                    color: getRandomCardColor(currentIndex),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: pastelPrimary, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        showAnswer ? currentCard['answer']! : currentCard['question']!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      if (showAnswer && currentCard['image'] != null)
                        Image.asset(
                          currentCard['image'],
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showAnswer = !showAnswer;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: pastelButton,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        ),
                        child: Text(showAnswer ? 'Show Question' : 'Show Answer'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: previousCard,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: pastelPrimary,
                    side: BorderSide(color: pastelPrimary),
                  ),
                ),
                Text(
                  '${currentIndex + 1} / ${selectedFlashcards.length}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: nextCard,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: pastelPrimary,
                    side: BorderSide(color: pastelPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
