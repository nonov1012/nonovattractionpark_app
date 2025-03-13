import 'package:dio/dio.dart';
import '../app_const.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String apiKey = "0c33795d70f16929417cfff4db216c98"; // Remplacez par votre clé API
  final String baseUrl = "https://api.openweathermap.org/data/2.5";

  // Méthode pour obtenir la météo par ville
  Future<void> getWeatherByCity(String city) async {
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
        // Mise à jour de la variable dans AppConst
        AppConst.updateWeather(response.data);
      }
    } catch (e) {
      print('Erreur lors de la récupération de la météo: $e');
      AppConst.weather = "Error";
    }
  }
}
