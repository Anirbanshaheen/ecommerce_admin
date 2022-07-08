import 'package:flutter/material.dart';

class DashboardButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  const DashboardButton({required this.label, this.color = Colors.black54, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8),
        alignment: Alignment.center,
        child: Text(label, style: const TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 16),),
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8)
        ),
      ),
    );
  }
}
