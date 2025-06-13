import 'package:flutter/material.dart';
import 'dart:async';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
 final List<Map<String, dynamic>> questions = [
  {
    'question': 'What color is the sky?',
    'options': ['Blue', 'Green', 'Red', 'Yellow'],
    'answer': 'Blue',
  },
  {
    'question': 'What is 2 + 2?',
    'options': ['3', '4', '5', '6'],
    'answer': '4'
  },
  {
    'question': 'Which animal barks?',
    'options': ['Cat', 'Dog', 'Cow', 'Sheep'],
    'answer': 'Dog'
  },
  {
    'question': 'What is the capital of Malaysia?',
    'options': ['Kuala Lumpur', 'Singapore', 'Jakarta', 'Bangkok'],
    'answer': 'Kuala Lumpur'
  },
  {
    'question': 'What is the largest planet in our solar system?',
    'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
    'answer': 'Jupiter'
  },
  {
    'question': 'What is the main ingredient in bread?',
    'options': ['Rice', 'Flour', 'Sugar', 'Salt'],
    'answer': 'Flour'
  },
  {
    'question': 'Which of these is a fruit?',
    'options': ['Carrot', 'Apple', 'Potato', 'Broccoli'],
    'answer': 'Apple'
  },
  {
    'question': 'What is the opposite of hot?',
    'options': ['Cold', 'Warm', 'Cool', 'Boiling'],
    'answer': 'Cold'
  },
  {
    'question': 'Which shape has three sides?',
    'options': ['Square', 'Circle', 'Triangle', 'Rectangle'],
    'answer': 'Triangle'
  },
  {
    'question': 'What do bees produce?',
    'options': ['Honey', 'Milk', 'Eggs', 'Butter'],
    'answer': 'Honey'
  },
];


  int currentQuestion = 0;
  late List<int?> selectedIndexes;
  int score = 0;
  Stopwatch stopwatch = Stopwatch();
  late Timer timer;
  int elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    selectedIndexes = List.filled(questions.length, null);
    stopwatch.start();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds = stopwatch.elapsed.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    stopwatch.stop();
    super.dispose();
  }

  void selectAnswer(int selectedIndex) {
    if (selectedIndexes[currentQuestion] != null) return;

    setState(() {
      selectedIndexes[currentQuestion] = selectedIndex;
      if (questions[currentQuestion]['options'][selectedIndex] ==
          questions[currentQuestion]['answer']) {
        score++;
      }
    });

    // Auto next question selepas 1 saat delay
    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestion < questions.length - 1) {
        setState(() {
          currentQuestion++;
        });
      } else {
        stopwatch.stop();
        timer.cancel();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text('Quiz Completed!'),
            content: Text(
              'Score: $score/${questions.length}\nTime: $elapsedSeconds seconds',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    currentQuestion = 0;
                    selectedIndexes = List.filled(questions.length, null);
                    score = 0;
                    elapsedSeconds = 0;
                    stopwatch.reset();
                    stopwatch.start();
                    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                      setState(() {
                        elapsedSeconds = stopwatch.elapsed.inSeconds;
                      });
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text('Restart'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // tutup dialog
                  Navigator.pop(context); // keluar quiz page
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];
    final selectedIndex = selectedIndexes[currentQuestion];
    final correctAnswer = question['answer'];

    // Calculate size for square options (responsive)
    double screenWidth = MediaQuery.of(context).size.width;
    int optionsCount = question['options'].length;
    double padding = 16 * 2; // horizontal padding total
    double spacing = 12 * (optionsCount - 1); // space between options horizontally
    double totalAvailableWidth = screenWidth - padding - spacing;
    double optionSize = totalAvailableWidth / optionsCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4C3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF689F38),
        title: Text('Question ${currentQuestion + 1} / ${questions.length}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Leaderboard box
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCEDC8),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade700, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Score: $score',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Time: $elapsedSeconds s',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Soalan
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          question['question'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Jawapan dalam bentuk kotak square
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(optionsCount, (i) {
                          final option = question['options'][i];
                          final isCorrect = option == correctAnswer;
                          final isSelected = selectedIndex == i;

                          Color tileColor = Colors.white;
                          Icon? icon;

                          if (selectedIndex != null) {
                            if (isCorrect) {
                              tileColor = Colors.green[300]!;
                              icon = const Icon(Icons.check, color: Colors.green);
                            } else if (isSelected) {
                              tileColor = Colors.red[300]!;
                              icon = const Icon(Icons.close, color: Colors.red);
                            } else {
                              tileColor = Colors.grey[200]!;
                            }
                          }

                          return GestureDetector(
                            onTap: () => selectAnswer(i),
                            child: Container(
                              width: optionSize,
                              height: optionSize,
                              decoration: BoxDecoration(
                                color: tileColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade400),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        option,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected || (selectedIndex != null && isCorrect)
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (icon != null)
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: icon,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
