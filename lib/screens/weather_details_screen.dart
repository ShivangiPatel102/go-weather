import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_weather/constants.dart';
import 'package:go_weather/providers/weather_data.dart';
import 'package:go_weather/services/weather.dart';
import 'package:go_weather/utilities/get_weather_icon.dart';
import 'package:go_weather/widgets/small_weather_specs_card.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

WeatherModel weatherModel = WeatherModel();

class WeatherDetailsScreen extends StatefulWidget {
  static const String id = 'weather_screen';
  const WeatherDetailsScreen({super.key, required this.locationWeather});
  final String locationWeather;

  @override
  State<WeatherDetailsScreen> createState() => _WeatherDetailsScreenState();
}

class _WeatherDetailsScreenState extends State<WeatherDetailsScreen> {
  late int temperature;
  late int wind;
  late int humidity;
  late String cityName;
  bool isLoading = true;
  late String condition;
  late int conditionId;
  late String weatherImgPath;
  bool gotSuccessWeather = true;

  @override
  void initState() {
    super.initState();
    initializeWeather();
  }

  Future<void> initializeWeather() async {
    gotSuccessWeather = await weatherModel.setWeatherParameters(context,
        cityNamee: widget.locationWeather);
    if(gotSuccessWeather){
       await updateUI();
    }
   
   
  }

  Future<void> refreshWeather() async {
    setState(() {
      isLoading = true;
    });
    await initializeWeather();
  }

  Future<void> updateUI() async {
    try {
      final temperatureData = Provider.of<WeatherData>(context, listen: false);
      temperature = temperatureData.temperature;
      humidity = temperatureData.humidity;
      wind = temperatureData.wind;
      cityName = widget.locationWeather;
      condition = temperatureData.condition;
      conditionId = temperatureData.condition_id;
      weatherImgPath = getWeatherIcon(conditionId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // appBar: ReusableWidgets.smallAppBar('Weather'),
      body: SafeArea(
        child: isLoading
            ? kLoader
            : Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Column(
                  children: [
                    SizedBox(
                      height: 45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Icon(
                              Icons.location_on,
                              color: kPrimaryGreenColor,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            cityName,
                            style: kTitleOfInfoCardsTS,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      flex: 7,
                      child: Card(
                        color: kLightTealCardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Lottie.asset(weatherImgPath),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Text(
                                    '$temperature°',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                  Text(condition, style: kTitleOfInfoCardsTS),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: [
                          SmallWeatherSpecsCard(
                              title: '$humidity',
                              icon: FontAwesomeIcons.droplet,
                              subtitle: 'Humidity'),
                          SmallWeatherSpecsCard(
                              title: '$wind',
                              icon: FontAwesomeIcons.wind,
                              subtitle: 'Wind'),
                        ],
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: refreshWeather,
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontFamily: "Catamaran",
                          ),
                          foregroundColor: Colors.white,
                          backgroundColor: kButtonPositiveColor,
                        ),
                        child: const Text('Go Live Weather'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
