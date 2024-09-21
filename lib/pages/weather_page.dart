import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weatherappp/models/weather_model.dart';
import 'package:weatherappp/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('3ac4e8fb8750ae49f5e197b1c7f6d835');
  Weather? _weather;

  // fetch the weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    //get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sun.json'; // default to sunny

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/clouds.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sun.json';
      default:
        return 'assets/sun.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size using MediaQuery
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait = screenHeight > screenWidth;

    // Define dynamic font sizes and widget sizes based on screen size
    final double fontSizeLarge = screenWidth * 0.08; // 8% of screen width
    final double fontSizeMedium = screenWidth * 0.06; // 6% of screen width
    final double fontSizeSmall = screenWidth * 0.04; // 4% of screen width

    // Adjust padding and widget sizes based on the screen size
    final double paddingValue = screenWidth * 0.05; // 5% of screen width
    final double animationSize = isPortrait
        ? screenHeight * 0.4 // 40% of screen height
        : screenWidth * 0.3; // 30% of screen width for landscape mode

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingValue),
        child: Center(
          child: _weather == null
              ? const CircularProgressIndicator() // Show loading indicator while weather is being fetched
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // City name
                    Text(
                      _weather?.cityName ?? "Loading city...",
                      style: TextStyle(
                        fontSize: fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: screenHeight * 0.02), // Add some spacing

                    // Lottie animation
                    SizedBox(
                      width: animationSize,
                      height: animationSize,
                      child: Lottie.asset(
                          getWeatherAnimation(_weather?.mainCondition)),
                    ),

                    SizedBox(height: screenHeight * 0.02), // Add spacing

                    // Temperature
                    Text(
                      '${_weather?.temperature.round()}°C',
                      style: TextStyle(
                        fontSize: fontSizeMedium,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01), // Add some spacing

                    // Weather condition
                    Text(
                      _weather?.mainCondition ?? "",
                      style: TextStyle(
                        fontSize: fontSizeSmall,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
