import 'package:flutter/material.dart';

class SkyBackground extends StatelessWidget {
  final Widget child;
  const SkyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB3E5FC), Color(0xFFE8F5E9)],
          ),
        ),
        child: child,
      );
}

/// Original placeholder mascot. Swap the emoji for your own character art.
class Mascot extends StatelessWidget {
  final String message;
  final double size;
  const Mascot({super.key, required this.message, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF176),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFBC02D), width: 3),
          ),
          child: Text('🐥', style: TextStyle(fontSize: size * 0.55)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Color(0x22000000), blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class BigButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final IconData? icon;
  const BigButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFFFF9800),
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon), const SizedBox(width: 8)],
          Text(label),
        ],
      ),
    );
  }
}

class StarRow extends StatelessWidget {
  final int stars;
  final int max;
  final double size;
  const StarRow({super.key, required this.stars, this.max = 3, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        max,
        (i) => Icon(
          i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
          size: size,
          color: i < stars ? const Color(0xFFFFC107) : Colors.grey.shade400,
        ),
      ),
    );
  }
}
