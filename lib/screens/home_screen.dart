import 'package:flutter/material.dart';
import 'package:go_weather/constants.dart';
import 'package:go_weather/screens/weather_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
 

  @override
  void initState() {
    super.initState();
    _loadLastSearchedCity();
  }

  Future<void> _loadLastSearchedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSearchedCity = prefs.getString('lastSearchedCity');
    if (lastSearchedCity != null) {
      _controller.text = lastSearchedCity;
      setState(() {
        
      });
    }
  }

  Future<void> _saveLastSearchedCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSearchedCity', city);
  }

  void _searchWeather() {
    final city = _controller.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a city name')),
      );
      return;
    }

    final formattedCity = city[0].toUpperCase() + city.substring(1).toLowerCase();
    _saveLastSearchedCity(formattedCity);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WeatherDetailsScreen(locationWeather: formattedCity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                style: const TextStyle(
                  color: kSearchBarTextColor,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Enter City Name",
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: kSearchBarTextColor,
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed:  _searchWeather,
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontFamily: "Catamaran",
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: kButtonPositiveColor,
                  ),
                  child: const Text('Go Weather'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
