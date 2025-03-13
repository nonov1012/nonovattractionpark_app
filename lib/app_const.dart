import 'package:intl/intl.dart';

class AppConst {
  static const int page = 0;
  static const String namePark = 'nonovAttractionPark';
  static int money = 1000;
  static const int population = 100;

  // Valeur par défaut modifiée
  static String weather = "données météo";

  // Variable pour stocker les données complètes de la météo
  static Map<String, dynamic> weatherData = {};

  // Getter pour formater money avec un séparateur de milliers
  static String get formattedMoney {
    return NumberFormat("#,##0", "fr_FR").format(money) + " €";
  }

  // Méthode pour mettre à jour la météo à partir des données JSON
  static void updateWeather(Map<String, dynamic> data) {
    weatherData = data;

    // Extraire la description de la météo
    if (data.containsKey('weather') && data['weather'] is List && data['weather'].isNotEmpty) {
      weather = data['weather'][0]['description'];
    }

    // Option: Ajouter la température dans la description
    if (data.containsKey('main') && data['main'].containsKey('temp')) {
      double temp = data['main']['temp'];
      weather = "$weather, ${temp.round()}°C";
    }
  }
}

