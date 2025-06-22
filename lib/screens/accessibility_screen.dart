import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AccessibilityScreen allows users to adjust text size and enable dyslexia-friendly fonts.
class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  // Whether dyslexia-friendly mode is enabled
  bool dyslexiaMode = false;

  // Current font size
  double fontSize = 17.0;

  // List of dyslexia-friendly fonts
  final List<String> dyslexiaFonts = ['Lexend', 'Atkinson Hyperlegible'];

  // Currently selected dyslexia-friendly font
  String selectedFont = 'Lexend';

  // Default font family for non-dyslexia mode
  final String fontFamily = 'AlfaSlabOne';

  /// Returns the base text style depending on the current settings.
  TextStyle getBaseTextStyle(BuildContext context) {
    final theme = Theme.of(context);

    if (!dyslexiaMode) {
      // Use default font when dyslexia mode is off
      return theme.textTheme.bodyMedium!.copyWith(
        fontSize: fontSize,
        fontFamily: fontFamily,
      );
    }

    // Use selected dyslexia-friendly font
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
              // Dyslexia Mode Switch
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

              // Font selection dropdown (only visible in dyslexia mode)
              if (dyslexiaMode)
                DropdownButton<String>(
                  value: selectedFont,
                  items: dyslexiaFonts.map((font) {
                    return DropdownMenuItem(
                      value: font,
                      child: Text(
                        font,
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => selectedFont = val);
                    }
                  },
                ),

              const SizedBox(height: 16),

              // Text size label
              Text(
                "Text Size",
                style: baseTextStyle.copyWith(fontWeight: FontWeight.bold),
              ),

              // Font size slider
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

              // Sample text label
              Text(
                "Sample Text",
                style: baseTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize + 3,
                ),
              ),

              const SizedBox(height: 10),

              // Sample text
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
