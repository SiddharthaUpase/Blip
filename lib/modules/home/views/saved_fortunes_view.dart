import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import '../widgets/saved_fortune_card.dart';

class SavedFortunesView extends GetView<HomeController> {
  const SavedFortunesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C1810),
        title: Text(
          'Saved Fortunes',
          style: GoogleFonts.cinzelDecorative(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD4AF37),
          ),
        ),
      ),
      body: Obx(
        () => controller.savedFortunes.isEmpty
            ? Center(
                child: Text(
                  'No saved fortunes yet...',
                  style: GoogleFonts.crimsonText(
                    fontSize: 18,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: controller.savedFortunes.length,
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemBuilder: (context, index) {
                  return SavedFortuneCard(
                    fortune: controller.savedFortunes[index],
                    index: index,
                    controller: controller,
                  );
                },
              ),
      ),
    );
  }
}
