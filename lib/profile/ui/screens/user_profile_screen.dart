import 'package:flutter/material.dart';

/// Placeholder profile tab. Replace with the full profile UI when available.
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('Profile'),
      ),
    );
  }
}
