import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dog_breed.dart';
import 'classifier.dart';

class ResultScreen extends StatefulWidget {
  final File image;

  const ResultScreen({super.key, required this.image});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<Map<String, dynamic>>? _recognitions;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _classifyImage();
  }

  Future<void> _classifyImage() async {
    Classifier classifier = Classifier();
    await classifier.initialize();

    try {
      _recognitions = await classifier.classifyImage(widget.image);
      print('✅ Classification result: $_recognitions');
    } catch (e) {
      print('❌ Classification error: $e');
      _recognitions = [
        {'label': 'Error: Model or Labels not loaded', 'confidence': 0.0},
      ];
    } finally {
      classifier.dispose();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchGoogle(String query) async {
    final url = Uri.parse('https://www.google.com/search?q=$query');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    String predictedBreed =
        _recognitions != null && _recognitions!.isNotEmpty
            ? _recognitions![0]['label']
            : "Unknown";
    double confidence =
        _recognitions != null && _recognitions!.isNotEmpty
            ? (_recognitions![0]['confidence'] * 100)
            : 0.0;

    return Scaffold(
      backgroundColor: Colors.brown.shade200, // ✅ ใช้สีพื้นหลังแทนรูปภาพ
      appBar: AppBar(
        title: const Text('ผลลัพธ์'),
        backgroundColor: Colors.brown.shade600,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // ✅ ปุ่มย้อนกลับ
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(
                      widget.image,
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ✅ ขีดเส้นใต้เฉพาะชื่อพันธุ์
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                      children: [
                        const TextSpan(
                          text: '🐶 สายพันธุ์: ',
                          style: TextStyle(decoration: TextDecoration.none),
                        ),
                        TextSpan(
                          text: predictedBreed,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _searchGoogle(predictedBreed),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '📊 ความมั่นใจ: ${confidence.toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('ลักษณะนิสัย'),
                          content: Text(
                            DogBreed.getCharacteristics(predictedBreed),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('ปิด'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'ดูลักษณะนิสัย',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('วิธีการเลี้ยง'),
                          content: Text(
                            DogBreed.getCareInstructions(predictedBreed),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('ปิด'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'ดูวิธีการเลี้ยง',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
