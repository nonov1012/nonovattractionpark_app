import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:nonovattractionpark_app/widgets/container_top.dart';
import 'widgets/shop/carousel.dart';



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
            child: Carousel(
              items: [
                {'URL_Image': 'https://cdn.discordapp.com/attachments/1160568640542875700/1344662128602120252/IMG_20250227_142703.jpg?ex=67c1b9b2&is=67c06832&hm=6b920e58bb35009e4433279b6173c732926fae183109f8072a3da929258761b4&', 'Prix': '150'},
                {'URL_Image': 'https://www.cetaces.org/wp-content/uploads/2009/07/Dauphin-bleu-et-blanc-Sc108060.jpg', 'Prix': '150'},
                {'URL_Image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk8HP_qwU9TSUGL07XMbYluFa27GyV2BmRjg&s', 'Prix': '500'},
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