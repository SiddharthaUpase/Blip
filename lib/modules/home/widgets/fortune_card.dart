import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FortuneCard extends StatelessWidget {
  final String fortune;

  const FortuneCard({Key? key, required this.fortune}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF7B61FF), // Vibrant purple
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(
            offset: Offset(8, 8),
            color: Colors.black,
            blurRadius: 0,
          ),
        ],
      ),
      child: Text(
        fortune,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.4,
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
