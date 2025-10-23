class Attraction {
  final String id;
  final String name;
  final String description;
  final int basePrice;
  final int baseIncome;
  final String imageUrl;
  final String type; // 'rollercoaster', 'carousel', 'waterride', etc.
  int level;
  int quantity;

  Attraction({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.baseIncome,
    required this.imageUrl,
    required this.type,
    this.level = 1,
    this.quantity = 0,
  });

  // Prix actuel basé sur la quantité (augmente avec chaque achat)
  int get currentPrice => (basePrice * (1.15 * quantity)).round();

  // Revenu par seconde généré par cette attraction
  int get incomePerSecond => baseIncome * quantity * level;

  // Coût pour améliorer le niveau
  int get upgradeCost => (basePrice * 0.5 * level).round();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'basePrice': basePrice,
        'baseIncome': baseIncome,
        'imageUrl': imageUrl,
        'type': type,
        'level': level,
        'quantity': quantity,
      };

  factory Attraction.fromJson(Map<String, dynamic> json) => Attraction(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        basePrice: json['basePrice'],
        baseIncome: json['baseIncome'],
        imageUrl: json['imageUrl'],
        type: json['type'],
        level: json['level'] ?? 1,
        quantity: json['quantity'] ?? 0,
      );

  Attraction copyWith({
    String? id,
    String? name,
    String? description,
    int? basePrice,
    int? baseIncome,
    String? imageUrl,
    String? type,
    int? level,
    int? quantity,
  }) {
    return Attraction(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      baseIncome: baseIncome ?? this.baseIncome,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      level: level ?? this.level,
      quantity: quantity ?? this.quantity,
    );
  }
}
