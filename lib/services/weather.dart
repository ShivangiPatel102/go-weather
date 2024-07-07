import 'package:flutter/material.dart';
import 'package:go_weather/api_key.dart';
import 'package:go_weather/providers/location_data.dart';
import 'package:go_weather/providers/weather_data.dart';
import 'package:go_weather/services/networking.dart';
import 'package:provider/provider.dart';



const apiKeyForTH = apiKeyOW;
const openWeatherMap = 'https://api.openweathermap.org/data/2.5/weather';
const weatherapi = 'http://api.weatherapi.com/v1/current.json';

class WeatherModel {
  //Getting Weather Data by City Name
  Future<dynamic> getCityWeather(String cityName) async{
    NetworkHelper networkHelper = NetworkHelper(url:'$openWeatherMap?q=$cityName&appid=$apiKeyForTH&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }
Future<bool> setWeatherParameters(BuildContext context, {required String cityNamee}) async {
    try {
      var weatherData = await getCityWeather(cityNamee);
      dynamic temp = weatherData['main']['temp'];
      int temperature = temp.toInt();
      dynamic humid = weatherData['main']['humidity'];
      int humidity = humid.toInt();
      dynamic wind = weatherData['wind']['speed'];
      int wind2 = wind.toInt();
      String cityName = weatherData['name'];
      var condition = weatherData['weather'][0]['main'];
      String cond = condition;
      var conditionId = weatherData['weather'][0]['id'];

      // Setting the weather data in providers
      final weatherDataTemp = Provider.of<WeatherData>(context, listen: false);
      final locationData = Provider.of<LocationData>(context, listen: false);
      weatherDataTemp.setHumidity(humidity);
      weatherDataTemp.setWind(wind2);
      weatherDataTemp.setCondition(cond);
      locationData.setLocation(cityName);
      weatherDataTemp.setTemperature(temperature);
      weatherDataTemp.setCondition_Id(conditionId);

    return true;
    } catch (e) {
       String errorMessage = 'Failed to fetch weather data';
      
      if (e is WeatherException) {
        // Customize error message based on specific conditions
        if (e.errorCode == WeatherErrorCode.cityNotFound) {
          errorMessage = 'City not found. Please enter a valid city name.';
        } else {
          errorMessage = 'An error occurred: ${e.message}';
        }
      }

      // Displaying error message in Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
  }


  // Future<void> setWeatherParameters(BuildContext context, {required String cityNamee}) async{
  //   var weatherData =await getCityWeather(cityNamee);
  //   dynamic temp = weatherData['main']['temp'];
  //   int temperature = temp.toInt();
  //   dynamic humid = weatherData['main']['humidity'];
  //   int humidity = humid.toInt();
  //   dynamic wind = weatherData['wind']['speed'];
  //   int wind2 = wind.toInt();
  //   String cityName = weatherData['name'];
  //   var condition = weatherData['weather'][0]['main'];
  //   String cond = condition;
  //   var conditionId=weatherData['weather'][0]['id'];
  //   //setting the temperature in provider
  //   final weatherDataTemp = Provider.of<WeatherData>(context, listen: false);
  //   final locationData = Provider.of<LocationData>(context, listen: false);
  //   weatherDataTemp.setHumidity(humidity);
  //   // weatherDataTemp.setRain(rain2);
  //   weatherDataTemp.setWind(wind2);
  //   weatherDataTemp.setCondition(cond);
  //   locationData.setLocation(cityName);
  //   weatherDataTemp.setTemperature(temperature);
  //   weatherDataTemp.setCondition_Id(conditionId);
  // }





  
}

enum WeatherErrorCode {
  cityNotFound,
  // Add more error codes as needed
}

class WeatherException implements Exception {
  final WeatherErrorCode errorCode;
  final String message;

  WeatherException(this.errorCode, this.message);
}
