import 'package:flutter/material.dart';

class FeatureBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  // Pastel theme colors
  final Color _pastelBackground = const Color(0xFFFDF6F0);
  final Color _pastelPrimary = const Color(0xFF957DAD);
  final Color _pastelSecondary = const Color(0xFFFFC8DD);
  final Color _pastelText = const Color(0xFF4A4A4A);

  const FeatureBox({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.enabled = true,
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
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: _pastelPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(2, 4),
                  ),
                ]
              : null,
          color: _pastelBackground,
        ),
        child: CustomPaint(
          painter: _PatternPainter(enabled: enabled),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 34, color: iconColor),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
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
      ..color = (enabled ? Colors.white.withOpacity(0.12) : Colors.grey.withOpacity(0.10))
      ..strokeWidth = 1.5;

    for (double i = -size.height; i < size.width; i += 15) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
