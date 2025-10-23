import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/attraction.dart';
import '../models/employee.dart';

class GameProvider extends ChangeNotifier {
  int _money = 1000;
  int _population = 0;
  List<Attraction> _attractions = [];
  List<Employee> _employees = [];
  Timer? _incomeTimer;
  DateTime _lastSaveTime = DateTime.now();

  int get money => _money;
  int get population => _population;
  List<Attraction> get attractions => _attractions;
  List<Employee> get employees => _employees;
  List<Attraction> get ownedAttractions =>
      _attractions.where((a) => a.quantity > 0).toList();
  List<Employee> get hiredEmployees =>
      _employees.where((e) => e.isHired).toList();

  // Revenu total par seconde
  int get incomePerSecond {
    int baseIncome = _attractions.fold(0, (sum, a) => sum + a.incomePerSecond);
    double multiplier = 1.0;

    // Appliquer les bonus des employés
    for (var employee in _employees.where((e) => e.isHired)) {
      multiplier *= employee.efficiencyBonus;
    }

    return (baseIncome * multiplier).round();
  }

  // Coût total des salaires par seconde
  int get salaryPerSecond =>
      _employees.where((e) => e.isHired).fold(0, (sum, e) => sum + e.baseSalary);

  // Revenu net par seconde
  int get netIncomePerSecond => incomePerSecond - salaryPerSecond;

  GameProvider() {
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _loadGame();
    _initializeAttractions();
    _initializeEmployees();
    _startIncomeGeneration();
  }

  void _initializeAttractions() {
    // Si aucune attraction n'est chargée, initialiser les attractions par défaut
    if (_attractions.isEmpty) {
      _attractions = [
        Attraction(
          id: 'carousel',
          name: 'Carrousel',
          description: 'Un carrousel classique qui enchante les enfants',
          basePrice: 150,
          baseIncome: 5,
          imageUrl: 'https://cdn.discordapp.com/attachments/1160568640542875700/1344662128602120252/IMG_20250227_142703.jpg',
          type: 'family',
        ),
        Attraction(
          id: 'rollercoaster',
          name: 'Montagnes Russes',
          description: 'Des sensations fortes garanties !',
          basePrice: 500,
          baseIncome: 25,
          imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk8HP_qwU9TSUGL07XMbYluFa27GyV2BmRjg&s',
          type: 'thrill',
        ),
        Attraction(
          id: 'waterride',
          name: 'Toboggan Aquatique',
          description: 'Rafraîchissant et amusant',
          basePrice: 350,
          baseIncome: 15,
          imageUrl: 'https://www.cetaces.org/wp-content/uploads/2009/07/Dauphin-bleu-et-blanc-Sc108060.jpg',
          type: 'water',
        ),
        Attraction(
          id: 'ferriswheel',
          name: 'Grande Roue',
          description: 'Vue panoramique sur tout le parc',
          basePrice: 800,
          baseIncome: 40,
          imageUrl: 'https://images.unsplash.com/photo-1524648226837-f82165f0fdbb?w=500',
          type: 'family',
        ),
        Attraction(
          id: 'haunted',
          name: 'Maison Hantée',
          description: 'Frissons garantis dans le noir',
          basePrice: 650,
          baseIncome: 35,
          imageUrl: 'https://images.unsplash.com/photo-1509248961158-e54f6934749c?w=500',
          type: 'thrill',
        ),
        Attraction(
          id: 'bumpercar',
          name: 'Auto-tamponneuses',
          description: 'Du fun pour toute la famille',
          basePrice: 250,
          baseIncome: 10,
          imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=500',
          type: 'family',
        ),
      ];
    }
  }

  void _initializeEmployees() {
    // Si aucun employé n'est chargé, initialiser les employés par défaut
    if (_employees.isEmpty) {
      _employees = [
        Employee(
          id: 'manager',
          name: 'Sophie Martin',
          role: 'Manager',
          description: 'Augmente les revenus de 10%',
          baseSalary: 5,
          efficiencyBonus: 1.1,
          hireCost: 1000,
          imageUrl: '👩‍💼',
        ),
        Employee(
          id: 'technician',
          name: 'Marc Dubois',
          role: 'Technicien',
          description: 'Améliore l\'efficacité de 15%',
          baseSalary: 8,
          efficiencyBonus: 1.15,
          hireCost: 2000,
          imageUrl: '👨‍🔧',
        ),
        Employee(
          id: 'animator',
          name: 'Julie Petit',
          role: 'Animatrice',
          description: 'Attire plus de visiteurs (+20%)',
          baseSalary: 6,
          efficiencyBonus: 1.2,
          hireCost: 1500,
          imageUrl: '👩‍🎨',
        ),
        Employee(
          id: 'security',
          name: 'Pierre Leroy',
          role: 'Agent de Sécurité',
          description: 'Rassure les visiteurs (+5%)',
          baseSalary: 4,
          efficiencyBonus: 1.05,
          hireCost: 800,
          imageUrl: '👮',
        ),
        Employee(
          id: 'cleaner',
          name: 'Marie Durand',
          role: 'Agent d\'Entretien',
          description: 'Parc plus propre (+8%)',
          baseSalary: 3,
          efficiencyBonus: 1.08,
          hireCost: 600,
          imageUrl: '🧹',
        ),
      ];
    }
  }

  void _startIncomeGeneration() {
    _incomeTimer?.cancel();
    _incomeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _generateIncome();
    });
  }

  void _generateIncome() {
    int income = netIncomePerSecond;
    if (income != 0) {
      _money += income;
      _updatePopulation();
      notifyListeners();
    }
  }

  void _updatePopulation() {
    // La population augmente avec le nombre d'attractions
    int newPopulation = _attractions.fold(0, (sum, a) => sum + (a.quantity * 10));
    if (newPopulation != _population) {
      _population = newPopulation;
    }
  }

  // Acheter une attraction
  bool buyAttraction(String attractionId) {
    final index = _attractions.indexWhere((a) => a.id == attractionId);
    if (index == -1) return false;

    final attraction = _attractions[index];
    final price = attraction.currentPrice;

    if (_money >= price) {
      _money -= price;
      _attractions[index] = attraction.copyWith(quantity: attraction.quantity + 1);
      _updatePopulation();
      _saveGame();
      notifyListeners();
      return true;
    }
    return false;
  }

  // Améliorer une attraction
  bool upgradeAttraction(String attractionId) {
    final index = _attractions.indexWhere((a) => a.id == attractionId);
    if (index == -1) return false;

    final attraction = _attractions[index];
    if (attraction.quantity == 0) return false;

    final cost = attraction.upgradeCost;

    if (_money >= cost) {
      _money -= cost;
      _attractions[index] = attraction.copyWith(level: attraction.level + 1);
      _saveGame();
      notifyListeners();
      return true;
    }
    return false;
  }

  // Embaucher un employé
  bool hireEmployee(String employeeId) {
    final index = _employees.indexWhere((e) => e.id == employeeId);
    if (index == -1) return false;

    final employee = _employees[index];
    if (employee.isHired) return false;

    if (_money >= employee.hireCost) {
      _money -= employee.hireCost;
      _employees[index] = employee.copyWith(isHired: true);
      _saveGame();
      notifyListeners();
      return true;
    }
    return false;
  }

  // Licencier un employé
  bool fireEmployee(String employeeId) {
    final index = _employees.indexWhere((e) => e.id == employeeId);
    if (index == -1) return false;

    final employee = _employees[index];
    if (!employee.isHired) return false;

    _employees[index] = employee.copyWith(isHired: false);
    _saveGame();
    notifyListeners();
    return true;
  }

  // Sauvegarder le jeu
  Future<void> _saveGame() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('money', _money);
    await prefs.setInt('population', _population);
    await prefs.setString('lastSaveTime', DateTime.now().toIso8601String());

    // Sauvegarder les attractions
    final attractionsJson = _attractions.map((a) => a.toJson()).toList();
    await prefs.setString('attractions', jsonEncode(attractionsJson));

    // Sauvegarder les employés
    final employeesJson = _employees.map((e) => e.toJson()).toList();
    await prefs.setString('employees', jsonEncode(employeesJson));

    _lastSaveTime = DateTime.now();
  }

  // Charger le jeu
  Future<void> _loadGame() async {
    final prefs = await SharedPreferences.getInstance();

    _money = prefs.getInt('money') ?? 1000;
    _population = prefs.getInt('population') ?? 0;

    // Charger les attractions
    final attractionsString = prefs.getString('attractions');
    if (attractionsString != null) {
      final attractionsList = jsonDecode(attractionsString) as List;
      _attractions = attractionsList.map((json) => Attraction.fromJson(json)).toList();
    }

    // Charger les employés
    final employeesString = prefs.getString('employees');
    if (employeesString != null) {
      final employeesList = jsonDecode(employeesString) as List;
      _employees = employeesList.map((json) => Employee.fromJson(json)).toList();
    }

    // Calculer les revenus pendant l'absence (idle)
    final lastSaveString = prefs.getString('lastSaveTime');
    if (lastSaveString != null) {
      final lastSave = DateTime.parse(lastSaveString);
      final secondsAway = DateTime.now().difference(lastSave).inSeconds;

      // Limiter à 24 heures maximum
      final cappedSeconds = secondsAway > 86400 ? 86400 : secondsAway;

      if (cappedSeconds > 0 && netIncomePerSecond > 0) {
        final offlineEarnings = netIncomePerSecond * cappedSeconds;
        _money += offlineEarnings;
      }
    }

    notifyListeners();
  }

  // Réinitialiser le jeu
  Future<void> resetGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _money = 1000;
    _population = 0;
    _attractions.clear();
    _employees.clear();

    _initializeAttractions();
    _initializeEmployees();

    notifyListeners();
  }

  @override
  void dispose() {
    _incomeTimer?.cancel();
    _saveGame();
    super.dispose();
  }
}
