import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// CalendarScreen displays a pastel-themed monthly calendar.
/// Users can navigate months and select a date.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // Currently focused month in the calendar
  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  // Currently selected date
  DateTime? _selectedDate;

  // Pastel color palette
  final Color pastelPink = const Color(0xFFFFC1CC);
  final Color pastelBlue = const Color(0xFFA8DADC);
  final Color pastelYellow = const Color(0xFFFFF9C4);
  final Color pastelGreen = const Color(0xFFB2DFDB);

  /// Navigate to previous month
  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  /// Navigate to next month
  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  /// Returns a list of DateTime objects representing all days to display in the calendar grid,
  /// including leading/trailing days from adjacent months to fill the weeks.
  List<DateTime> _daysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysBefore = firstDay.weekday % 7; // Start from Sunday

    final totalDaysInMonth = DateTime(month.year, month.month + 1, 0).day;
    List<DateTime> days = [];

    // Add days from previous month to fill the first week
    for (int i = 0; i < daysBefore; i++) {
      days.add(firstDay.subtract(Duration(days: daysBefore - i)));
    }

    // Add days of current month
    for (int i = 0; i < totalDaysInMonth; i++) {
      days.add(DateTime(month.year, month.month, i + 1));
    }

    // Add days from next month to fill the last week
    while (days.length % 7 != 0) {
      days.add(days.last.add(const Duration(days: 1)));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = _daysInMonth(_focusedMonth);
    final monthYearLabel = DateFormat.yMMMM().format(_focusedMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Pastel Calendar"),
        backgroundColor: pastelPink,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: pastelYellow,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: pastelGreen.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(3, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Header with month label and navigation arrows
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: pastelPink),
                    onPressed: _goToPreviousMonth,
                  ),
                  Text(
                    monthYearLabel,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: pastelBlue,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, color: pastelPink),
                    onPressed: _goToNextMonth,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Weekday labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map(
                      (e) => Expanded(
                        child: Center(
                          child: Text(
                            e,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: pastelGreen,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 4),

              // Calendar grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: days.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final day = days[index];
                  final isToday = day.year == today.year &&
                      day.month == today.month &&
                      day.day == today.day;
                  final isSelected = _selectedDate != null &&
                      day.year == _selectedDate!.year &&
                      day.month == _selectedDate!.month &&
                      day.day == _selectedDate!.day;
                  final isCurrentMonth = day.month == _focusedMonth.month;

                  Color bgColor = Colors.transparent;
                  Color textColor = Colors.black;

                  if (isSelected) {
                    bgColor = const Color(0xFFFFAB76); // pastel orange
                    textColor = Colors.white;
                  } else if (isToday) {
                    bgColor = const Color(0xFFA29BFE); // pastel purple
                    textColor = Colors.white;
                  } else if (!isCurrentMonth) {
                    textColor = Colors.grey.shade400;
                  } else {
                    bgColor = pastelYellow;
                  }

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = day;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: Colors.deepOrange, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Display selected date
              if (_selectedDate != null)
                Text(
                  'Selected Date: ${DateFormat.yMMMMd().format(_selectedDate!)}',
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
