import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FactCard extends StatelessWidget {
  final String fact;
  final List<Color> cardColors = const [
    Color(0xFFFFE566), // Yellow
    Color(0xFFFF69B4), // Pink
    Color(0xFF40E0D0), // Turquoise
  ];

  const FactCard({Key? key, required this.fact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColors[fact.hashCode %
            cardColors.length], // Rotate colors based on fact content
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            offset: Offset(4, 4),
            color: Colors.black,
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        fact,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed to black for better contrast
          shadows: const [
            Shadow(
              offset: Offset(2, 2),
              color: Colors.black26,
              blurRadius: 0,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
