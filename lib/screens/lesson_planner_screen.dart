import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LessonPlannerScreen extends StatefulWidget {
  const LessonPlannerScreen({super.key});

  @override
  _LessonPlannerScreenState createState() => _LessonPlannerScreenState();
}

class _LessonPlannerScreenState extends State<LessonPlannerScreen> {
  final Map<String, List<Map<String, dynamic>>> _tasksByDate = {};
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final List<Map<String, String>> _defaultTasks = [
    {'title': 'Read an English story'},
    {'title': 'Complete a math quiz'},
    {'title': 'Try a science experiment'},
  ];

  double _goalProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('lesson_tasks');
    if (storedData != null) {
      Map<String, dynamic> jsonData = jsonDecode(storedData);
      _tasksByDate.clear();
      jsonData.forEach((key, value) {
        List<dynamic> list = value;
        _tasksByDate[key] = list.map((e) {
          return {
            'title': e['title'],
            'completed': e['completed'] ?? false,
          };
        }).toList();
      });
    } else {
      String todayKey = _formatDate(_selectedDay);
      _tasksByDate[todayKey] = _defaultTasks
          .map((e) => {'title': e['title']!, 'completed': false})
          .toList();
    }
    _calculateGoalProgress();
    setState(() {});
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> jsonData = {};
    _tasksByDate.forEach((key, value) {
      jsonData[key] = value;
    });
    await prefs.setString('lesson_tasks', jsonEncode(jsonData));
  }

  String _formatDate(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      String key = _formatDate(selectedDay);
      if (!_tasksByDate.containsKey(key)) {
        _tasksByDate[key] = _defaultTasks
            .map((e) => {'title': e['title']!, 'completed': false})
            .toList();
        _saveTasks();
      }
      _calculateGoalProgress();
    });
  }

  void _toggleTaskCompleted(int index) {
    String key = _formatDate(_selectedDay);
    setState(() {
      _tasksByDate[key]![index]['completed'] =
          !(_tasksByDate[key]![index]['completed'] as bool);
      _calculateGoalProgress();
      _saveTasks();
      if (_tasksByDate[key]!.every((task) => task['completed'] == true)) {
        Future.delayed(Duration.zero, () => _showCongratsDialog());
      }
    });
  }

  void _showReminder() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Reminder'),
              content: const Text('Finish your learning tasks today!'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK')),
              ],
            ));
  }

  void _calculateGoalProgress() {
    String key = _formatDate(_selectedDay);
    if (!_tasksByDate.containsKey(key)) {
      _goalProgress = 0.0;
      return;
    }
    int total = _tasksByDate[key]!.length;
    int completed = _tasksByDate[key]!.where((t) => t['completed'] == true).length;
    _goalProgress = total == 0 ? 0 : completed / total;
  }

  void _showCongratsDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Great job! 🎉'),
              content: const Text('You have completed all tasks for today!'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Thanks')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    String selectedKey = _formatDate(_selectedDay);
    List<Map<String, dynamic>> todayTasks = _tasksByDate[selectedKey] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Planner'),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 255, 191, 0),
        elevation: 4,
        actions: [
          IconButton(
              tooltip: 'Show Reminder',
              icon: const Icon(Icons.alarm),
              onPressed: _showReminder)
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/rocket.jpg',
            fit: BoxFit.cover,
          ),

          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  // Calendar card
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    color: Colors.white.withOpacity(0.85),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2100, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                        onDaySelected: _onDaySelected,
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 191, 0),
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 191, 0),
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          weekendTextStyle:
                              const TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                          defaultTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 0, 0, 0)),
                          leftChevronIcon:
                              Icon(Icons.chevron_left, color: Color.fromARGB(255, 255, 196, 19)),
                          rightChevronIcon:
                              Icon(Icons.chevron_right, color: Color.fromARGB(255, 255, 196, 19)),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Progress bar with label
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 5,
                    color: Colors.white.withOpacity(0.85),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: _goalProgress,
                                backgroundColor: Colors.grey.shade300,
                                color: const Color.fromARGB(255, 255, 191, 0),
                                minHeight: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${(_goalProgress * 100).toInt()}%",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tasks checklist card with scroll
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                      color: Colors.white.withOpacity(0.85),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: ListView.builder(
                          itemCount: todayTasks.length,
                          itemBuilder: (context, index) {
                            final task = todayTasks[index];
                            return CheckboxListTile(
                              title: Text(
                                task['title'],
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              value: task['completed'] as bool,
                              onChanged: (val) {
                                _toggleTaskCompleted(index);
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: const Color.fromARGB(255, 112, 255, 64),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
