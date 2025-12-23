import 'package:flutter/material.dart';
import '../services/weaather_services.dart';
import '../model/weather_model.dart';
import 'home_screen.dart';
import 'hourly_screen.dart';
import 'daily_screen.dart';
import 'graph_screen.dart'; // Import graph screen
import 'search_screen.dart'; // Import SearchScreen locally if needed or keep in Home

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Future<WeatherResponse?>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = WeatherService.getWeather();
  }
  
  void _refreshWeather() {
      setState(() {
          _weatherFuture = WeatherService.getWeather();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WeatherResponse?>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Scaffold(body: Center(child: Text("No Data Found")));
          }

          final weatherData = snapshot.data!;

          final List<Widget> screens = [
            HomeScreen(weatherData: weatherData),
            HourlyScreen(weatherData: weatherData),
            DailyScreen(weatherData: weatherData),
            HourlyGraphScreen(weatherData: weatherData),
          ];

          return screens[_currentIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures all labels are shown
        showUnselectedLabels: true,
        selectedItemColor: Colors.lightBlueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Current',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Hourly',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Daily',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Graph',
          ),
        ],
      ),
    );
  }
}
