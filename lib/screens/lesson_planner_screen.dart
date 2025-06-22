import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Theme colors
final Color themePrimary = Colors.deepOrangeAccent;
final Color themeBackground = const Color(0xFFFFF5E1);
final Color themeAccent = const Color(0xFF8B4513);

/// Lesson Planner Screen
class LessonPlannerScreen extends StatefulWidget {
  const LessonPlannerScreen({super.key});

  @override
  LessonPlannerScreenState createState() => LessonPlannerScreenState();
}

class LessonPlannerScreenState extends State<LessonPlannerScreen> {
  // Stores tasks by date in the format 'yyyy-MM-dd'
  final Map<String, List<Map<String, dynamic>>> _tasksByDate = {};

  // Calendar state
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Default tasks for a new day
  final List<Map<String, String>> _defaultTasks = [
    {'title': 'Read an English story'},
    {'title': 'Complete a math quiz'},
    {'title': 'Try a science experiment'},
  ];

  double _goalProgress = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /// Loads tasks from shared preferences
  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString('lesson_tasks');
    _tasksByDate.clear();
    if (storedData != null && storedData.isNotEmpty) {
      try {
        Map<String, dynamic> jsonData = jsonDecode(storedData);
        jsonData.forEach((key, value) {
          List<dynamic> list = value;
          _tasksByDate[key] = list.map((e) {
            return {
              'title': e['title'],
              'completed': e['completed'] ?? false,
            };
          }).toList();
        });
      } catch (_) {
        // Ignore corrupt data
      }
    }
    _calculateGoalProgress();
    setState(() {
      _loading = false;
    });
  }

  /// Saves tasks to shared preferences
  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> jsonData = {};
    _tasksByDate.forEach((key, value) {
      jsonData[key] = value;
    });
    await prefs.setString('lesson_tasks', jsonEncode(jsonData));
  }

  /// Formats a DateTime as 'yyyy-MM-dd'
  String _formatDate(DateTime d) =>
      "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  /// Handles day selection in the calendar
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

  /// Toggles completion state of a task
  void _toggleTaskCompleted(int index) {
    String key = _formatDate(_selectedDay);
    setState(() {
      _tasksByDate[key]![index]['completed'] =
          !(_tasksByDate[key]![index]['completed'] as bool);
      _calculateGoalProgress();
    });
    _saveTasks();
    // Show congrats dialog if all tasks completed
    if (_tasksByDate[key]!.every((task) => task['completed'] == true)) {
      _showCongratsDialog();
    }
  }

  /// Shows a reminder dialog
  void _showReminder() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reminder'),
        content: const Text('Finish your learning tasks today!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Calculates the progress for the selected day's tasks
  void _calculateGoalProgress() {
    String key = _formatDate(_selectedDay);
    if (!_tasksByDate.containsKey(key)) {
      _goalProgress = 0.0;
      return;
    }
    int total = _tasksByDate[key]!.length;
    int completed =
        _tasksByDate[key]!.where((t) => t['completed'] == true).length;
    _goalProgress = total == 0 ? 0 : completed / total;
  }

  /// Shows a congratulatory dialog when all tasks are completed
  void _showCongratsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Great job! 🎉'),
        content: const Text('You have completed all tasks for today!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Thanks'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String selectedKey = _formatDate(_selectedDay);
    List<Map<String, dynamic>> todayTasks = _tasksByDate[selectedKey] ?? [];

    // Always show default tasks if no tasks exist for the day
    if (todayTasks.isEmpty) {
      todayTasks = _defaultTasks
          .map((e) => {'title': e['title']!, 'completed': false})
          .toList();
      _tasksByDate[selectedKey] = todayTasks;
      _saveTasks();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lesson Planner',
          style: TextStyle(
            fontFamily: 'AlfaSlabOne',
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: themePrimary,
        elevation: 4,
        actions: [
          IconButton(
            tooltip: 'Show Reminder',
            icon: const Icon(Icons.alarm, color: Colors.white),
            onPressed: _showReminder,
          )
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with blur
          Image.asset(
            'assets/rocket.jpg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              color: Colors.black.withAlpha((0.2 * 255).toInt()),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        // Calendar Card
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          color: themeBackground.withAlpha((0.9 * 255).toInt()),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TableCalendar(
                              firstDay: DateTime.utc(2020, 1, 1),
                              lastDay: DateTime.utc(2100, 12, 31),
                              focusedDay: _focusedDay,
                              selectedDayPredicate: (day) =>
                                  isSameDay(day, _selectedDay),
                              onDaySelected: _onDaySelected,
                              calendarStyle: CalendarStyle(
                                todayDecoration: BoxDecoration(
                                  color: themePrimary,
                                  shape: BoxShape.circle,
                                ),
                                selectedDecoration: BoxDecoration(
                                  color: themePrimary,
                                  shape: BoxShape.circle,
                                ),
                                markerDecoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                weekendTextStyle: TextStyle(
                                  color: themeAccent,
                                  fontFamily: 'AlfaSlabOne',
                                ),
                                defaultTextStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'AlfaSlabOne',
                                ),
                              ),
                              headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'AlfaSlabOne',
                                  color: themeAccent,
                                ),
                                leftChevronIcon: Icon(
                                  Icons.chevron_left,
                                  color: themePrimary,
                                ),
                                rightChevronIcon: Icon(
                                  Icons.chevron_right,
                                  color: themePrimary,
                                ),
                              ),
                              daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle: TextStyle(
                                  fontFamily: 'AlfaSlabOne',
                                  fontWeight: FontWeight.bold,
                                  color: themeAccent,
                                  fontSize: 14,
                                ),
                                weekendStyle: TextStyle(
                                  fontFamily: 'AlfaSlabOne',
                                  fontWeight: FontWeight.bold,
                                  color: themeAccent,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Progress Bar Card
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 5,
                          color: themeBackground.withAlpha((0.9 * 255).toInt()),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: themePrimary, size: 28),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: _goalProgress,
                                      backgroundColor: Colors.grey.shade300,
                                      color: themePrimary,
                                      minHeight: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "${(_goalProgress * 100).toInt()}%",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: 'AlfaSlabOne',
                                    color: themeAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Task List Card
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                            color: themeBackground.withAlpha((0.9 * 255).toInt()),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'AlfaSlabOne',
                                      ),
                                    ),
                                    value: task['completed'] as bool,
                                    onChanged: (val) {
                                      _toggleTaskCompleted(index);
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    activeColor: Colors.green,
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
