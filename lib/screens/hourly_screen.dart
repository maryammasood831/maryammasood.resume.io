import 'package:flutter/material.dart';
import '../model/weather_model.dart';
import '../constants/app_colors.dart';

class HourlyScreen extends StatelessWidget {
  final WeatherResponse weatherData;

  const HourlyScreen({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    if (weatherData.days == null || weatherData.days!.isEmpty || weatherData.days![0].hours == null) {
       return const Center(child: Text("No Hourly Data Available"));
    }

    final hours = weatherData.days![0].hours!;

    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        title: const Text("Hourly Forecast", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent, // Transparent for gradient
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false, 
      ),
      body: Container(
        decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
             colors: [
               const Color(0xFFE3F2FD), // Light Foggy Blue
               const Color(0xFFFAFAFA), // Off White
             ],
           ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: hours.length,
              itemBuilder: (context, index) {
                final hour = hours[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      // Time
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${hour.datetime?.split(":")[0]}:00",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Weather Icon
                      Icon(
                        _getWeatherIcon(hour.conditions),
                        size: 32,
                        color: _getIconColor(hour.conditions),
                      ),
                      const SizedBox(width: 16),
                      
                      // Temp & Condition
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${hour.temp?.round()}°",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
                            ),
                            Text(
                              hour.conditions ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.black54, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      
                      // Extra Detail (Wind/Precip)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                           Row(children: [
                             Icon(Icons.water_drop, size: 14, color: Colors.blue[300]),
                             Text(" ${hour.humidity?.round()}%", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                           ]),
                           const SizedBox(height: 4),
                           Row(children: [
                             Icon(Icons.air, size: 14, color: Colors.grey),
                             Text(" ${hour.windspeed?.round()} km/h", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                           ]),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return Icons.cloud;
    condition = condition.toLowerCase();
    if (condition.contains('rain')) return Icons.water_drop;
    if (condition.contains('snow')) return Icons.ac_unit;
    if (condition.contains('cloud')) return Icons.cloud;
    if (condition.contains('sun') || condition.contains('clear')) return Icons.sunny; 
    return Icons.wb_cloudy; 
  }

  Color _getIconColor(String? condition) {
    if (condition == null) return Colors.grey;
    condition = condition.toLowerCase();
    if (condition.contains('sun') || condition.contains('clear')) return Colors.orange;
    if (condition.contains('rain')) return Colors.blue;
    if (condition.contains('snow')) return Colors.lightBlue;
    return Colors.grey;
  }
}
