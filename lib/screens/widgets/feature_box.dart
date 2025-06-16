import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;
  final String? subtitle;

  // Pastel theme colors
  static const Color _pastelBackground = Color(0xFFFDF6F0);
  static const Color _pastelPrimary = Color(0xFF957DAD);
  static const Color _pastelSecondary = Color(0xFFFFC8DD);
  static const Color _pastelText = Color(0xFF4A4A4A);

  const FeatureBox({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.enabled = true,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = enabled
        ? [_pastelSecondary.withOpacity(0.8), _pastelPrimary.withOpacity(0.9)]
        : [Colors.grey.shade300, Colors.grey.shade400];

    final iconColor = enabled ? _pastelPrimary : Colors.grey.shade600;
    final textColor = enabled ? _pastelText : Colors.grey.shade600;
    final borderColor = enabled ? _pastelPrimary.withOpacity(0.6) : Colors.grey.shade500;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: _pastelPrimary.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(2, 6),
                  ),
                ]
              : null,
          color: _pastelBackground,
        ),
        child: CustomPaint(
          painter: _PatternPainter(enabled: enabled),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 38, color: iconColor),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  final bool enabled;

  _PatternPainter({this.enabled = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (enabled ? Colors.white.withOpacity(0.10) : Colors.grey.withOpacity(0.08))
      ..strokeWidth = 1.2;

    for (double i = -size.height; i < size.width; i += 18) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
    // Add a subtle circle pattern
    if (enabled) {
      final circlePaint = Paint()
        ..color = Colors.white.withOpacity(0.08)
        ..style = PaintingStyle.fill;
      for (double y = 10; y < size.height; y += 28) {
        for (double x = 10; x < size.width; x += 28) {
          canvas.drawCircle(Offset(x, y), 4, circlePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
