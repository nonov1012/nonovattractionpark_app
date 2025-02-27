import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int versionTapCount = 0;
  bool showDebugOptions = false;

  void _onVersionTap() {
    setState(() {
      versionTapCount++;
      if (versionTapCount >= 5) {
        showDebugOptions = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Général", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Iconsax.global),
            title: const Text("Langue"),
            subtitle: const Text("Français"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Iconsax.paintbucket),
            title: const Text("Thème"),
            subtitle: const Text("Mode sombre activé"),
            trailing: Switch(value: true, onChanged: (value) {}),
          ),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Compte", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Iconsax.text_italic),
            title: const Text("Nom du park"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Iconsax.warning_2),
            title: const Text("Reinitialisé le park"),
            subtitle: const Text("Cette action vous fera recommencer a zéro"),
          ),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          SwitchListTile(
            secondary: const Icon(Iconsax.notification),
            title: const Text("Recevoir des notifications"),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            secondary: const Icon(Iconsax.sms),
            title: const Text("Recevoir des SMS"),
            value: false,
            onChanged: (value) {},
          ),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("À propos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Iconsax.people),
            title: const Text("Crédit"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Iconsax.info_circle),
            title: const Text("Version de l'application"),
            subtitle: const Text("1.0.0"),
            onTap: _onVersionTap,
          ),

          if (showDebugOptions) ...[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Debug", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            ),
            ListTile(
              leading: const Icon(Iconsax.money_send),
              title: const Text("Give Argent"),
              onTap: () {
                // Implémente l'action pour donner de l'argent
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.people),
              title: const Text("Give Population"),
              onTap: () {
                // Implémente l'action pour donner des objets
              },
            ),
          ],
        ],
      ),
    );
  }
}
