class Employee {
  final String id;
  final String name;
  final String role;
  final String description;
  final int baseSalary; // Salaire par seconde
  final double efficiencyBonus; // Bonus de productivité (ex: 1.1 = +10%)
  final int hireCost;
  final String imageUrl;
  bool isHired;

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.description,
    required this.baseSalary,
    required this.efficiencyBonus,
    required this.hireCost,
    required this.imageUrl,
    this.isHired = false,
  });

  // Salaire par heure pour l'affichage
  int get salaryPerHour => baseSalary * 3600;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'role': role,
        'description': description,
        'baseSalary': baseSalary,
        'efficiencyBonus': efficiencyBonus,
        'hireCost': hireCost,
        'imageUrl': imageUrl,
        'isHired': isHired,
      };

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json['id'],
        name: json['name'],
        role: json['role'],
        description: json['description'],
        baseSalary: json['baseSalary'],
        efficiencyBonus: json['efficiencyBonus'],
        hireCost: json['hireCost'],
        imageUrl: json['imageUrl'],
        isHired: json['isHired'] ?? false,
      );

  Employee copyWith({
    String? id,
    String? name,
    String? role,
    String? description,
    int? baseSalary,
    double? efficiencyBonus,
    int? hireCost,
    String? imageUrl,
    bool? isHired,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      description: description ?? this.description,
      baseSalary: baseSalary ?? this.baseSalary,
      efficiencyBonus: efficiencyBonus ?? this.efficiencyBonus,
      hireCost: hireCost ?? this.hireCost,
      imageUrl: imageUrl ?? this.imageUrl,
      isHired: isHired ?? this.isHired,
    );
  }
}
