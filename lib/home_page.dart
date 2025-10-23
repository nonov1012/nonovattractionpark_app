import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:nonovattractionpark_app/app_const.dart';
import 'package:nonovattractionpark_app/services/api.dart';
import 'package:nonovattractionpark_app/providers/game_provider.dart';
import 'package:nonovattractionpark_app/pages/park_page.dart';
import 'package:nonovattractionpark_app/pages/shop_page.dart';
import 'package:nonovattractionpark_app/pages/employees_page.dart';
import 'package:nonovattractionpark_app/widgets/settings/option.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final int _counter = 0;

  int page = 0;

  final WeatherService _weatherService = WeatherService(); // Instance du service météo

  @override
  void initState() {
    super.initState();
    // Charger la météo au démarrage (utilisez une ville de votre choix)
    _fetchWeather();
  }

  // Méthode pour récupérer la météo
  Future<void> _fetchWeather() async {
    // Vous pouvez choisir une ville par défaut, ou utiliser la géolocalisation
    await _weatherService.getWeatherByCity('Paris');
    // Pour forcer la mise à jour de l'UI après avoir récupéré la météo
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(gameProvider),
                Expanded(child: buildBody()),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (index) {
              setState(() {
                page = index;
              });
            },
            selectedIndex: page,
            elevation: 1,
            height: 80,
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Parc'),
              NavigationDestination(icon: Icon(Iconsax.shop), label: 'Boutique'),
              NavigationDestination(icon: Icon(Iconsax.user), label: 'Employés'),
              NavigationDestination(icon: Icon(Iconsax.setting_2), label: 'Paramètres'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(GameProvider gameProvider) {
    final formatter = NumberFormat("#,##0", "fr_FR");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.wb_sunny,
            label: AppConst.weather,
            color: Colors.orange,
          ),
          _buildStatItem(
            icon: Icons.account_balance_wallet,
            label: '${formatter.format(gameProvider.money)} €',
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Icons.people,
            label: '${formatter.format(gameProvider.population)}',
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget buildBody() {
    switch (page) {
      case 0:
        return const ParkPage();
      case 1:
        return const ShopPage();
      case 2:
        return const EmployeesPage();
      case 3:
        return const SettingsPage();
      default:
        return const ParkPage();
    }
  }
}