import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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
  int page = 0;

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
    final weatherData = gameProvider.weatherData;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      child: Column(
        children: [
          // Première ligne: Stats principales
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
          const SizedBox(height: 8),
          // Deuxième ligne: Météo avec impact
          if (weatherData != null)
            GestureDetector(
              onTap: () {
                _showWeatherDetails(gameProvider, weatherData);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: _getWeatherColor(weatherData.modifier),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      weatherData.weatherEmoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Calais: ${weatherData.displayText}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            weatherData.impactDescription,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            )
          else
            const Text(
              'Chargement météo...',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  Color _getWeatherColor(double modifier) {
    if (modifier >= 1.2) {
      return Colors.orange.shade600; // Soleil
    } else if (modifier >= 1.0) {
      return Colors.blue.shade400; // Normal
    } else if (modifier >= 0.7) {
      return Colors.blueGrey.shade600; // Pluie légère
    } else {
      return Colors.grey.shade700; // Mauvais temps
    }
  }

  void _showWeatherDetails(GameProvider gameProvider, weatherData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(weatherData.weatherEmoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 10),
            const Text('Météo à Calais'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weatherData.displayText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow('Impact sur les visiteurs:', weatherData.impactDescription),
            _buildInfoRow(
              'Modificateur:',
              'x${weatherData.modifier.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'La météo affecte le nombre de visiteurs dans votre parc. Le beau temps attire plus de monde, tandis que la pluie dissuade les visiteurs.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await gameProvider.refreshWeather();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Météo mise à jour !'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            child: const Text('Actualiser'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
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