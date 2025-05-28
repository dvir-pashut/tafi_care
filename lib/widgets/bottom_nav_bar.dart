import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/localizations.dart'; // Import your localizations
import '../provider/provider.dart';

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
      type: BottomNavigationBarType.fixed, // Ensures labels are always visible
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.food_bank),
          label: labels.foodLabel, // Localized label
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.cake),
          label: labels.snacksLabel, // Localized label
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.directions_run),
          label: labels.walksLabel, // Localized label
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.pets),
          label: labels.pupuLabel, // Localized label for pupu
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.green[700], // Color for selected item
      unselectedItemColor: Colors.black, // Color for unselected items
      onTap: onItemTapped,
      backgroundColor: Provider.of<BackgroundColorProvider>(context).color,
    );
  }
}
