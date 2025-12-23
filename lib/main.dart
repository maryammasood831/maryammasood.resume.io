import 'package:SkyCast/screens/splash_screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_application_1/screens/splash_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('search_history');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        // '/home': (context) => HomeScreen(),
      },
    );
  }
}
