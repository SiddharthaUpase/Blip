import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/streaming_fortune_card.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0F0F),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Mystic Vision 🔮',
                style: GoogleFonts.cinzelDecorative(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37),
                ),
              ),
            ),

            // Image Preview
            Obx(() => controller.selectedImagePath.isNotEmpty
                ? Container(
                    height: 200,
                    width: 200,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFFD4AF37), width: 2),
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image:
                            FileImage(File(controller.selectedImagePath.value)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const SizedBox.shrink()),

            // Loading Message
            Obx(() => controller.isAnalyzing.value
                ? Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.loadingMessage.value,
                        style: GoogleFonts.crimsonText(
                          fontSize: 18,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink()),

            // Fortune Predictions
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: controller.fortunePredictions.length,
                    itemBuilder: (context, index) {
                      return StreamingFortuneCard(
                        prediction: controller.fortunePredictions[index],
                        index: index,
                      );
                    },
                  )),
            ),

            // Capture Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: controller.showImageSourceDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Reveal Your Fortune',
                  style: GoogleFonts.cinzelDecorative(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C1810),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
