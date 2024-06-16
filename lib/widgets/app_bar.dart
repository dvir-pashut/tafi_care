import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn; // Added to determine if the logout button should be shown.

  const CustomAppBar({
    super.key,
    this.isLoggedIn = false, // Default to false if not provided.
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      title: const Text('Tafi Care'),
      actions: isLoggedIn ? <Widget>[ // Conditionally add the logout button
        IconButton(
          icon: const Icon(Icons.exit_to_app), // Icon for logout
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('isLoggedIn'); // Remove the logged in flag
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/'); // Navigate to the start/login page
          },
          tooltip: 'Logout',
        ),
      ] : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
