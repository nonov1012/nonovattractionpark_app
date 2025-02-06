import "package:flutter/material.dart";
import 'package:iconsax_flutter/iconsax_flutter.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: NavigationBar(
          height: 80,
          destinations: const [
        NavigationDestination(icon: Icon(Iconsax.home), label: 'Parc'),
        NavigationDestination(icon: Icon(Iconsax.shop), label: 'Boutique'),
        NavigationDestination(icon: Icon(Iconsax.user), label: 'Employés'),
        NavigationDestination(icon: Icon(Iconsax.more), label: 'Paramètres'),
      ]),
      body: Container(),
    );
  }
}