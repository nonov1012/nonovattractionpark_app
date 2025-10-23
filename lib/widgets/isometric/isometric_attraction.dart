import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/attraction.dart';
import 'isometric_tile.dart';

class IsometricAttraction extends StatelessWidget {
  final Attraction attraction;
  final IsometricPosition position;
  final double tileWidth;
  final double tileHeight;
  final VoidCallback? onTap;

  const IsometricAttraction({
    super.key,
    required this.attraction,
    required this.position,
    this.tileWidth = 100,
    this.tileHeight = 50,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenPos = position.toScreenPosition(tileWidth, tileHeight);
    final attractionSize = _getAttractionSize();

    return Positioned(
      left: screenPos.dx - (attractionSize.width - tileWidth) / 2,
      top: screenPos.dy - attractionSize.height + tileHeight / 2,
      child: GestureDetector(
        onTap: onTap,
        child: _buildAttractionWidget(attractionSize),
      ),
    );
  }

  Size _getAttractionSize() {
    // Taille basée sur le type d'attraction
    switch (attraction.type) {
      case 'thrill':
        return Size(tileWidth * 1.5, tileHeight * 3);
      case 'water':
        return Size(tileWidth * 1.3, tileHeight * 2.5);
      case 'family':
      default:
        return Size(tileWidth, tileHeight * 2);
    }
  }

  Widget _buildAttractionWidget(Size size) {
    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ombre
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width * 0.8,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(size.width * 0.4),
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .scale(
                  duration: 2000.ms,
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1.05, 1.05),
                ),
          ),

          // Structure de l'attraction
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Icône/Représentation visuelle
              Container(
                width: size.width * 0.8,
                height: size.height * 0.7,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _getAttractionColors(),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Icône de l'attraction
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getAttractionIcon(),
                            style: TextStyle(
                              fontSize: size.width * 0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            attraction.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Badge de quantité
                    if (attraction.quantity > 1)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Text(
                            'x${attraction.quantity}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Badge de niveau
                    if (attraction.level > 1)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Text(
                            'Niv.${attraction.level}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 3000.ms,
                    color: Colors.white.withOpacity(0.1),
                  ),

              // Base
              Container(
                width: size.width * 0.9,
                height: size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.brown.shade700,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Color> _getAttractionColors() {
    switch (attraction.type) {
      case 'thrill':
        return [Colors.red.shade700, Colors.red.shade900];
      case 'water':
        return [Colors.blue.shade400, Colors.blue.shade700];
      case 'family':
      default:
        return [Colors.green.shade400, Colors.green.shade700];
    }
  }

  String _getAttractionIcon() {
    switch (attraction.id) {
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
