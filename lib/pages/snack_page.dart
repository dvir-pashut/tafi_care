import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../mongo_methods/mongo_methods.dart';
import 'package:intl/intl.dart';

class SnackPage extends StatefulWidget {
  const SnackPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SnackPageState createState() => _SnackPageState();
}

class _SnackPageState extends State<SnackPage> {
  int _selectedIndex = 1;  // 'Snack' is the second item
  List<String> snackTimes = [];
  bool isLoading = true;
  bool showDeleteOptions = false;

  @override
  void initState() {
    super.initState();
    _fetchSnackData();
  }

  Future<void> _fetchSnackData() async {
    setState(() {
      isLoading = true; // Start loading
    });
    var snacks = await MongoDatabase.getTodaySnackData();
    setState(() {
      snackTimes = snacks.toSet().toList(); // Remove duplicates
      isLoading = false; // Stop loading
      showDeleteOptions = false; // Reset delete options visibility
    });
  }

  void _addSnack() async {
    setState(() {
      isLoading = true; // Start loading
    });
    final now = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(now);
    await MongoDatabase.addSnack(formattedTime);
    _fetchSnackData(); // Refresh the snack list
  }

  void _toggleDeleteOptions() {
    setState(() {
      showDeleteOptions = !showDeleteOptions; // Toggle delete options visibility
    });
  }

  void _deleteSnack(String time) async {
    setState(() {
      isLoading = true; // Start loading
    });
    await MongoDatabase.deleteSnack(time);
    _fetchSnackData(); // Refresh the snack list after deletion
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
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (snackTimes.isEmpty)
                    const Text(
                      'לא קיבלה חטיפים עדיין ',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    )
                  else
                    Text(
                      '${snackTimes.join(', ')}:קיבלה חטיפים ב',
                      style: const TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ElevatedButton(
                    onPressed: _addSnack,
                    child: const Text('נתתי לה חטיף עכשיו'),
                  ),
                  if (snackTimes.isNotEmpty)
                    ElevatedButton(
                      onPressed: _toggleDeleteOptions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Button color
                      ),
                      child: const Text('מחק שעה ספציפית'),
                    ),
                  if (showDeleteOptions)
                    Wrap(
                      spacing: 10,
                      children: snackTimes
                          .map((time) => ElevatedButton(
                                onPressed: () => _deleteSnack(time),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent, // Button color
                                ),
                                child: Text(time),
                              ))
                          .toList(),
                    )
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
