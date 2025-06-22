import 'package:flutter/material.dart';
import 'dart:math';

/// FlashcardsScreen displays a set of flashcards for study.
/// Each card shows a question, and can reveal the answer and an image.
class FlashcardsScreen extends StatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  // List of all available flashcards (question, answer, image)
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

  int currentIndex = 0; // Current flashcard index
  bool showAnswer = false; // Whether to show answer or question
  List<Map<String, dynamic>> selectedFlashcards = []; // Flashcards for this session

  // Theme colors
  final Color themePrimary = Colors.deepOrangeAccent;
  final Color themeBackground = const Color(0xFFFFF5E1); // light cream
  final Color themeAccent = const Color(0xFF8B4513); // brown tone

  // Card background colors (all white for now)
  final List<Color> cardColors = List.generate(
    6,
    (index) => const Color.fromARGB(255, 255, 255, 255),
  );

  /// Returns a card color based on index
  Color getRandomCardColor(int index) {
    return cardColors[index % cardColors.length];
  }

  @override
  void initState() {
    super.initState();
    // Shuffle and pick 10 flashcards for the session
    allFlashcards.shuffle(Random());
    selectedFlashcards = allFlashcards.take(10).toList();
  }

  /// Move to next card
  void nextCard() {
    setState(() {
      showAnswer = false;
      currentIndex = (currentIndex + 1) % selectedFlashcards.length;
    });
  }

  /// Move to previous card
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
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'AlfaSlabOne',
            color: Colors.white,
          ),
        ),
        backgroundColor: themePrimary,
      ),
      body: Container(
        color: themeBackground,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Flashcard display
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
                    border: Border.all(color: themePrimary, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Question or Answer text
                      Text(
                        showAnswer ? currentCard['answer']! : currentCard['question']!,
                        style: const TextStyle(
                          fontSize: 26,
                          fontFamily: 'AlfaSlabOne',
                          color: Colors.brown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Show image if answer is revealed
                      if (showAnswer && currentCard['image'] != null)
                        Image.asset(
                          currentCard['image'],
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                      const SizedBox(height: 20),
                      // Show/Hide Answer button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showAnswer = !showAnswer;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        ),
                        child: Text(
                          showAnswer ? 'Show Question' : 'Show Answer',
                          style: const TextStyle(
                            fontFamily: 'AlfaSlabOne',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Navigation row (Previous, Counter, Next)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                ElevatedButton.icon(
                  onPressed: previousCard,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: themePrimary,
                    side: BorderSide(color: themePrimary),
                    textStyle: const TextStyle(fontFamily: 'AlfaSlabOne'),
                  ),
                ),
                // Card counter
                Text(
                  '${currentIndex + 1} / ${selectedFlashcards.length}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'AlfaSlabOne',
                  ),
                ),
                // Next button
                ElevatedButton.icon(
                  onPressed: nextCard,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: themePrimary,
                    side: BorderSide(color: themePrimary),
                    textStyle: const TextStyle(fontFamily: 'AlfaSlabOne'),
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
