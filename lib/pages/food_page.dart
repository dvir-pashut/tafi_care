import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../mongo_methods/mongo_methods.dart';
import '../l10n/localizations.dart'; 

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  bool _foodGiven = false;
  bool _isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkTodayData();
  }

  void _checkTodayData() async {
    setState(() => _isLoading = true);  // Start loading

    try {
      final data = await MongoDatabase.getTodayDogData();
      setState(() {
        _isLoading = false;  // Stop loading
        _foodGiven = data.isNotEmpty && data['food'] == 'true';
        print('Food given status: $_foodGiven');
      });
    } catch (e) {
      print('Error fetching food data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onFoodButtonPressed() async {
    setState(() => _isLoading = true);  // Start loading

    try {
      await MongoDatabase.updateFoodStatus(true);
      setState(() {
        _foodGiven = true;
        _isLoading = false;  // Stop loading
      });
    } catch (e) {
      print('Error updating food status: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onUndoFoodButtonPressed() async {
    setState(() => _isLoading = true);  // Start loading

    try {
      await MongoDatabase.updateFoodStatus(false);
      setState(() {
        _foodGiven = false;
        _isLoading = false;  // Stop loading
      });
    } catch (e) {
      print('Error undoing food status: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:  // Navigate to Food Page
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case 1:  // Navigate to Snack Page
        Navigator.pushReplacementNamed(context, '/snack');
        break;
      case 2:  // Navigate to Walk Page
        Navigator.pushReplacementNamed(context, '/walk');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: const CustomAppBar(isLoggedIn: true),
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: _isLoading 
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    _foodGiven ? localizations!.foodGivenToday : localizations!.foodQuestion,
                    style: const TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  if (!_foodGiven)
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: _onFoodButtonPressed,
                      child: const Icon(Icons.check),
                    ),
                  if (_foodGiven)
                    ElevatedButton(
                      onPressed: _onUndoFoodButtonPressed,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(localizations.undo),
                    ),
                ],
              ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
