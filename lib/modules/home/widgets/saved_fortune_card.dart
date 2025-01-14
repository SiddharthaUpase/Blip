import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../controllers/home_controller.dart';

class SavedFortuneCard extends StatelessWidget {
  final Map<String, dynamic> fortune;
  final int index;
  final HomeController controller;

  const SavedFortuneCard({
    Key? key,
    required this.fortune,
    required this.index,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final predictions = List<String>.from(fortune['predictions']);
    final date = DateTime.parse(fortune['date']);
    final formattedDate = '${date.day}/${date.month}/${date.year}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFF2C1810),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and delete button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.crimsonText(
                    fontSize: 16,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFD4AF37),
                  ),
                  onPressed: () {
                    Get.dialog(
                      Dialog(
                        backgroundColor: const Color(0xFF2C1810),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: Color(0xFFD4AF37),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Delete Fortune?',
                                style: GoogleFonts.cinzelDecorative(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFD4AF37),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'This action cannot be undone.',
                                style: GoogleFonts.crimsonText(
                                  fontSize: 16,
                                  color: const Color(0xFFD4AF37),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text(
                                      'Cancel',
                                      style: GoogleFonts.crimsonText(
                                        fontSize: 16,
                                        color: const Color(0xFFD4AF37),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.deleteFortune(index);
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD4AF37),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Delete',
                                      style: GoogleFonts.crimsonText(
                                        fontSize: 16,
                                        color: const Color(0xFF2C1810),
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
              ],
            ),
          ),
          // Image if available
          if (fortune['image'] != null && fortune['image'].isNotEmpty)
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD4AF37), width: 1),
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: FileImage(File(fortune['image'])),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          // Predictions
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: predictions.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  predictions[index],
                  style: GoogleFonts.crimsonText(
                    fontSize: 16,
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
