import 'package:flutter/material.dart';
import '../l10n/localizations.dart'; // Import your localizations

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key, 
    required this.selectedIndex,
    required this.onItemTapped,
  });
  

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context)!; // Get localization instance

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.food_bank),
          label: labels.foodLabel, // Localized label
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cake),
          label: labels.snacksLabel, // Localized label
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          label: labels.walksLabel, // Localized label
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
