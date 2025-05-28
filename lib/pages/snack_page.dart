import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../mongo_methods/mongo_methods.dart';
import '../l10n/localizations.dart'; // Ensure this is correctly imported
import 'package:intl/intl.dart';
import '../provider/provider.dart';

class SnackPage extends StatefulWidget {
  const SnackPage({super.key});

  @override
  _SnackPageState createState() => _SnackPageState();
}

class _SnackPageState extends State<SnackPage> {
// 'Snack' is the second item
  List<Map<String, dynamic>> snackTimes = [];
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
      snackTimes = snacks
          .toSet()
          .cast<Map<String, dynamic>>()
          .toList(); // Remove duplicates
      isLoading = false; // Stop loading
      showDeleteOptions = false; // Reset delete options visibility
    });
  }

  void _addSnack() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    setState(() => isLoading = true);
    final now = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(now);
    await MongoDatabase.addSnack(formattedTime, email!);
    _fetchSnackData(); // Refresh the snack list
  }

  void _toggleDeleteOptions() {
    setState(() => showDeleteOptions = !showDeleteOptions);
  }

  void _deleteSnack(String time, String updater) async {
    setState(() => isLoading = true);
    await MongoDatabase.deleteSnack(time, updater);
    _fetchSnackData();
    _fetchSnackData(); // Refresh the snack list after deletion
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0: // Navigate to Food Page
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case 1: // Already on Snack Page
        break;
      case 2: // Navigate to Walk Page
        Navigator.pushReplacementNamed(context, '/walk');
        break;
      case 3: // Navigate to Pupu Page
        Navigator.pushReplacementNamed(context, '/pupu');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Provider.of<BackgroundColorProvider>(context).color,
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  snackTimes.isEmpty
                      ? Text(
                          localizations!.snackQuestion,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 24),
                        )
                      : Text(
                          '${localizations!.snackTimes} ${snackTimes.map((snack) => snack["time"] + " " + localizations.by + " " + snack['updater']).join(', ')}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 24),
                        ),
                  ElevatedButton(
                    onPressed: _addSnack,
                    child: Text(localizations.startSnackNow),
                  ),
                  if (snackTimes.isNotEmpty)
                    ElevatedButton(
                      onPressed: _toggleDeleteOptions,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text(localizations.clearSpecificTime),
                    ),
                  if (showDeleteOptions)
                    Wrap(
                      spacing: 10,
                      children: snackTimes
                          .map((snack) => ElevatedButton(
                                onPressed: () => _deleteSnack(
                                    snack["time"], snack["updater"]),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                                child: Text(snack["time"]),
                              ))
                          .toList(),
                    )
                ],
              ),
      ),
    );
  }
}
