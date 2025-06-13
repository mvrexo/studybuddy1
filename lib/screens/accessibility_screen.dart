import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  bool dyslexiaMode = false;
  bool highContrastMode = false;
  String selectedColorBlindMode = 'None';

  double fontSize = 17.0;

  final List<String> dyslexiaFonts = ['Lexend', 'Atkinson Hyperlegible'];
  String selectedFont = 'Lexend';

  TextStyle get baseTextStyle {
    if (!dyslexiaMode) {
      return TextStyle(
        fontSize: fontSize,
        color: textColor,
        letterSpacing: 0.5,
        fontWeight: FontWeight.normal,
      );
    }

    TextStyle style;
    switch (selectedFont) {
      case 'Atkinson Hyperlegible':
        style = GoogleFonts.lexend(fontSize: fontSize);
        break;
      case 'Lexend':
      default:
        style = GoogleFonts.lexend(fontSize: fontSize);
    }
    return style.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
      color: textColor,
    );
  }

  Color get backgroundColor {
    return highContrastMode ? Colors.black : Colors.white;
  }

  Color get textColor {
    return highContrastMode ? Colors.yellowAccent : Colors.black87;
  }

  Color get switchColor {
    return highContrastMode ? Colors.amber : Colors.orange[300]!;
  }

  Color get dropdownColor {
    return highContrastMode ? Colors.grey[900]! : Colors.white;
  }

  Color get iconColor {
    return highContrastMode ? Colors.yellow : Colors.black;
  }

  ThemeData applyColorBlindFilter() {
    final baseTheme = highContrastMode ? ThemeData.dark() : ThemeData.light();

    switch (selectedColorBlindMode) {
      case 'Protanopia':
        return baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: Colors.teal,
            secondary: Colors.orange,
          ),
          scaffoldBackgroundColor: backgroundColor,
          textTheme: baseTheme.textTheme.apply(
            bodyColor: textColor,
            displayColor: textColor,
          ),
          appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: highContrastMode ? Colors.black : Colors.orange[300],
            iconTheme: IconThemeData(color: textColor),
            titleTextStyle: baseTextStyle.copyWith(color: textColor),
          ), checkboxTheme: CheckboxThemeData(
 fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.teal; }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.teal; }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.teal; }
 return null;
 }),
 trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.teal; }
 return null;
 }),
 ),
        );
      case 'Deuteranopia':
        return baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: Colors.indigo,
            secondary: Colors.amber,
          ),
          scaffoldBackgroundColor: backgroundColor,
          textTheme: baseTheme.textTheme.apply(
            bodyColor: textColor,
            displayColor: textColor,
          ),
          appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: highContrastMode ? Colors.black : Colors.orange[300],
            iconTheme: IconThemeData(color: textColor),
            titleTextStyle: baseTextStyle.copyWith(color: textColor),
          ), checkboxTheme: CheckboxThemeData(
 fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.indigo; }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.indigo; }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.indigo; }
 return null;
 }),
 trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.indigo; }
 return null;
 }),
 ),
        );
      case 'Tritanopia':
        return baseTheme.copyWith(
          colorScheme: baseTheme.colorScheme.copyWith(
            primary: Colors.deepPurple,
            secondary: Colors.greenAccent,
          ),
          scaffoldBackgroundColor: backgroundColor,
          textTheme: baseTheme.textTheme.apply(
            bodyColor: textColor,
            displayColor: textColor,
          ),
          appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: highContrastMode ? Colors.black : Colors.orange[300],
            iconTheme: IconThemeData(color: textColor),
            titleTextStyle: baseTextStyle.copyWith(color: textColor),
          ), checkboxTheme: CheckboxThemeData(
 fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.deepPurple; }
 return null;
 }),
 ), radioTheme: RadioThemeData(
 fillColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.deepPurple; }
 return null;
 }),
 ), switchTheme: SwitchThemeData(
 thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.deepPurple; }
 return null;
 }),
 trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
 if (states.contains(WidgetState.disabled)) { return null; }
 if (states.contains(WidgetState.selected)) { return Colors.deepPurple; }
 return null;
 }),
 ),
        );
      default:
        return baseTheme.copyWith(
          scaffoldBackgroundColor: backgroundColor,
          textTheme: baseTheme.textTheme.apply(
            bodyColor: textColor,
            displayColor: textColor,
          ),
          appBarTheme: baseTheme.appBarTheme.copyWith(
            backgroundColor: highContrastMode ? Colors.black : Colors.orange[300],
            iconTheme: IconThemeData(color: textColor),
            titleTextStyle: baseTextStyle.copyWith(color: textColor),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = applyColorBlindFilter();

    return Theme(
      data: themeData,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text("Accessibility Settings", style: baseTextStyle),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: DefaultTextStyle(
            style: baseTextStyle,
            child: ListView(
              children: [
                SwitchListTile(
                  title: Text("Dyslexia Friendly-Mode",
                      style: baseTextStyle.copyWith(fontWeight: FontWeight.bold)),
                  value: dyslexiaMode,
                  onChanged: (val) {
                    setState(() {
                      dyslexiaMode = val;
                      selectedFont = 'Lexend'; // reset font when toggle
                    });
                  },
                  activeColor: switchColor,
                ),
                if (dyslexiaMode)
                  DropdownButton<String>(
                    value: selectedFont,
                    dropdownColor: dropdownColor,
                    iconEnabledColor: iconColor,
                    items: dyslexiaFonts.map((font) {
                      return DropdownMenuItem(
                        value: font,
                        child: Text(font, style: TextStyle(color: textColor)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => selectedFont = val);
                      }
                    },
                  ),
                const SizedBox(height: 16),
                Text("Text Size",
                    style: baseTextStyle.copyWith(fontWeight: FontWeight.bold)),
                Slider(
                  min: 12,
                  max: 24,
                  value: fontSize,
                  label: "${fontSize.toInt()}",
                  divisions: 6,
                  onChanged: (val) {
                    setState(() => fontSize = val);
                  },
                  activeColor: switchColor,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text("High Contrast Mode",
                      style: baseTextStyle.copyWith(fontWeight: FontWeight.bold)),
                  value: highContrastMode,
                  onChanged: (val) {
                    setState(() => highContrastMode = val);
                  },
                  activeColor: switchColor,
                ),
                const SizedBox(height: 16),
                Text("Color Blind Mode",
                    style: baseTextStyle.copyWith(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedColorBlindMode,
                  dropdownColor: dropdownColor,
                  iconEnabledColor: iconColor,
                  items: ['None', 'Protanopia', 'Deuteranopia', 'Tritanopia']
                      .map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type, style: TextStyle(color: textColor)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedColorBlindMode = val);
                  },
                ),
                const SizedBox(height: 24),
                Text("Sample Text",
                    style: baseTextStyle.copyWith(
                        fontWeight: FontWeight.bold, fontSize: fontSize + 3)),
                const SizedBox(height: 10),
                Text("The quick brown fox jumps over the lazy dog.",
                    style: baseTextStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
