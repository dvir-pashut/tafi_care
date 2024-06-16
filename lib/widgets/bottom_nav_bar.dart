import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({super.key, 
    required this.selectedIndex,
    required this.onItemTapped,
  });
  

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.food_bank),
          label: 'food',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cake),
          label: 'snack',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          label: 'walk',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
