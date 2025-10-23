import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

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

  void _showCreditsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.people, color: Colors.purple),
            SizedBox(width: 10),
            Text('Crédits'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'nonovAttractionPark',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Développé avec ❤️ en Flutter',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Équipe de développement:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildCreditItem('🎨', 'Design & UI/UX', 'nonov Team'),
              _buildCreditItem('💻', 'Développement', 'nonov Team'),
              _buildCreditItem('🎮', 'Game Design', 'nonov Team'),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Technologies utilisées:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildCreditItem('📱', 'Flutter', 'SDK de Google'),
              _buildCreditItem('🎨', 'Material Design 3', 'Google'),
              _buildCreditItem('📦', 'Provider', 'State Management'),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditItem(String emoji, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
            leading: const Icon(Iconsax.warning_2, color: Colors.red),
            title: const Text("Réinitialiser le parc"),
            subtitle: const Text("Cette action vous fera recommencer à zéro"),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Réinitialiser le parc'),
                  content: const Text(
                    'Êtes-vous sûr de vouloir réinitialiser votre parc ? Toutes vos données seront perdues !',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final gameProvider = Provider.of<GameProvider>(
                          context,
                          listen: false,
                        );
                        gameProvider.resetGame();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Le parc a été réinitialisé'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Réinitialiser'),
                    ),
                  ],
                ),
              );
            },
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
            title: const Text("Crédits"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _showCreditsDialog,
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
            Consumer<GameProvider>(
              builder: (context, gameProvider, child) => ListTile(
                leading: const Icon(Iconsax.money_send, color: Colors.green),
                title: const Text("Ajouter 10 000 €"),
                onTap: () {
                  // Note: Cette fonctionnalité nécessiterait une méthode addMoney dans GameProvider
                  // Pour l'instant, on peut utiliser buyAttraction en négatif (hack)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fonction de debug - Argent ajouté !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
