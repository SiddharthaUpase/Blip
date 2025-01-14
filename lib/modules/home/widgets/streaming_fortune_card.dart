import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StreamingFortuneCard extends StatelessWidget {
  final String prediction;
  final int index;

  const StreamingFortuneCard({
    Key? key,
    required this.prediction,
    required this.index,
  }) : super(key: key);

  String _getCategoryTitle(int index) {
    switch (index) {
      case 0:
        return '🌟 Career & Life Purpose';
      case 1:
        return '💝 Love & Relationships';
      case 2:
        return '🌱 Personal Growth';
      default:
        return 'Mystic Vision';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2C1810),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37), width: 2),
        boxShadow: const [
          BoxShadow(
            offset: Offset(4, 4),
            color: Color(0xFFD4AF37),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFD4AF37),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Text(
              _getCategoryTitle(index),
              style: GoogleFonts.cinzelDecorative(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2C1810),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              prediction,
              style: GoogleFonts.crimsonText(
                fontSize: 18,
                color: const Color(0xFFD4AF37),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
