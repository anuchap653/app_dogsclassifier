import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

class Classifier {
  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isInitialized = false;

  Classifier();

  Future<void> initialize() async {
    await _loadModel();
    await _loadLabels();
    _isInitialized = _interpreter != null && _labels != null && _labels!.isNotEmpty;
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print('✅ Model loaded successfully');
    } catch (e) {
      print('❌ Failed to load model: $e');
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelsData = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsData.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      print('✅ Labels loaded: $_labels');
    } catch (e) {
      print('❌ Failed to load labels: $e');
    }
  }

  Future<List<Map<String, dynamic>>> classifyImage(File imageFile) async {
    if (!_isInitialized) {
      print('❌ Error: Model or Labels not fully initialized');
      return [{'label': 'Error: Model or Labels not loaded', 'confidence': 0.0}];
    }

    if (_interpreter == null) {
      print('❌ Error: Model not loaded');
      return [{'label': 'Error: Model not loaded', 'confidence': 0.0}];
    }
    if (_labels == null || _labels!.isEmpty) {
      print('❌ Error: Labels not loaded');
      return [{'label': 'Error: Labels not loaded', 'confidence': 0.0}];
    }

    // ✅ โหลดและตรวจสอบภาพ
    var image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) {
      print('❌ Error: Failed to decode image');
      return [{'label': 'Error: Invalid image', 'confidence': 0.0}];
    }

    print('📌 Image original size: ${image.width}x${image.height}');

    // ✅ Resize ภาพให้เป็น 224x224 (ขนาดที่โมเดลต้องการ)
    var resizedImage = img.copyResize(image, width: 224, height: 224, interpolation: img.Interpolation.cubic);
    print('📌 Resized image size: ${resizedImage.width}x${resizedImage.height}');

    // ✅ แปลงค่าพิกเซลเป็น Float32 โดยไม่ใช้ imageBytes
    var input = List.generate(224, (y) =>
      List.generate(224, (x) =>
        List.generate(3, (c) {
          var pixel = resizedImage.getPixel(x, y);
          var value = (c == 0 ? img.getRed(pixel) : (c == 1 ? img.getGreen(pixel) : img.getBlue(pixel))) / 255.0;
          return value;
        })
      )
    ).reshape([1, 224, 224, 3]);

    print('📌 Model input shape: ${_interpreter!.getInputTensor(0).shape}');
    print('📌 Model output shape: ${_interpreter!.getOutputTensor(0).shape}');

    // ✅ ตรวจสอบให้ Output Shape ตรงกับจำนวน Labels
    var output = List.filled(1 * _labels!.length, 0.0).reshape([1, _labels!.length]);

    // ✅ รันโมเดล
    _interpreter!.run(input, output);

    // ✅ แปลงผลลัพธ์และตรวจสอบ `NaN`
    var scores = (output[0] as List).map((e) => e as double).toList();
    print('📌 Model output values: $scores');

    if (scores.any((double value) => value.isNaN || value.isNegative)) {
      print('❌ Error: Model output contains NaN or negative values');
      return [{'label': 'Error: Invalid model output', 'confidence': 0.0}];
    }

    // ✅ หา Index ที่มีค่าความมั่นใจสูงสุด
    int bestIndex = scores.asMap().entries.reduce((a, b) => a.value > b.value ? a : b).key;

    print('✅ Predicted label: ${_labels![bestIndex]}, Confidence: ${scores[bestIndex]}');

    return [
      {'label': _labels![bestIndex], 'confidence': scores[bestIndex]}
    ];
  }

  void dispose() {
    _interpreter?.close();
  }
}
