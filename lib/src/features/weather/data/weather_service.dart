import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../presentation/screens/weather_screen.dart';

class WeatherService {
  // OpenWeatherMap API key - يمكن تبديلها بمفتاح حقيقي
  static const String _apiKey = 'YOUR_API_KEY_HERE';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  /// Get weather forecast for 7 days
  Future<List<DayForecast>> getWeatherForecast({double? lat, double? lon}) async {
    try {
      // If no coordinates provided, get current location
      if (lat == null || lon == null) {
        final position = await getCurrentLocation();
        if (position == null) {
          return _getMockWeather();
        }
        lat = position.latitude;
        lon = position.longitude;
      }

      // For Morocco, use default coordinates if API key not available
      if (_apiKey == 'YOUR_API_KEY_HERE') {
        return _getMockWeather();
      }

      // Call OpenWeatherMap API
      final url = Uri.parse(
        '$_baseUrl/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,alerts&units=metric&appid=$_apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseWeatherData(data);
      } else {
        return _getMockWeather();
      }
    } catch (e) {
      // If error, return mock data
      return _getMockWeather();
    }
  }

  /// Parse API response to DayForecast list
  List<DayForecast> _parseWeatherData(Map<String, dynamic> data) {
    final List<DayForecast> forecasts = [];
    
    // Add current day
    final current = data['current'];
    final today = data['daily'][0];
    forecasts.add(DayForecast(
      date: DateTime.now(),
      tempHigh: (today['temp']['max'] as num).toDouble(),
      tempLow: (today['temp']['min'] as num).toDouble(),
      condition: _mapWeatherCondition(today['weather'][0]['main']),
    ));

    // Add next 6 days
    for (int i = 1; i < 7 && i < data['daily'].length; i++) {
      final day = data['daily'][i];
      forecasts.add(DayForecast(
        date: DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000),
        tempHigh: (day['temp']['max'] as num).toDouble(),
        tempLow: (day['temp']['min'] as num).toDouble(),
        condition: _mapWeatherCondition(day['weather'][0]['main']),
      ));
    }

    return forecasts;
  }

  /// Map OpenWeatherMap condition to app condition
  String _mapWeatherCondition(String apiCondition) {
    switch (apiCondition.toLowerCase()) {
      case 'clear':
        return 'sunny';
      case 'clouds':
        return 'cloudy';
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return 'rainy';
      default:
        return 'partly';
    }
  }

  /// Mock weather data (fallback)
  List<DayForecast> _getMockWeather() {
    final start = DateTime.now();
    final rnd = start.day % 3;
    return List.generate(7, (i) {
      final d = start.add(Duration(days: i));
      final cond = (i + rnd) % 4 == 0
          ? 'sunny'
          : (i + rnd) % 4 == 1
              ? 'cloudy'
              : (i + rnd) % 4 == 2
                  ? 'rainy'
                  : 'partly';
      final high = 20 + ((i + rnd) % 5) + (i.isEven ? 0 : 1);
      final low = high - (2 + (i % 2));
      return DayForecast(
        date: d,
        tempHigh: high.toDouble(),
        tempLow: low.toDouble(),
        condition: cond,
      );
    });
  }
}
