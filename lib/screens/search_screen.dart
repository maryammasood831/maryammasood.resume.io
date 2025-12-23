import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:flutter_application_1/constants/app_colors.dart';
// import 'package:flutter_application_1/constants/constants.dart';
// import 'package:flutter_application_1/model/weather_model.dart';
// import 'package:flutter_application_1/services/weaather_services.dart';

import '../constants/app_colors.dart';
import '../constants/constants.dart';
import '../model/weather_model.dart';
import '../services/weaather_services.dart';
import '../services/firestore_service.dart';

class SeacrhScreen extends StatefulWidget {
  final WeatherResponse? initialData;
  final bool showSearchBar;
  const SeacrhScreen({super.key, this.initialData, this.showSearchBar = true});

  @override
  State<SeacrhScreen> createState() => _SeacrhScreenState();
}

class _SeacrhScreenState extends State<SeacrhScreen> {
  late final TextEditingController SearchController;
  Future<WeatherResponse?>? _futureWeather;
  
  @override
  void initState() {
    super.initState();
    SearchController = TextEditingController();
    
    if (widget.initialData != null) {
      _futureWeather = Future.value(widget.initialData);
      
      // Also pre-fill the search text if possible, e.g. from the address
      if (widget.initialData!.address != null) {
         // The address might be full "London, UK", let's just use it as is.
         SearchController.text = widget.initialData!.address!;
      }
    }
  }
  
  @override
  void dispose() {
    SearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Search Weather for a city",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        bottom: widget.showSearchBar ? PreferredSize(
          preferredSize: Size(double.infinity, 50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: SearchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                iconColor: Colors.black,
                hintText: "Enter you city name",
                  suffix: IconButton(
                    iconSize: 25,
                    onPressed: () async {
                      if (SearchController.text.isEmpty) return;
                      
                      // Using setState to trigger the future builder rebuild is dependent on _futureWeather logic if we used that
                      // But here the code uses FutureBuilder with direct method call inside 'build' (bad practice generally as it refetches on rebuilds),
                      // however, the user's code structure relies on `setState` to just refresh the UI which likely re-runs `WeatherService.getWeather`
                      // if the controller text changed.
                      //
                      // Wait, examining existing code:
                      // body: FutureBuilder(future: WeatherService.getWeather(city: SearchController.text ...))
                      // So merely calling setState({}) will trigger a new fetch if text changed.
                      //
                      // BUT, to save to Hive, we need to intercept the result.
                      // The current FutureBuilder structure makes it hard to "intercept" the result without refetching.
                      //
                      // Better approach: 
                      // 1. Fetch data explicitly here.
                      // 2. If success, save to Hive -> Then setState to update UI (or simply update UI which triggers another fetch? No, that's wasteful).
                      // 
                      // Actually, the existing code has a commented out `_futureWeather` logic. Let's use that pattern for better control.
                      // But to respect "minimal changes", let's hook into the existing flow or just do a separate fetch for saving?
                      // Doing a separate fetch is bad.
                      //
                      // Best simplified fix: Get the data, save it, then let the FutureBuilder (or a better mechanism) show it.
                      // However, to keep it simple and aligned with current structure:
                      // We will change the FutureBuilder to use a future variable that we control.
                      
                      setState(() {
                         _futureWeather = WeatherService.getWeather(city: SearchController.text);
                      });
                      
                      try {
                        final data = await _futureWeather;
                        if (data != null) {
                           // Save to Hive
                           final box = Hive.box('search_history');
                           box.add({
                             'query': SearchController.text,
                             'timestamp': DateTime.now().toIso8601String(),
                             'result': data.toJson(),
                           });
                           
                           // Save to Firestore
                           await FirestoreService().saveSearch(SearchController.text, data);
                        }
                      } catch (e) {
                        // Error handling handled by FutureBuilder mostly, but we catch here to avoid crash on await
                        log("Error fetching/saving: $e");
                      }
                    },
                    icon: Icon(Icons.search, color: Colors.black),
                  ),
              ),
            ),
          ),
        ) : null,
      ),
      body: FutureBuilder(
        future: _futureWeather ?? WeatherService.getWeather(
          city: SearchController.text.toString(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            if (citiesList.isEmpty) {
              return const Center(child: Text("Please Search for a city"));
            } else {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: citiesList.length,
                itemBuilder: (context, index) {
                  final Data = citiesList[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            Data!.address ?? '',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Data.description ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Icon(
                                    Icons.thermostat_outlined,
                                    size: 30,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${Data.currentConditions!.temp}°C",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.water_drop,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${Data.currentConditions!.humidity}%",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.cloud,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    Data.currentConditions!.conditions ?? '',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }

          final data = snapshot.data;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Current Weather Card
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            data!.address ?? '',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data.description ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Icon(
                                    Icons.thermostat_outlined,
                                    size: 30,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${data.currentConditions!.temp}°C",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.water_drop,
                                    size: 30,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${data.currentConditions!.humidity}%",
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.cloud,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data.currentConditions!.conditions ?? '',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "Today's Hourly Forecast",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Hourly Forecast
                  SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.days![0].hours!.length,
                      itemBuilder: (context, index) {
                        final hour = data.days![0].hours![index];
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${hour.datetime!.split(":")[0]}:00",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Icon(
                                Icons.wb_cloudy,
                                color: Colors.grey,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text("${hour.temp}°"),
                              Text(
                                hour.conditions.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text(
                    "Upcoming Days Forecast",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Daily Forecast
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.days!.length,
                    itemBuilder: (context, index) {
                      final dayData = data.days![index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text(dayData.datetime.toString()),
                          subtitle: Text(dayData.conditions.toString()),
                          trailing: Text(
                            "${dayData.tempmin}° / ${dayData.tempmax}°",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
