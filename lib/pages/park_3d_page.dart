import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/game_provider.dart';
import '../widgets/isometric/isometric_tile.dart';
import '../widgets/isometric/isometric_attraction.dart';
import '../models/attraction.dart';

class Park3DPage extends StatefulWidget {
  const Park3DPage({super.key});

  @override
  State<Park3DPage> createState() => _Park3DPageState();
}

class _Park3DPageState extends State<Park3DPage> {
  double _scale = 1.0;
  Offset _offset = Offset.zero;
  Offset _startFocalPoint = Offset.zero;
  double _startScale = 1.0;

  final double _tileWidth = 100;
  final double _tileHeight = 50;
  final int _gridSize = 10;

  // Positions automatiques pour les attractions
  final Map<String, IsometricPosition> _attractionPositions = {};
  int _nextPosIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAttractionPositions();
  }

  void _initializeAttractionPositions() {
    // Créer des positions prédéfinies pour les attractions
    final positions = [
      const IsometricPosition(2, 2),
      const IsometricPosition(5, 2),
      const IsometricPosition(8, 2),
      const IsometricPosition(2, 5),
      const IsometricPosition(5, 5),
      const IsometricPosition(8, 5),
      const IsometricPosition(2, 8),
      const IsometricPosition(5, 8),
      const IsometricPosition(8, 8),
      const IsometricPosition(3, 3),
      const IsometricPosition(6, 3),
      const IsometricPosition(3, 6),
      const IsometricPosition(6, 6),
    ];

    // Assigner les positions initiales
    final attractionIds = [
      'carousel',
      'rollercoaster',
      'waterride',
      'ferriswheel',
      'haunted',
      'bumpercar'
    ];

    for (var i = 0; i < attractionIds.length; i++) {
      _attractionPositions[attractionIds[i]] = positions[i];
    }
  }

  IsometricPosition _getAttractionPosition(String attractionId) {
    if (_attractionPositions.containsKey(attractionId)) {
      return _attractionPositions[attractionId]!;
    }

    // Si pas de position assignée, en créer une nouvelle
    final positions = [
      const IsometricPosition(3, 3),
      const IsometricPosition(6, 3),
      const IsometricPosition(3, 6),
      const IsometricPosition(6, 6),
      const IsometricPosition(4, 4),
      const IsometricPosition(7, 4),
    ];

    final pos = positions[_nextPosIndex % positions.length];
    _nextPosIndex++;
    _attractionPositions[attractionId] = pos;
    return pos;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Stack(
          children: [
            // Fond
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.lightBlue.shade100,
                    Colors.green.shade100,
                  ],
                ),
              ),
            ),

            // Vue du parc
            GestureDetector(
              onScaleStart: (details) {
                _startScale = _scale;
                _startFocalPoint = details.focalPoint - _offset;
              },
              onScaleUpdate: (details) {
                setState(() {
                  _scale = (_startScale * details.scale).clamp(0.5, 2.5);
                  _offset = details.focalPoint - _startFocalPoint;
                });
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Transform.scale(
                    scale: _scale,
                    child: Transform.translate(
                      offset: _offset / _scale,
                      child: _buildParkView(gameProvider),
                    ),
                  ),
                ),
              ),
            ),

            // Stats overlay
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildStatsCard(gameProvider),
            ),

            // Contrôles de zoom
            Positioned(
              right: 16,
              bottom: 100,
              child: _buildZoomControls(),
            ),

            // Légende
            Positioned(
              left: 16,
              bottom: 16,
              child: _buildLegend(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildParkView(GameProvider gameProvider) {
    final ownedAttractions = gameProvider.ownedAttractions;

    return SizedBox(
      width: _gridSize * _tileWidth * 1.5,
      height: _gridSize * _tileHeight * 1.5,
      child: Stack(
        children: [
          // Grille du parc
          ..._buildGrid(),

          // Attractions
          ...ownedAttractions.map((attraction) {
            final position = _getAttractionPosition(attraction.id);
            return IsometricAttraction(
              key: ValueKey(attraction.id),
              attraction: attraction,
              position: position,
              tileWidth: _tileWidth,
              tileHeight: _tileHeight,
              onTap: () => _showAttractionDetails(attraction),
            );
          }).toList(),

          // Message si le parc est vide
          if (ownedAttractions.isEmpty) _buildEmptyParkMessage(),
        ],
      ),
    );
  }

  List<Widget> _buildGrid() {
    final tiles = <Widget>[];

    for (int y = 0; y < _gridSize; y++) {
      for (int x = 0; x < _gridSize; x++) {
        // Alterner les couleurs pour créer un effet de pelouse
        final color = ((x + y) % 2 == 0)
            ? Colors.green.shade600
            : Colors.green.shade700;

        tiles.add(
          IsometricTile(
            key: ValueKey('tile_${x}_$y'),
            position: IsometricPosition(x, y),
            color: color,
            tileWidth: _tileWidth,
            tileHeight: _tileHeight,
          ),
        );
      }
    }

    return tiles;
  }

  Widget _buildEmptyParkMessage() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.park,
              size: 60,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              'Votre parc est vide',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Achetez des attractions\ndans la boutique !',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(GameProvider gameProvider) {
    final formatter = NumberFormat("#,##0", "fr_FR");
    final weatherData = gameProvider.weatherData;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.attach_money,
                label: '${formatter.format(gameProvider.incomePerSecond)} €/s',
                color: Colors.green,
              ),
              _buildStatItem(
                icon: Icons.people,
                label: '${formatter.format(gameProvider.population)}',
                color: Colors.blue,
              ),
            ],
          ),
          if (weatherData != null && weatherData.modifier != 1.0) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(weatherData.weatherEmoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    weatherData.impactDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: weatherData.modifier > 1.0
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
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
      mainAxisSize: MainAxisSize.min,
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

  Widget _buildZoomControls() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _scale = (_scale + 0.2).clamp(0.5, 2.5);
              });
            },
          ),
          Container(
            height: 1,
            width: 30,
            color: Colors.grey.shade300,
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setState(() {
                _scale = (_scale - 0.2).clamp(0.5, 2.5);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🎪 Vue 3D du parc',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Pincer pour zoomer',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          Text(
            'Toucher les attractions',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showAttractionDetails(Attraction attraction) {
    final formatter = NumberFormat("#,##0", "fr_FR");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(_getAttractionIcon(attraction.id), style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 10),
            Expanded(child: Text(attraction.name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(attraction.description),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildDetailRow('Quantité:', 'x${attraction.quantity}'),
            _buildDetailRow('Niveau:', '${attraction.level}'),
            _buildDetailRow('Revenus:', '${formatter.format(attraction.incomePerSecond)} €/s'),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Amélioration: ${formatter.format(attraction.upgradeCost)} €',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              final gameProvider = Provider.of<GameProvider>(context, listen: false);
              if (gameProvider.upgradeAttraction(attraction.id)) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${attraction.name} amélioré !'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Améliorer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  String _getAttractionIcon(String attractionId) {
    switch (attractionId) {
      case 'carousel':
        return '🎠';
      case 'rollercoaster':
        return '🎢';
      case 'waterride':
        return '🌊';
      case 'ferriswheel':
        return '🎡';
      case 'haunted':
        return '👻';
      case 'bumpercar':
        return '🚗';
      default:
        return '🎪';
    }
  }
}
