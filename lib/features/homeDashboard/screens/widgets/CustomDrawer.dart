// lib/widgets/CustomDrawer.dart
import 'dart:convert';
import 'package:discountzshop/features/authentication/login/screens/LoginScreen.dart';
import './../../../UserProfile/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:discountzshop/utils/constants/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      try {
        return jsonDecode(userJson) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width, // FULL WIDTH
      backgroundColor: TColors.primaryColor,
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          final userData = snapshot.data;
          final bool isLoggedIn = userData != null;
          final String userName = userData?['name'] ?? 'Guest';
          final String membership = userData?['membership_type'] ?? 'Silver Member';

          return Column(
            children: [
              const SizedBox(height: 70),

              // Close Button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Avatar
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  isLoggedIn ? Icons.person : Icons.person_outline,
                  size: 70,
                  color: TColors.primaryColor,
                ),
              ),

              const SizedBox(height: 20),

              // User Name & Membership
              Text(
                isLoggedIn ? userName : 'Hello, Guest',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                isLoggedIn ? membership : 'Please login to continue',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 60),

              // MENU ITEMS - CONDITIONAL
              if (!isLoggedIn) ...[
                _buildMenuItem(
                  context: context,
                  icon: Icons.login,
                  title: 'Login',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ] else ...[
                _buildMenuItem(
                  context: context,
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => UserProfile()),
                    );
                  },
                ),

                const SizedBox(height: 16),

                _buildMenuItem(
                  context: context,
                  icon: Icons.logout,
                  title: 'Sign Out',
                  onTap: () => _logout(context),
                ),
              ],

              const Spacer(),

              // App Version
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: const [
                    Text(
                      'Discountz Shop',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'v1.0.0',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 28),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white.withOpacity(0.1),
      selectedTileColor: Colors.white.withOpacity(0.2),
    );
  }
}