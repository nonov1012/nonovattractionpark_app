import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nonovattractionpark_app/widgets/container_top.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContainerTop(text: 'nuageux'),
            ContainerTop(text: '100 000€'),
            ContainerTop(text: '10 000'),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (index){
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
            NavigationDestination(icon: Icon(Iconsax.more), label: 'Paramètres'),
          ]),
    );
  }
}