import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';
import '../services/geo_location_services.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
     // Optional: You can pre-fetch location here if needed
     // await LocationService().getCurrentPosition();
    
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlueAccent],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  'https://img.freepik.com/premium-vector/vector-isolated-weather-app-icon-with-sunny-rainy-cloud-interface-elements-flat-design-web_1071100-325.jpg',
                  width: 150, // desired width
                  height: 150, // desired height
                  fit: BoxFit.cover, // makes the image cover the whole circle
                ),
              ),


              const SizedBox(height: 20),
              Text(
                "SkyCast",
                style: AppTextStyles.primaryStyle().copyWith(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
               const SizedBox(height: 10),
               const CircularProgressIndicator(
                 color: Colors.white,
               )
            ],
          ),
        ),
      ),
    );
  }
}
