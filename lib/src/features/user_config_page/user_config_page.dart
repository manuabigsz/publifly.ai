import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publifly_ai/src/shared/providers/user_provider.dart';

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<CurrentUserProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProvider.userNome!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userProvider.userEmail!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            // Conta
            _buildSectionHeader('Conta'),
            _buildListTile(
              icon: Icons.person,
              title: 'Informações Pessoais',
              onTap: () {
                // Ação ao clicar
              },
            ),
            _buildListTile(
              icon: Icons.lock,
              title: 'Segurança',
              onTap: () {
                // Ação ao clicar
              },
            ),
            const Divider(),
            // Preferências
            _buildSectionHeader('Preferências'),
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'Tema Escuro',
              value: false,
              onChanged: (value) {
                // Alterar o tema
              },
            ),
            _buildListTile(
              icon: Icons.notifications,
              title: 'Notificações',
              onTap: () {
                // Ação ao clicar
              },
            ),
            const Divider(),
            // Sobre
            _buildSectionHeader('Sobre'),
            _buildListTile(
              icon: Icons.info,
              title: 'Versão do App',
              trailing: const Text('2.1.0'),
            ),
            _buildListTile(
              icon: Icons.privacy_tip,
              title: 'Política de Privacidade',
              onTap: () {
                // Ação ao clicar
              },
            ),
            const Divider(),
            // Sair
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Ação ao sair
                },
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Sair'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
