import 'package:SkyCast/screens/search_screen.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_application_1/constants/app_colors.dart';
//import 'package:flutter_application_1/screens/search_screen.dart';
//import 'package:flutter_application_1/services/weaather_services.dart';

import '../constants/app_colors.dart';
import '../services/weaather_services.dart';
import '../model/weather_model.dart';

import 'package:hive_flutter/hive_flutter.dart'; // Import Hive

class HomeScreen extends StatelessWidget {
  final WeatherResponse weatherData;

  const HomeScreen({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final data = weatherData;
    final current = data.currentConditions;

    // Parse location string
    String fullLengthAddress = data.address ?? "Unknown";
    List<String> addressParts = fullLengthAddress.split(',');
    String locationTitle = addressParts.isNotEmpty ? addressParts[0].trim() : "Unknown";
    String locationSubtitle = addressParts.length > 1 ? addressParts.sublist(1).join(',').trim() : "";

    return Scaffold(
      extendBodyBehindAppBar: true, 
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlueAccent),
              accountName: Text("SkyCast History"),
              accountEmail: Text("Your past searches"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.history, color: Colors.blue),
              ),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box('search_history').listenable(),
                builder: (context, Box box, widget) {
                  if (box.isEmpty) {
                    return const Center(child: Text("No history yet"));
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      // Get key/value in reverse order (newest first)
                      final key = box.keyAt(box.length - 1 - index);
                      final entry = box.get(key) as Map;
                      final cityName = entry['query'] as String;
                       // We can also show temp if we stored it, accessing entry['result']
                      final resultData = WeatherResponse.fromJson(Map<String, dynamic>.from(entry['result']));

                      return ListTile(
                        leading: const Icon(Icons.history_rounded),
                        title: Text(cityName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${resultData.currentConditions?.temp?.round() ?? '--'}° - ${resultData.currentConditions?.conditions ?? ''}"),
                        onTap: () {
                           // Navigate to search screen or show detail. 
                           // For now, let's close drawer and maybe show a snackbar since we are already on 'Home'.
                           // Ideally we would trigger a state update in MainScreen to show this data, but that requires lifting state up further.
                           // Given constraints, we can push a 'Detail' view or just perform a new search.
                           Navigator.pop(context); // Close drawer
                           
                           // Option: Navigate to SearchScreen pre-filled?
                           // Or simple show a dialog with stored data?
                           // User asked: "tap on any item to view the history result"
                           // Let's show a dialog for simplicity as a first step, or push a temporary detail view.
                           _showHistoryDetail(context, resultData);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                          onPressed: () {
                            box.delete(key);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        centerTitle: true,
        // Menu icon is automatically added if we have a drawer!
        // regarding "add menu icon on the left side", Scaffold does this by default if drawer is present.
        // We just need to ensure `automaticallyImplyLeading` is NOT false if we want it.
        // But previously we had it false. Let's make it true or default.
        // actually let's just remove `automaticallyImplyLeading: false` line.
        title: const Text(
          "Sky Cast App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SeacrhScreen()),
              );
            },
            icon: const Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Container(
         width: double.infinity,
         height: double.infinity,
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
         child: Stack(
           children: [
             // Decorative Glow 1 (Top Left - Sun glow)
             Positioned(
               top: -50,
               left: -50,
               child: Container(
                 width: 200,
                 height: 200,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   gradient: RadialGradient(
                     colors: [Colors.orange.withOpacity(0.3), Colors.transparent],
                   ),
                 ),
               ),
             ),
             // We will simply use blurred containers
             Positioned(
               top: 0,
               left: 0,
               child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Colors.orangeAccent.withOpacity(0.2), Colors.transparent],
                    ),
                  ),
               ),
             ),
             Positioned(
               bottom: 0,
               right: 0,
               child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Colors.blueAccent.withOpacity(0.1), Colors.transparent],
                    ),
                  ),
               ),
             ),

             SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                     const SizedBox(height: 20),
                     
                     // Location Display (Premium Glass/Shadow Box)
                     Container(

                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                       decoration: BoxDecoration(
                         color: Colors.white.withOpacity(0.9), // Slightly translucent
                         borderRadius: BorderRadius.circular(30),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withOpacity(0.05),
                             blurRadius: 20,
                             offset: const Offset(0, 8),
                           ),
                         ],
                       ),
                       child: Row(
                         mainAxisSize: MainAxisSize.min,
                         children: [
                           Icon(Icons.location_on, color: Colors.orangeAccent, size: 32), // Unified OrangeAccent
                           const SizedBox(width: 14),
                           Flexible(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   locationTitle,
                                   style: const TextStyle(
                                     fontSize: 22,
                                     fontWeight: FontWeight.w800, // Extra Bold Title
                                     color: Colors.black87,
                                     letterSpacing: -0.5,
                                   ),
                                   overflow: TextOverflow.ellipsis,
                                 ),
                                 if (locationSubtitle.isNotEmpty)
                                   Text(
                                     locationSubtitle,
                                     style: const TextStyle(
                                       fontSize: 16,
                                       color: Colors.black54,
                                       height: 1.2,
                                     ),
                                     overflow: TextOverflow.ellipsis,
                                   ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ),
                     SizedBox(height: 70,),
                     
                     Expanded(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           // Weather Icon with Glow
                           Stack(
                             alignment: Alignment.center,
                             children: [
                               ShaderMask(
                                 shaderCallback: (Rect bounds) {
                                   return const LinearGradient(
                                     colors: [Color(0xFFFFF176), // Light yellow
                                       Color(0xFFFFD740), // Yellow-orange
                                       Color(0xFFFFA000), ],
                                     begin: Alignment.topCenter,
                                     end: Alignment.bottomCenter,
                                   ).createShader(bounds);
                                 },
                                 child: const Icon(
                                   Icons.wb_sunny,
                                   size: 80,
                                   color: Color(0xFFFFD740), // Soft yellow-orange
                                 ),

                               ),
                             ],
                           ),
                           const SizedBox(height: 10),
                           
                           // Temperature
                           Text(
                             "${current?.temp?.round() ?? '--'}°",
                             style: const TextStyle(
                               fontSize: 80, // Balanced size
                               fontWeight: FontWeight.w300,
                               color: Colors.black87,
                               height: 1.0,
                               letterSpacing: -4,
                             ),
                           ),
                           
                           // Condition
                           Text(
                             current?.conditions ?? "Unknown",
                             style: const TextStyle(
                               fontSize: 28,
                               color: Colors.black54,
                               fontWeight: FontWeight.w500,
                               letterSpacing: 0.5,
                             ),
                           ),
                           
                           const SizedBox(height: 15),
                           
                           // High / Low 
                           Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.arrow_upward, size: 16, color: Colors.black54),
                                  Text(
                                    "${data.days?.first.tempmax?.round() ?? '--'}° ",
                                    style: const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.arrow_downward, size: 16, color: Colors.black54),
                                   Text(
                                    "${data.days?.first.tempmin?.round() ?? '--'}°",
                                    style: const TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                           ),
    
                           const SizedBox(height: 40),
    
                           // Extra Details Row (Styled Chips)
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               _buildDetailItem(Icons.water_drop, "${current?.humidity?.round() ?? '--'}%", "Humidity"),
                               _buildDetailItem(Icons.air, "${current?.windspeed?.round() ?? '--'} km/h", "Wind"),
                               _buildDetailItem(Icons.thermostat, "${current?.feelslike?.round() ?? '--'}°", "Feels Like"),
                             ],
                           ),
                         ],
                       ),
                     ),
    
                     const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
           ],
         ),
      ),
    );
  }
  
  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Container(
      width: 105, // Slightly wider
      padding: const EdgeInsets.symmetric(vertical: 20), // Taller
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), // Softer corners
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.lightBlueAccent, width: 2), // White border for 'pop'
      ),
      child: Column(
        children: [
          Container(
             padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(
               color: Colors.blue.shade50,
               shape: BoxShape.circle,
             ),
             child: Icon(icon, color: Colors.blueAccent, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showHistoryDetail(BuildContext context, WeatherResponse storedData) {
     // User wants a new page. Since HomeScreen is built to display WeatherResponse,
     // we can simply reuse it by pushing a new instance of it onto the stack.
     Navigator.push(
       context,
       MaterialPageRoute(
         builder: (context) => SeacrhScreen(
           initialData: storedData,
           showSearchBar: false,
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
}
