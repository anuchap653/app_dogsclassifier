import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const DogBreedClassifierApp());
}

class DogBreedClassifierApp extends StatelessWidget {
  const DogBreedClassifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Breed Classifier',
      theme: ThemeData(
        primarySwatch: Colors.brown, // ใช้ธีมโทนสีน้ำตาล
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // ✅ เปลี่ยนหน้าเริ่มต้นเป็น SplashScreen
    );
  }
}

// ✅ หน้า Splash Screen (รอ 3 วินาที แล้วเปลี่ยนไป HomeScreen)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ รอ 3 วินาที แล้วเปลี่ยนไป HomeScreen
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade200, // ✅ ใช้พื้นหลังสีน้ำตาล
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ โลโก้หรือไอคอน
            Image.asset(
              'assets/dog_icon.png', // ✅ ใช้ไอคอนหมา (ถ้ามี)
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
            const Text(
              "Dog Breed Classifier",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
