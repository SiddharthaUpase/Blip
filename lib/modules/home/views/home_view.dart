import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/fact_card.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1DE), // Cream background
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D405B), // Dark blue
        elevation: 0,
        title: Text(
          'FACTS TELLER',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 24,
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
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
              onPressed: () {
                Get.dialog(
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F1DE),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(4, 4),
                            color: Colors.black,
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF81B29A),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(4, 4),
                                  color: Colors.black,
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Text(
                              'HEADING OUT? 👋',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Come back soon for more amazing facts!',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              color: const Color(0xFF3D405B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => Get.back(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE07A5F),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(2, 2),
                                          color: Colors.black,
                                          blurRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'STAY',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Get.back();
                                    //clear all data
                                    controller.resetStates();
                                    Get.offAllNamed(
                                        '/login'); // Or your logout logic
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3D405B),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(2, 2),
                                          color: Colors.black,
                                          blurRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'LOGOUT',
                                      style: GoogleFonts.spaceGrotesk(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isAnalyzing.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE07A5F), // Coral
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(4, 4),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 6,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF81B29A), // Sage green
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(4, 4),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    controller.loadingMessage.value,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.selectedImagePath.isEmpty &&
            controller.imageFacts.isEmpty) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE07A5F), // Coral
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(4, 4),
                          color: Colors.black,
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'DISCOVER FACTS',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                offset: Offset(3, 3),
                                color: Colors.black,
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Learn fascinating facts about anything',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.8),
                            shadows: const [
                              Shadow(
                                offset: Offset(2, 2),
                                color: Colors.black54,
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: controller.showImageSourceDialog,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF81B29A), // Sage green
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(4, 4),
                            color: Colors.black,
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'START EXPLORING',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            if (controller.selectedImagePath.isNotEmpty)
              Container(
                height: 200,
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(4, 4),
                      color: Colors.black,
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(controller.selectedImagePath.value),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Expanded(
              child: PageView.builder(
                itemCount: controller.imageFacts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FactCard(fact: controller.imageFacts[index]),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: InkWell(
                onTap: controller.showImageSourceDialog,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE07A5F), // Coral
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(4, 4),
                        color: Colors.black,
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    'TRY ANOTHER',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
