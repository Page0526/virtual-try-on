import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/profile');
          },
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Account',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.person,
            title: 'Edit profile',
            onTap: () {
              context.go('/edit-profile');
            },
          ),
          _buildListTile(context, icon: Icons.security, title: 'security'),
          _buildListTile(context, icon: Icons.notifications, title: 'Notifications'),
          _buildListTile(context, icon: Icons.lock, title: 'Privacy'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Support & About',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          _buildListTile(context, icon: Icons.credit_card, title: 'My Subscription'),
          _buildListTile(context, icon: Icons.help, title: 'Help & Support'),
          _buildListTile(context, icon: Icons.info, title: 'Terms and Policies'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Cache & cellular',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          _buildListTile(context, icon: Icons.delete, title: 'Free up space'),
          _buildListTile(context, icon: Icons.data_usage, title: 'Data Saver'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Actions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          _buildListTile(context, icon: Icons.report, title: 'Report a problem'),
          _buildListTile(context, icon: Icons.person_add, title: 'Add account'),
          _buildListTile(context, icon: Icons.logout, title: 'Log out'),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required IconData icon, required String title, void Function()? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      onTap: onTap,
    );
  }
}