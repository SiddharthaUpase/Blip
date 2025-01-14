import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import '../widgets/streaming_fortune_card.dart';
import 'dart:io';

class SavedFortunesView extends GetView<HomeController> {
  const SavedFortunesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C1810),
        title: Text(
          'Mystic Archive 📜',
          style: GoogleFonts.cinzelDecorative(
            color: const Color(0xFFD4AF37),
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Obx(() => controller.savedFortunes.isEmpty
          ? Center(
              child: Text(
                'No fortunes saved yet...\nYour destiny awaits ✨',
                textAlign: TextAlign.center,
                style: GoogleFonts.crimsonText(
                  fontSize: 18,
                  color: const Color(0xFFD4AF37),
                ),
              ),
            )
          : ListView.builder(
              itemCount: controller.savedFortunes.length,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (context, fortuneIndex) {
                final fortune = controller.savedFortunes[fortuneIndex];
                final date = DateTime.parse(fortune['date']);

                return Dismissible(
                  key: Key(fortune['date']),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => controller.deleteFortune(fortuneIndex),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: GoogleFonts.crimsonText(
                            color: const Color(0xFFD4AF37),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (fortune['image'].isNotEmpty)
                        Container(
                          height: 200,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            image: DecorationImage(
                              image: FileImage(File(fortune['image'])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ...List.generate(
                        fortune['predictions'].length,
                        (index) => StreamingFortuneCard(
                          prediction: fortune['predictions'][index],
                          index: index,
                        ),
                      ),
                      const Divider(color: Color(0xFFD4AF37)),
                    ],
                  ),
                );
              },
            )),
    );
  }
}
