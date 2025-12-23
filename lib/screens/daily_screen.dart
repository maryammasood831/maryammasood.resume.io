import 'package:flutter/material.dart';
import '../model/weather_model.dart';
// import '../constants/app_colors.dart'; 

class DailyScreen extends StatelessWidget {
  final WeatherResponse weatherData;

  const DailyScreen({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
      if (weatherData.days == null || weatherData.days!.isEmpty) {
       return const Center(child: Text("No Daily Data Available"));
    }

    final days = weatherData.days!;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Daily Forecast", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
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
              itemCount: days.length,
              itemBuilder: (context, index) {
                final dayData = days[index];
                return Container(
                   margin: const EdgeInsets.only(bottom: 12),
                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                   decoration: BoxDecoration(
                     color: Colors.white.withOpacity(0.9),
                     borderRadius: BorderRadius.circular(24),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.blue.withOpacity(0.06),
                         blurRadius: 12,
                         offset: const Offset(0, 4),
                       ),
                     ],
                     border: Border.all(color: Colors.white, width: 2),
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       // Date & Condition
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               dayData.datetime ?? "",
                               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                             ),
                             const SizedBox(height: 4),
                             Text(
                               dayData.conditions ?? "",
                               style: const TextStyle(color: Colors.black54, fontSize: 13),
                               maxLines: 1, 
                               overflow: TextOverflow.ellipsis,
                             ),
                             if (dayData.precipprob != null && dayData.precipprob! > 20)
                               Padding(
                                 padding: const EdgeInsets.only(top: 4.0),
                                 child: Row(
                                   children: [
                                     Icon(Icons.water_drop, size: 12, color: Colors.blueAccent),
                                     Text(" ${dayData.precipprob!.round()}% Rain", style: TextStyle(fontSize: 12, color: Colors.blueAccent)),
                                   ],
                                 ),
                               ),
                           ],
                         ),
                       ),
                       
                       // Icon
                       Icon(
                         _getWeatherIcon(dayData.conditions),
                         size: 36,
                         color: _getIconColor(dayData.conditions),
                       ),
                       const SizedBox(width: 16),
                       
                       // Temps (High / Low)
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           Text(
                             "${dayData.tempmax?.round()}°",
                             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                           ),
                           Text(
                             "${dayData.tempmin?.round()}°",
                             style: const TextStyle(fontSize: 16, color: Colors.grey),
                           ),
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
