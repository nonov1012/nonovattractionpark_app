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

      body: buildBody(),

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

  Widget buildBody(){
    if(page == 0){
      // ======PARC=========
      return SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContainerTop(text: 'nuageux'),
            ContainerTop(text: '100 000€'),
            ContainerTop(text: '10 000'),
          ],
        ),
      );

      // ======BOUTIQUE=========
    }else if(page == 1){
      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ContainerTop(text: 'nuageux'),
                ContainerTop(text: '100 000€'),
                ContainerTop(text: '10 000'),
              ],
            ),
          SizedBox(
            height: 240,
            child: CarouselView(
              itemExtent: 200,
              children: [
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      "https://cdn.discordapp.com/attachments/1160568640542875700/1337792265610989661/SmartSelect_20250124_165018_Gallery.jpg?ex=67bfcde3&is=67be7c63&hm=2176322662472dde12985e385dd5517174719dc8dff1199f88053dd32a3026d6&",
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ElevatedButton(
                        onPressed: () {
                        },
                        child: Text('50€'),
                      ),
                    ),
                  ],
                ),
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      "https://www.cetaces.org/wp-content/uploads/2009/07/Dauphin-bleu-et-blanc-Sc108060.jpg",
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ElevatedButton(
                        onPressed: () {
                          // Action pour le bouton
                        },
                        child: Text('150€'),
                      ),
                    ),
                  ],
                ),
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk8HP_qwU9TSUGL07XMbYluFa27GyV2BmRjg&s",
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ElevatedButton(
                        onPressed: () {
                        },
                        child: Text('500€'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          ])
      );

      // ======EMPLOYES=========
    }else if (page == 2){
      return SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContainerTop(text: 'nuageux'),
            ContainerTop(text: '100 000€'),
            ContainerTop(text: '10 000'),
          ],
        ),
      );
      // ======PARAMETRES=========
    }else{
      return SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContainerTop(text: 'nuageux'),
            ContainerTop(text: '100 000€'),
            ContainerTop(text: '10 000'),
          ],
        ),
      );
    }
  }
}