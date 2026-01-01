import 'package:flutter/material.dart';
import '../../core/styles.dart';

class PrimaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const PrimaryActionButton({Key? key, required this.icon, required this.label, required this.color, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ),
      style: AppStyles.largeRoundedButton.copyWith(backgroundColor: MaterialStateProperty.all(color), foregroundColor: MaterialStateProperty.all(Colors.white)),
    );
  }
}
