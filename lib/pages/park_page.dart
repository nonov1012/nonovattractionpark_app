import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/game_provider.dart';

class ParkPage extends StatelessWidget {
  const ParkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final ownedAttractions = gameProvider.ownedAttractions;

        return Column(
          children: [
            // Stats du parc
            _buildParkStats(gameProvider),

            const SizedBox(height: 20),

            // Liste des attractions possédées
            Expanded(
              child: ownedAttractions.isEmpty
                  ? _buildEmptyState()
                  : _buildAttractionsList(ownedAttractions, gameProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildParkStats(GameProvider gameProvider) {
    final formatter = NumberFormat("#,##0", "fr_FR");
    final weatherData = gameProvider.weatherData;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.deepPurple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '💰 Revenus',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${formatter.format(gameProvider.incomePerSecond)} €/s',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (gameProvider.salaryPerSecond > 0) ...[
            const SizedBox(height: 5),
            Text(
              'Salaires: ${formatter.format(gameProvider.salaryPerSecond)} €/s',
              style: TextStyle(
                color: Colors.red.shade200,
                fontSize: 14,
              ),
            ),
            Text(
              'Net: ${formatter.format(gameProvider.netIncomePerSecond)} €/s',
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          // Afficher l'impact météo
          if (weatherData != null && weatherData.modifier != 1.0) ...[
            const SizedBox(height: 10),
            const Divider(color: Colors.white30, height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weatherData.weatherEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Text(
                  'Météo: ${weatherData.impactDescription}',
                  style: TextStyle(
                    color: weatherData.modifier > 1.0
                        ? Colors.greenAccent
                        : Colors.orange.shade200,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.park_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'Votre parc est vide',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Achetez des attractions dans la boutique !',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttractionsList(List attractions, GameProvider gameProvider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: attractions.length,
      itemBuilder: (context, index) {
        final attraction = attractions[index];
        final formatter = NumberFormat("#,##0", "fr_FR");

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Image de l'attraction
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    attraction.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Infos de l'attraction
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attraction.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Quantité: ${attraction.quantity} | Niveau: ${attraction.level}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${formatter.format(attraction.incomePerSecond)} €/s',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bouton d'amélioration
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: gameProvider.money >= attraction.upgradeCost
                          ? () => gameProvider.upgradeAttraction(attraction.id)
                          : null,
                      icon: const Icon(Icons.upgrade, size: 16),
                      label: Text(
                        '${formatter.format(attraction.upgradeCost)} €',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
