import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LearningLessonsScreen extends StatelessWidget {
  const LearningLessonsScreen({super.key});

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Lesson Subjects')),
    body: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: SubjectCard(
                    title: 'Math',
                    icon: Icons.calculate,
                    imageUrl: 'https://cdn-icons-png.flaticon.com/512/1974/1974717.png',
                    color: Colors.orange.shade300,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MathGameScreen()));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SubjectCard(
                    title: 'English',
                    icon: Icons.menu_book,
                    imageUrl: 'https://cdn-icons-png.flaticon.com/512/2965/2965567.png',
                    color: Colors.blue.shade300,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const EnglishReadingScreen()));
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 5,
                  child: SubjectCard(
                    title: 'Science',
                    icon: Icons.science,
                    imageUrl: 'https://cdn-icons-png.flaticon.com/512/2331/2331837.png',
                    color: Colors.green.shade300,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ScienceTutorialScreen()));
                    },
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}

class SubjectCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String imageUrl;
  final Color color;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.title,
    required this.icon,
    required this.imageUrl,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, width: 80, height: 80),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}


class MathGameScreen extends StatefulWidget {
const MathGameScreen({super.key});

@override
State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  final List<Map<String, dynamic>> originalActivities = [
    {'question': '🍎', 'count': 4},
    {'question': '🐇', 'count': 3},
    {'question': '🍩', 'count': 5},
    {'question': '🌟', 'count': 6},
    {'question': '🧁', 'count': 2},
  ];

  late List<Map<String, dynamic>> activities;
  int currentIndex = 0;
  String droppedAnswer = '';
  int stars = 0;
  int wrongAttempts = 0;
  bool showingDialog = false;

  final List<String> numberOptions = ['2', '3', '4', '5', '6'];

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    activities = List<Map<String, dynamic>>.from(originalActivities);
    activities.shuffle(Random());
    currentIndex = 0;
    droppedAnswer = '';
    stars = 0;
    wrongAttempts = 0;
    showingDialog = false;
  }

  void _showScoreScreen() {
    if (showingDialog) return;
    showingDialog = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Game Complete! 🎉'),
          content: Text('You scored $stars stars in total.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _resetGame();
                });
              },
              child: const Text('Play Again'),
            ),
          ],
        ),
      );
    });
  }

  void _handleAnswer(String data, int correctAnswer) {
    final isCorrect = data == correctAnswer.toString();
    if (!isCorrect) {
      setState(() => wrongAttempts += 1);
    }

    if (showingDialog) return;

    showingDialog = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text(isCorrect ? 'Correct! ⭐' : 'Try Again!'),
          content: Text(
            isCorrect
                ? 'Great job! You earned ${(3 - wrongAttempts).clamp(1, 3)} stars!'
                : 'The correct answer is $correctAnswer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  showingDialog = false;
                  droppedAnswer = '';
                  if (isCorrect) {
                    stars += (3 - wrongAttempts).clamp(1, 3);
                    currentIndex += 1;
                    wrongAttempts = 0;
                  }
                });
              },
              child: Text(isCorrect ? 'Next Question' : 'Try Again'),
            ),
          ],
        ),
      );
    });

    setState(() {
      droppedAnswer = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= activities.length) {
      _showScoreScreen();
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final activity = activities[currentIndex];
    final objectCount = activity['count'];
    final objectSymbol = activity['question'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Game: Count the Objects'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text('$stars', style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'How many $objectSymbol are there?',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: List.generate(objectCount, (_) {
                      return Text(objectSymbol, style: const TextStyle(fontSize: 60));
                    }),
                  ),
                ],
              ),
              DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    height: 100,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: droppedAnswer.isEmpty ? Colors.grey[300] : Colors.green[300],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black38, width: 2),
                    ),
                    child: Text(
                      droppedAnswer.isEmpty ? 'Drop Answer Here' : 'Answer: $droppedAnswer',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                },
                onWillAcceptWithDetails: (_) => true,
                onAcceptWithDetails: (details) => _handleAnswer(details.data, objectCount),

              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: currentIndex > 0
                        ? () {
                            setState(() {
                              currentIndex -= 1;
                              droppedAnswer = '';
                              wrongAttempts = 0;
                            });
                          }
                        : null,
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: currentIndex < activities.length - 1
                        ? () {
                            setState(() {
                              currentIndex += 1;
                              droppedAnswer = '';
                              wrongAttempts = 0;
                            });
                          }
                        : null,
                    child: const Text('Next'),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Drag the correct number:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: numberOptions.map((num) {
                      return Draggable<String>(
                        data: num,
                        feedback: Material(
                          color: Colors.transparent,
                          child: _buildNumberBox(num, color: Colors.orange),
                        ),
                        childWhenDragging: _buildNumberBox(num, color: Colors.grey),
                        child: _buildNumberBox(num, color: Colors.orange.shade300),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberBox(String num, {required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (color != Colors.grey)
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
        ],
      ),
      child: Text(
        num,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class EnglishReadingScreen extends StatefulWidget {
  const EnglishReadingScreen({super.key});

  @override
  State<EnglishReadingScreen> createState() => _EnglishReadingScreenState();
}

class _EnglishReadingScreenState extends State<EnglishReadingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> pages = const [
    {
      'image': 'assets/c1.jpg',
      'text': 'Milo is a little cat who loves to explore.',
    },
    {
      'image': 'assets/c2.jpg',
      'text': 'One day, Milo found a big yellow flower in the garden.',
    },
    {
      'image': 'assets/c3.jpg',
      'text': 'He followed a butterfly into the woods.',
    },
    {
      'image': 'assets/c4.jpg',
      'text': 'Milo got a little lost but he stayed brave.',
    },
    {
      'image': 'assets/c5.jpg',
      'text': 'At last, he found his way home and took a nap.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      currentPage = index;
    });
  }

  void _goToPrevious() {
    if (currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goToNext() {
    if (currentPage < pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Widget _buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pages.length, (index) {
        bool isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 10,
          width: isActive ? 24 : 12,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Story Time: Milo the Little Cat')),
    body: Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final page = pages[index];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          page['image']!,
                          fit: BoxFit.contain, // Tak potong gambar
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Text(
                            page['text']!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildDotsIndicator(),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: currentPage == 0 ? null : _goToPrevious,
                child: const Text('Previous'),
              ),
              ElevatedButton(
                onPressed: currentPage == pages.length - 1 ? null : _goToNext,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}


class ScienceTutorialScreen extends StatelessWidget {
  const ScienceTutorialScreen({super.key});

  final List<Map<String, dynamic>> experiments = const [
    {
      'title': '🌱 Plants & Animals',
      'image': 'assets/plant.jpg',
      'subtitle': 'Social Experiment: Do Plants Need Light?',
      'objective': 'To understand that plants need light to grow.',
      'steps': [
        'Take 2 small pots with bean plants.',
        'Place one pot in a bright place (e.g., near a window).',
        'Place the other in a dark place (e.g., inside a cupboard).',
        'Leave both for 3–5 days.',
        'Observe and compare the results.',
      ],
      'observation':
          'The plant in the dark becomes yellow and weak. The plant in the light grows healthy and green.',
      'discussion': [
        '💬 What is the difference between the two plants?',
        '💬 Why do plants need sunlight?',
      ],
      'videoUrl': 'https://www.youtube.com/watch?v=Gskasi4-O3E'
    },
    {
      'title': '👃 The Five Senses',
      'image': 'assets/guess.jpg',
      'subtitle': 'Social Experiment: Guess Without Seeing',
      'objective': 'To use other senses when one sense is blocked.',
      'steps': [
        'Blindfold the student using a cloth.',
        'Give them different objects to touch and guess (e.g., sponge, stone, toy).',
        'Optional: Smell Test (lemon, onion, soap).',
        'Optional: Sound Test (coin shake, clap, bell).',
      ],
      'observation':
          'Students use their sense of touch, smell, and hearing to identify objects.',
      'discussion': [
        '💬 How did it feel when you couldn’t see?',
        '💬 Can you identify things using only touch or smell?',
      ],
      'videoUrl': 'https://www.youtube.com/watch?v=TVj4k1oSq-s'
    },
    {
      'title': '🔥 Hot & Cold Objects',
      'image': 'assets/suhu.jpg',
      'subtitle': 'Social Experiment: Touch and Feel the Temperature',
      'objective': 'To understand how to feel temperature differences using hands.',
      'steps': [
        'Prepare 3 cups: A (cold water), B (warm water), C (room temperature).',
        'Let students touch each cup and guess the temperature.',
        'Safety Tips: Use closed containers. Warm water only.',
      ],
      'observation':
          'Students can feel the difference between cold, warm, and room temperature.',
      'discussion': [
        '💬 Which one felt the coldest?',
        '💬 How can we feel temperature with our hands?',
      ],
      'videoUrl': 'https://www.youtube.com/watch?v=MnPPDaPaKEo'
    },
  ];

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Science Experiments')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: experiments.length,
        itemBuilder: (context, index) {
          final exp = experiments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (exp['image'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        exp['image'],
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(exp['title'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(exp['subtitle'],
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('🎯 Objective: ${exp['objective']}'),
                  const SizedBox(height: 8),
                  const Text('🧪 Steps:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...List.generate((exp['steps'] as List).length, (i) {
                    return Text('• ${(exp['steps'] as List)[i]}');
                  }),
                  const SizedBox(height: 8),
                  const Text('👀 Observation:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(exp['observation']),
                  const SizedBox(height: 8),
                  const Text('💬 Discussion Questions:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...List.generate((exp['discussion'] as List).length, (i) {
                    return Text((exp['discussion'] as List)[i]);
                  }),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _launchURL(exp['videoUrl']),
                      icon: const Icon(Icons.play_circle_fill),
                      label: const Text('Watch Tutorial Video'),
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
}