import 'package:intl/intl.dart';

class AppConst {
  static const int page = 0;
  static const String namePark = 'nonovAttractionPark';
  static int money = 1000;
  static const int population = 100;
  static const String weather = "nuageux";

  // Getter pour formater money avec un séparateur de milliers
  static String get formattedMoney {
    return NumberFormat("#,##0", "fr_FR").format(money) + " €";
  }
}
