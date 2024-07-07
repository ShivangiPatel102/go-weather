import 'package:flutter/material.dart';
import 'package:go_weather/providers/location_data.dart';
import 'package:go_weather/providers/weather_data.dart';
import 'package:go_weather/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherData>(create: (_) => WeatherData()),
        ChangeNotifierProvider<LocationData>(create: (_) => LocationData()),
        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
        
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:  const HomeScreen(),
      ),
    );
  }
}
