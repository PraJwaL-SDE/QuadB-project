import 'package:flutter/material.dart';
import 'package:quadb_tech_assignment/pages/bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      // Replace with your next screen, for example, HomeScreen()
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNavBar()), // Change this to your home screen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Set background color to yellow
      body: Center(
        child: Image.asset(
          'assets/QBT_Logo_Black.png', // Path to your logo image
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
