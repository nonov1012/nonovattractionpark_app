import 'package:dio/dio.dart';

class WeatherData {
  final String description;
  final double temperature;
  final String mainWeather; // 'Clear', 'Rain', 'Clouds', 'Snow', etc.
  final double modifier; // Modificateur de revenus basé sur la météo
  final String icon;

  WeatherData({
    required this.description,
    required this.temperature,
    required this.mainWeather,
    required this.modifier,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final mainWeather = json['weather'][0]['main'] as String;
    final description = json['weather'][0]['description'] as String;
    final temperature = (json['main']['temp'] as num).toDouble();
    final icon = json['weather'][0]['icon'] as String;

    // Calcul du modificateur basé sur la météo
    double modifier = 1.0;
    switch (mainWeather.toLowerCase()) {
      case 'clear': // Soleil
        modifier = 1.2; // +20% de visiteurs
        break;
      case 'clouds': // Nuageux
        if (description.contains('peu') || description.contains('quelques')) {
          modifier = 1.0; // Normal
        } else {
          modifier = 0.9; // -10% si très nuageux
        }
        break;
      case 'rain': // Pluie
      case 'drizzle': // Bruine
        modifier = 0.7; // -30% de visiteurs
        break;
      case 'thunderstorm': // Orage
        modifier = 0.5; // -50% de visiteurs
        break;
      case 'snow': // Neige
        modifier = 0.6; // -40% de visiteurs
        break;
      case 'mist': // Brouillard
      case 'fog':
        modifier = 0.85; // -15% de visiteurs
        break;
      default:
        modifier = 1.0;
    }

    return WeatherData(
      description: description,
      temperature: temperature,
      mainWeather: mainWeather,
      modifier: modifier,
      icon: icon,
    );
  }

  String get displayText => '$description, ${temperature.round()}°C';

  String get weatherEmoji {
    switch (mainWeather.toLowerCase()) {
      case 'clear':
        return '☀️';
      case 'clouds':
        return '☁️';
      case 'rain':
      case 'drizzle':
        return '🌧️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
        return '🌫️';
      default:
        return '🌤️';
    }
  }

  String get impactDescription {
    if (modifier > 1.0) {
      return '+${((modifier - 1) * 100).toInt()}% de visiteurs';
    } else if (modifier < 1.0) {
      return '${((modifier - 1) * 100).toInt()}% de visiteurs';
    } else {
      return 'Normal';
    }
  }
}

class WeatherService {
  final Dio _dio = Dio();
  final String apiKey = "0c33795d70f16929417cfff4db216c98";
  final String baseUrl = "https://api.openweathermap.org/data/2.5";

  // Méthode pour obtenir la météo par ville
  Future<WeatherData?> getWeatherByCity(String city) async {
    try {
      final response = await _dio.get(
        '$baseUrl/weather',
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric', // Pour avoir les températures en Celsius
          'lang': 'fr',      // Pour avoir les descriptions en français
        },
      );

      if (response.statusCode == 200) {
        return WeatherData.fromJson(response.data);
      }
    } catch (e) {
      print('Erreur lors de la récupération de la météo: $e');
    }
    return null;
  }
}
