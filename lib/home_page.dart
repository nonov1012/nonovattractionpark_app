import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';


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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$page',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
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