import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart' as prefs;

class HomeController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final RxString selectedImagePath = ''.obs;
  final RxBool isAnalyzing = false.obs;
  final RxList<String> imageFacts = <String>[].obs;
  final RxString loadingMessage = ''.obs;
  final RxList<String> fortunePredictions = <String>[].obs;
  final List<String> loadingMessages = [
    "Reading your aura... 🔮",
    "Consulting the stars... ⭐️",
    "Aligning cosmic energies... 🌌",
    "Decoding your destiny... 🎴",
    "Channeling mystic forces... ✨",
    "Peering into your future... 🔍",
    "Interpreting celestial signs... 🌙",
    "Unfolding your fate... 🎭",
    "Connecting with spirits... 👻",
    "Drawing from ancient wisdom... 📜"
  ];

  Timer? _loadingTimer;

  // OpenAI API configuration
  static const String openAiUrl = 'https://api.openai.com/v1/chat/completions';
  static String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

  final RxList<Map<String, dynamic>> savedFortunes =
      <Map<String, dynamic>>[].obs;
  late final prefs.SharedPreferences _prefs;

  @override
  void onInit() async {
    super.onInit();
    // Initialize SharedPreferences
    _prefs = await prefs.SharedPreferences.getInstance();
    _loadSavedFortunes();
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
      _startLoadingAnimation();
      fortunePredictions.clear();

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
                      '''Act as a mystical fortune teller and analyze this person's image. 
                  Provide 3 intriguing predictions about their future in these areas:
                  1. Career/Life Purpose
                  2. Relationships/Love Life
                  3. Personal Growth/Success
                  
                  Make the predictions mysterious, specific yet open to interpretation, and positive.
                  Include mystical elements and timing (seasons, celestial events, etc.).
                  Return in JSON format: {"predictions": ["prediction1", "prediction2", "prediction3"]}.
                  Keep each prediction under 40 words.'''
                },
                {
                  'type': 'image_url',
                  'image_url': {'url': 'data:image/jpeg;base64,$base64Image'}
                }
              ]
            }
          ],
          'max_tokens': 500,
          'temperature': 0.8
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String jsonString = data['choices'][0]['message']['content'];
        print('Response: ${jsonString}');

        // Clean up the JSON string by removing the markdown code block markers
        jsonString =
            jsonString.replaceAll('```json', '').replaceAll('```', '').trim();

        try {
          final jsonData = jsonDecode(jsonString);
          final predictions = List<String>.from(jsonData['predictions']);
          fortunePredictions.addAll(predictions);
          print('Fortune Predictions: ${fortunePredictions}');
        } catch (e) {
          throw 'Failed to parse fortune predictions: $e';
        }
      } else {
        throw 'Failed to read fortune: ${response.statusCode}';
      }
    } catch (e) {
      Get.snackbar(
          'Mystical Error', 'The spirits are unclear at this moment: $e');
    } finally {
      _stopLoadingAnimation();
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
            color: const Color(0xFF2C1810), // Dark mystical background
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: const Color(0xFFD4AF37), width: 2), // Gold border
            boxShadow: const [
              BoxShadow(
                offset: Offset(6, 6),
                color: Color(0xFFD4AF37),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'REVEAL YOUR DESTINY 🔮',
                style: GoogleFonts.cinzelDecorative(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37), // Gold text
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
                    color: const Color(0xFF8B4513), // Mystic brown
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: const Color(0xFFD4AF37), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(4, 4),
                        color: Color(0xFFD4AF37),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt,
                        color: Color(0xFFD4AF37),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'CAPTURE THE MAGIC! 📸',
                        style: GoogleFonts.cinzelDecorative(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Get.back();
                  pickImage(ImageSource.gallery);
                },
                child: Text(
                  'Choose from your past images',
                  style: GoogleFonts.cinzelDecorative(
                    fontSize: 14,
                    color: const Color(0xFFD4AF37),
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

  void _loadSavedFortunes() {
    final fortunesJson = _prefs.getStringList('saved_fortunes') ?? [];
    savedFortunes.value = fortunesJson
        .map((json) => Map<String, dynamic>.from(jsonDecode(json)))
        .toList();
  }

  Future<void> saveFortune() async {
    if (fortunePredictions.isEmpty) return;

    final fortune = {
      'date': DateTime.now().toIso8601String(),
      'image': selectedImagePath.value,
      'predictions': fortunePredictions.toList(),
    };

    savedFortunes.insert(0, fortune); // Add to beginning of list

    // Save to SharedPreferences
    final fortunesJson =
        savedFortunes.map((fortune) => jsonEncode(fortune)).toList();
    await _prefs.setStringList('saved_fortunes', fortunesJson);

    Get.snackbar(
      'Fortune Saved',
      'Your mystical reading has been preserved ✨',
      backgroundColor: const Color(0xFFD4AF37),
      colorText: const Color(0xFF2C1810),
    );
  }

  Future<void> deleteFortune(int index) async {
    savedFortunes.removeAt(index);

    // Update SharedPreferences
    final fortunesJson =
        savedFortunes.map((fortune) => jsonEncode(fortune)).toList();
    await _prefs.setStringList('saved_fortunes', fortunesJson);
  }
}
