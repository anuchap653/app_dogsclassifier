import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'result_screen.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;

  // ฟังก์ชันขอ permission และถ่ายรูป
  Future getImageFromCamera() async {
    setState(() => _isLoading = true);
    var cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = pickedFile != null ? File(pickedFile.path) : null;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาอนุญาตให้ใช้กล้อง')),
      );
    }
  }

  // ฟังก์ชันขอ permission และเลือกรูป
  Future getImageFromGallery() async {
    setState(() => _isLoading = true);

    PermissionStatus storageStatus;
    if (Platform.isAndroid) {
      int androidVersion = await _getAndroidVersion();
      storageStatus = androidVersion >= 33
          ? await Permission.photos.request()
          : await Permission.storage.request();
    } else {
      storageStatus = await Permission.photos.request();
    }

    if (storageStatus.isGranted) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = pickedFile != null ? File(pickedFile.path) : null;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(storageStatus.isPermanentlyDenied
              ? 'กรุณาอนุญาตการเข้าถึงรูปภาพในตั้งค่า'
              : 'กรุณาอนุญาตให้เข้าถึงแกลเลอรี่'),
          action: storageStatus.isPermanentlyDenied
              ? SnackBarAction(label: 'ตั้งค่า', onPressed: openAppSettings)
              : null,
        ),
      );
    }
  }

  // ฟังก์ชันตรวจสอบ Android version
  Future<int> _getAndroidVersion() async {
    if (Platform.isAndroid) {
      var version = await DeviceInfoPlugin().androidInfo;
      return version.version.sdkInt;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade200, // ✅ เปลี่ยนพื้นหลังเป็นสีน้ำตาลอ่อน
      appBar: AppBar(
        title: const Text('วิเคราะห์สายพันธุ์สุนัข'),
        backgroundColor: Colors.brown.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ ข้อความอธิบาย
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Text(
                'ถ่ายรูปหรือเลือกรูปภาพของสุนัขเพื่อวิเคราะห์สายพันธุ์',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // ✅ ปุ่มถ่ายรูป (ตัวอักษรสีขาว)
            ElevatedButton.icon(
              onPressed: _isLoading ? null : getImageFromCamera,
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text(
                'ถ่ายรูป',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
              ),
            ),
            const SizedBox(height: 15),

            // ✅ ปุ่มเลือกรูปภาพ (ตัวอักษรสีขาว)
            ElevatedButton.icon(
              onPressed: _isLoading ? null : getImageFromGallery,
              icon: const Icon(Icons.photo_library, color: Colors.white),
              label: const Text(
                'เลือกรูปภาพ',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
              ),
            ),
            const SizedBox(height: 30),

            // ✅ แสดง Loading ขณะกำลังประมวลผล
            if (_isLoading)
              const CircularProgressIndicator()
            // ✅ แสดงรูปภาพที่เลือก
            else if (_image != null) ...[
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    _image!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ✅ ปุ่มจำแนกพันธุ์ (ตัวอักษรสีขาว)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(image: _image!),
                    ),
                  );
                },
                child: const Text(
                  'จำแนกพันธุ์',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
