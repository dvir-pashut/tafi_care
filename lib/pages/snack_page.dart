import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../mongo_methods/mongo_methods.dart';
import '../l10n/localizations.dart'; // Ensure this is correctly imported
import 'package:intl/intl.dart';

class SnackPage extends StatefulWidget {
  const SnackPage({super.key});

  @override
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
    setState(() => isLoading = true);
    var snacks = await MongoDatabase.getTodaySnackData();
    setState(() {
      snackTimes = snacks.toSet().toList(); // Remove duplicates
      isLoading = false; // Stop loading
      showDeleteOptions = false; // Reset delete options visibility
    });
  }

  void _addSnack() async {
    setState(() => isLoading = true);
    final now = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(now);
    await MongoDatabase.addSnack(formattedTime);
    _fetchSnackData(); // Refresh the snack list
  }

  void _toggleDeleteOptions() {
    setState(() => showDeleteOptions = !showDeleteOptions);
  }

  void _deleteSnack(String time) async {
    setState(() => isLoading = true);
    await MongoDatabase.deleteSnack(time);
    _fetchSnackData(); // Refresh the snack list after deletion
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:  // Navigate to Food Page
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case 1:  // Already on Snack Page
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
        child: isLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                snackTimes.isEmpty
                  ? Text(
                      localizations!.snackQuestion,
                      style: const TextStyle(color: Colors.black, fontSize: 24),
                    )
                  : Text(
                      '${localizations!.snackTimes} ${snackTimes.join(', ')}',
                      style: const TextStyle(color: Colors.black, fontSize: 24),
                    ),
                ElevatedButton(
                  onPressed: _addSnack,
                  child: Text(localizations!.startSnackNow),
                ),
                if (snackTimes.isNotEmpty)
                  ElevatedButton(
                    onPressed: _toggleDeleteOptions,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(localizations.clearSpecificTime),
                  ),
                if (showDeleteOptions)
                  Wrap(
                    spacing: 10,
                    children: snackTimes
                        .map((time) => ElevatedButton(
                              onPressed: () => _deleteSnack(time),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
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
