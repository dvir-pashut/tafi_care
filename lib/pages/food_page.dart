import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _updater = "";

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
        _foodGiven = data.isNotEmpty && data['food']['status'] == 'true';
        _updater = data['food']['updater'];
        print('Food given status: $_foodGiven Updater: $_updater');
      });
    } catch (e) {
      print('Error fetching food data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onFoodButtonPressed() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    setState(() => _isLoading = true);  // Start loading

    try {
      await MongoDatabase.updateFoodStatus(true, email!);
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
      await MongoDatabase.updateFoodStatus(false, "");
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
      case 3:  // Navigate to Pupu Page
        Navigator.pushReplacementNamed(context, '/pupu');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: _isLoading 
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  _foodGiven 
                  ? Text(
                    '${localizations!.foodGivenToday}  ${localizations.by} $_updater',
                    style: const TextStyle(color: Colors.black, fontSize: 30),
                  )
                  : Text(
                    localizations!.foodQuestion,
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
    );
  }
}
