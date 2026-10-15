import 'package:flutter/material.dart';
class KartuMenu extends StatelessWidget {
  final IconData ikon;
  final String label;
  final VoidCallback onTap;

  const KartuMenu({
    super.key,
    required this.ikon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon, size: 36, color: warna.primary),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}