import 'dart:math';
import 'package:flutter/material.dart';

class IsometricPosition {
  final int x;
  final int y;

  const IsometricPosition(this.x, this.y);

  // Convertir coordonnées isométriques en coordonnées écran
  Offset toScreenPosition(double tileWidth, double tileHeight) {
    final screenX = (x - y) * tileWidth / 2;
    final screenY = (x + y) * tileHeight / 2;
    return Offset(screenX, screenY);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IsometricPosition && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}

class IsometricTile extends StatelessWidget {
  final IsometricPosition position;
  final Color color;
  final double tileWidth;
  final double tileHeight;
  final Widget? child;
  final VoidCallback? onTap;
  final bool isOccupied;

  const IsometricTile({
    super.key,
    required this.position,
    this.color = Colors.green,
    this.tileWidth = 100,
    this.tileHeight = 50,
    this.child,
    this.onTap,
    this.isOccupied = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenPos = position.toScreenPosition(tileWidth, tileHeight);

    return Positioned(
      left: screenPos.dx,
      top: screenPos.dy,
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          size: Size(tileWidth, tileHeight),
          painter: _IsometricTilePainter(
            color: color,
            isOccupied: isOccupied,
          ),
          child: child != null
              ? SizedBox(
                  width: tileWidth,
                  height: tileHeight,
                  child: child,
                )
              : null,
        ),
      ),
    );
  }
}

class _IsometricTilePainter extends CustomPainter {
  final Color color;
  final bool isOccupied;

  _IsometricTilePainter({
    required this.color,
    required this.isOccupied,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isOccupied ? color.withOpacity(0.3) : color.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Dessiner un losange (vue isométrique d'un carré)
    final path = Path()
      ..moveTo(size.width / 2, 0) // Top
      ..lineTo(size.width, size.height / 2) // Right
      ..lineTo(size.width / 2, size.height) // Bottom
      ..lineTo(0, size.height / 2) // Left
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_IsometricTilePainter oldDelegate) =>
      color != oldDelegate.color || isOccupied != oldDelegate.isOccupied;
}
