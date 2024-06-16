import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../mongo_methods/mongo_methods.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  String _displayText = '?האכלת את טאפי היום';
  bool _foodGiven = false;  // Adjust this to track if food has been given
  bool _isLoading = true;  // Track loading state
  int _selectedIndex = 0;  // Initial index for bottom nav

  @override
  void initState() {
    super.initState();
    _checkTodayData();
  }

  void _checkTodayData() async {
    setState(() {
      _isLoading = true;  // Start loading
    });
    
    final data = await MongoDatabase.getTodayDogData();
    if (data.isNotEmpty && data['food'] == 'true') {
      setState(() {
        _displayText = '!טאפי הואכלה היום';
        _foodGiven = true;  // Food has been given
        _isLoading = false;  // Stop loading
      });
    } else {
      setState(() {
        _displayText = '?האכלת את טאפי היום';
        _foodGiven = false;  // Food has not been given
        _isLoading = false;  // Stop loading
      });
    }
  }

  void _onFoodButtonPressed() async {
    setState(() {
      _isLoading = true;  // Start loading
    });
    
    await MongoDatabase.updateFoodStatus(true);
    setState(() {
      _displayText = '!טאפי הואכלה היום';
      _foodGiven = true;
      _isLoading = false;  // Stop loading
    });
  }

  void _onUndoFoodButtonPressed() async {
    setState(() {
      _isLoading = true;  // Start loading
    });

    await MongoDatabase.updateFoodStatus(false);
    setState(() {
      _displayText = '?האכלת את טאפי היום';
      _foodGiven = false;
      _isLoading = false;  // Stop loading
    });
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
    return Scaffold(
      appBar: const CustomAppBar(isLoggedIn: true),
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: _isLoading 
            ? const CircularProgressIndicator()  // Show loading indicator while loading
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    _displayText,
                    style: const TextStyle(color: Colors.black, fontSize: 30),
                  ),
                  const SizedBox(height: 20),
                  if (!_foodGiven)  // Show this button only if food hasn't been given
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: _onFoodButtonPressed,
                      child: const Icon(Icons.check),
                    ),
                  if (_foodGiven)  // Show this button only if food has been given
                    ElevatedButton(
                      onPressed: _onUndoFoodButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('I did not feed her, it\'s a mistake'),
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
