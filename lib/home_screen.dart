import 'package:flutter/material.dart';
import 'analyze_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade200, // ✅ พื้นหลังสีน้ำตาลอ่อน
      appBar: AppBar(
        title: const Text('Dog Breed Classifier'),
        backgroundColor: Colors.brown.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ ไอคอนหมาตกแต่ง
            Image.asset(
              'assets/dog_icon.png', // ✅ ไอคอนสุนัข (ถ้ามี)
              height: 120,
              width: 120,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.pets,
                size: 100,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 20),
            // ✅ ข้อความต้อนรับ
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Text(
                'ยินดีต้อนรับสู่ Dog Breed Classifier\n'
                'วิเคราะห์สายพันธุ์สุนัขจากรูปภาพได้ง่ายๆ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            // ✅ ปุ่มวิเคราะห์
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AnalyzeScreen()),
                );
              },
              icon: const Icon(Icons.camera_alt, size: 24),
              label: const Text('เริ่มวิเคราะห์'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5, // ✅ เพิ่มเงาให้ปุ่ม
              ),
            ),
          ],
        ),
      ),
    );
  }
}
