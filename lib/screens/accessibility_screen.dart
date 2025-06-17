import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  bool dyslexiaMode = false;

  double fontSize = 17.0;

  final List<String> dyslexiaFonts = ['Lexend', 'Atkinson Hyperlegible'];
  String selectedFont = 'Lexend';

  final String fontFamily = 'AlfaSlabOne';

  TextStyle getBaseTextStyle(BuildContext context) {
    final theme = Theme.of(context);
    if (!dyslexiaMode) {
      return theme.textTheme.bodyMedium!.copyWith(
        fontSize: fontSize,
        fontFamily: fontFamily,
      );
    }
    TextStyle style;
    switch (selectedFont) {
      case 'Atkinson Hyperlegible':
        style = GoogleFonts.atkinsonHyperlegible(fontSize: fontSize);
        break;
      case 'Lexend':
      default:
        style = GoogleFonts.lexend(fontSize: fontSize);
    }
    return style.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
      color: theme.textTheme.bodyMedium?.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseTextStyle = getBaseTextStyle(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Accessibility",
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'AlfaSlabOne',
            fontSize: 22,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle(
          style: baseTextStyle,
          child: ListView(
            children: [
              SwitchListTile(
                title: Text(
                  "Dyslexia Friendly-Mode",
                  style: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                value: dyslexiaMode,
                onChanged: (val) {
                  setState(() {
                    dyslexiaMode = val;
                    selectedFont = 'Lexend';
                  });
                },
                activeColor: theme.colorScheme.secondary,
              ),
              if (dyslexiaMode)
                DropdownButton<String>(
                  value: selectedFont,
                  items: dyslexiaFonts.map((font) {
                    return DropdownMenuItem(
                      value: font,
                      child: Text(font, style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => selectedFont = val);
                    }
                  },
                ),
              const SizedBox(height: 16),
              Text(
                "Text Size",
                style: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              Slider(
                min: 12,
                max: 24,
                value: fontSize,
                label: "${fontSize.toInt()}",
                divisions: 6,
                onChanged: (val) {
                  setState(() => fontSize = val);
                },
                activeColor: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 24),
              Text(
                "Sample Text",
                style: baseTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize + 3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "The quick brown fox jumps over the lazy dog.",
                style: baseTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
