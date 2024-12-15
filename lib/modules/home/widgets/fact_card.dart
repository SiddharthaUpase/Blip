import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FactCard extends StatelessWidget {
  final String fact;

  const FactCard({Key? key, required this.fact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4F81), // Vibrant pink
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            offset: Offset(6, 6), // Increased shadow offset
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
          color: Colors.white,
          shadows: const [
            Shadow(
              offset: Offset(2, 2),
              color: Colors.black,
              blurRadius: 0,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
