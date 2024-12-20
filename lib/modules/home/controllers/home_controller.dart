import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final RxString selectedImagePath = ''.obs;
  final RxBool isAnalyzing = false.obs;
  final RxList<String> imageFacts = <String>[].obs;
  final RxString loadingMessage = ''.obs;
  final List<String> loadingMessages = [
    "Cooking up facts... 🧪",
    "Extracting knowledge... 🍜",
    "Teaching AI your image... 🎨",
    "Diving into the facts... 🌊",
    "Brewing some facts... ☕️",
    "Sprinkling wisdom... ✨",
    "Fact-checking... 🌍",
    "Converting pixels... 💭",
    "Making facts juicy... 🍊",
    "Stirring knowledge... 🥘"
  ];

  Timer? _loadingTimer;

  // OpenAI API configuration
  static const String openAiUrl = 'https://api.openai.com/v1/chat/completions';
  static String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  @override
  void onInit() {
    super.onInit();
    // Reset all states when controller is initialized
    selectedImagePath.value = '';
    imageFacts.clear();
    isAnalyzing.value = false;
    loadingMessage.value = '';
    _loadingTimer?.cancel();
  }

  @override
  void onClose() {
    _loadingTimer?.cancel();
    super.onClose();
  }

  //creaet a method to reset all states
  void resetStates() {
    selectedImagePath.value = '';
    imageFacts.clear();
    isAnalyzing.value = false;
    loadingMessage.value = '';
    _loadingTimer?.cancel();
  }

  void _startLoadingAnimation() {
    int messageIndex = 0;
    loadingMessage.value = loadingMessages[0];

    _loadingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      messageIndex = (messageIndex + 1) % loadingMessages.length;
      loadingMessage.value = loadingMessages[messageIndex];
    });
  }

  void _stopLoadingAnimation() {
    _loadingTimer?.cancel();
    loadingMessage.value = '';
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        selectedImagePath.value = image.path;
        await analyzeImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  Future<void> analyzeImage(File imageFile) async {
    if (selectedImagePath.isEmpty) {
      Get.snackbar('Error', 'No image selected.');
      return;
    }

    try {
      isAnalyzing.value = true;
      _startLoadingAnimation(); // Start the loading animation
      imageFacts.clear();

      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(openAiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text':
                      'Identify the prominent object in the image and deliver 3 mind-blowing, fascinating, and little-known facts about it. Each fact should be scientifically accurate, surprising, and leave the user in awe—like an unbelievable yet true trivia gem. Return the response in strict JSON format: {"facts": ["Fact 1", "Fact 2", "Fact 3"]}. Avoid basic or obvious information—focus on rare, jaw-dropping insights that are sure to captivate. The facts should have metric units and quantities and dates. Do not exceed more than 30 words per fact. STRICTLY KEEP THE FACTS IN THE JSON FORMAT.STRICTLY KEEP THE WORD LIMIT TO MAXIMUM 30 WORDS PER FACT. You can also put more emphasis on getting historical facts and scientific facts.'
                },
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
                }
              ]
            }
          ],
          'max_tokens': 300,
          'temperature': 0.7
        }),
      );

      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String jsonString = data['choices'][0]['message']['content'];

        // Remove the ```json prefix and ``` suffix if present
        if (jsonString.startsWith('```json')) {
          jsonString = jsonString.substring(7); // Remove ```json
          jsonString = jsonString.substring(
              0, jsonString.lastIndexOf('```')); // Remove trailing ```
        }

        // Parse the cleaned JSON string
        final jsonData = jsonDecode(jsonString.trim());
        final facts = List<String>.from(jsonData['facts']);
        imageFacts.addAll(facts);
      } else {
        throw 'Failed to analyze image: ${response.statusCode}';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to analyze image: $e');
    } finally {
      _stopLoadingAnimation(); // Stop the loading animation
      isAnalyzing.value = false;
    }
  }

  void showImageSourceDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F1DE), // Cream background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: const [
              BoxShadow(
                offset: Offset(6, 6),
                color: Colors.black,
                blurRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CAPTURE THE MAGIC! 📸',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Camera Option (More Prominent)
              InkWell(
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.camera);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4F81), // Matching card color
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 2),
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
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'TAKE PHOTO',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Gallery Option (Less Prominent)
              TextButton(
                onPressed: () {
                  Get.back();
                  pickImage(ImageSource.gallery);
                },
                child: Text(
                  'or choose from gallery',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
