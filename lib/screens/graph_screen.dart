import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../model/weather_model.dart';


class HourlyGraphScreen extends StatefulWidget {
  final WeatherResponse weatherData;

  const HourlyGraphScreen({super.key, required this.weatherData});

  @override
  State<HourlyGraphScreen> createState() => _HourlyGraphScreenState();
}

class _HourlyGraphScreenState extends State<HourlyGraphScreen> {
  int? _selectedSpotIndex;

  @override
  Widget build(BuildContext context) {
    // Get the first day's hours (next 24 hours logic might require combining days, 
    // but for simplicity we'll use the current day's remaining hours or just the first day's 24h)
    // The model has `days![0].hours`.
    final hours = widget.weatherData.days?.first.hours ?? [];

    if (hours.isEmpty) {
      return const Center(child: Text("No hourly data available"));
    }

    // Prepare data spots
    List<FlSpot> spots = [];
    for (int i = 0; i < hours.length; i++) {
        // Use index as X, Temp as Y
        if (hours[i].temp != null) {
            spots.add(FlSpot(i.toDouble(), hours[i].temp!));
        }
    }

    // Determine min/max Y for axis scaling
    double minTemp = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 5;
    double maxTemp = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 5;

    return Scaffold(
      backgroundColor: Colors.transparent, // Assumes parent has background or we set one
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("24-Hour Temperature"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightBlueAccent,
        child: Column(
          children: [
            const SizedBox(height: 100), // Spacing for AppBar
            
            // The Graph
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 6, // Show every 6th hour
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < hours.length) {
                                // Parse time "00:00:00" -> "12 AM"
                                try {
                                    // Assuming datetime is "HH:mm:ss"
                                    String rawTime = hours[index].datetime ?? "";
                                    // Simple parse
                                    if(rawTime.length >= 5) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            rawTime.substring(0, 5), 
                                            style: const TextStyle(color: Colors.white70, fontSize: 10)
                                          ),
                                        );
                                    }
                                } catch (e) {
                                    return const Text("");
                                }
                            }
                            return const Text("");
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: (hours.length - 1).toDouble(),
                    minY: minTemp,
                    maxY: maxTemp,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: Colors.white,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (spot) => Colors.black54,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              "${spot.y.toStringAsFixed(1)}°",
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                          }).toList();
                        }
                      ),
                      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
                         if (touchResponse != null && touchResponse.lineBarSpots != null) {
                             setState(() {
                                 _selectedSpotIndex = touchResponse.lineBarSpots!.first.spotIndex;
                             });
                         }
                      },
                      handleBuiltInTouches: true,
                    ),
                  ),
                ),
              ),
            ),
            
            // Detailed Info Area
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: _selectedSpotIndex != null 
                    ? _buildDetails(hours[_selectedSpotIndex!])
                    : Center(
                        child: Text(
                          "Tap on the graph to see details",
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 16),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails(Hours hour) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
                "Time: ${hour.datetime?.substring(0,5) ?? '--'}",
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                    _detailItem(Icons.water_drop, "Humidity", "${hour.humidity}%"),
                    _detailItem(Icons.air, "Wind", "${hour.windspeed} km/h"),
                    // Icon for day/night can be inferred from time or data if available
                    _detailItem(Icons.thermostat, "Feels Like", "${hour.feelslike}°"),
                ],
            ),
        ],
    );
  }
  
  Widget _detailItem(IconData icon, String label, String value) {
      return Column(
          children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
      );
  }
}
