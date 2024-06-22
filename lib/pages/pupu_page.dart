import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mongo_methods/mongo_methods.dart';
import '../l10n/localizations.dart'; // Ensure this is correctly imported
import 'package:intl/intl.dart';

class PupuPage extends StatefulWidget {
  const PupuPage({super.key});

  @override
  _PupuPageState createState() => _PupuPageState();
}

class _PupuPageState extends State<PupuPage> {
// 'Pupu' is the fourth item
  List<Map<String, dynamic>> pupuTimes = [];
  bool isLoading = true;
  bool showDeleteOptions = false;

  @override
  void initState() {
    super.initState();
    _fetchPupuData();
  }

  Future<void> _fetchPupuData() async {
    setState(() => isLoading = true);
    var pupus = await MongoDatabase.getTodayPupuData();
    setState(() {
      pupuTimes = pupus.toSet().cast<Map<String, dynamic>>().toList(); // Remove duplicates
      isLoading = false; // Stop loading
      showDeleteOptions = false; // Reset delete options visibility
    });
  }

  void _addPupu() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    setState(() => isLoading = true);
    final now = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(now);
    await MongoDatabase.addPupu(formattedTime, email!);
    _fetchPupuData(); // Refresh the pupu list
  }

  void _toggleDeleteOptions() {
    setState(() => showDeleteOptions = !showDeleteOptions);
  }

  void _deletePupu(String time, String updater) async {
    setState(() => isLoading = true);
    await MongoDatabase.deletePupu(time, updater);
    _fetchPupuData(); // Refresh the pupu list after deletion
  }

  void _onItemTapped(int index) {

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
      case 3:  // Already on Pupu Page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: isLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pupuTimes.isEmpty
                  ? Text(
                      localizations!.pupuQuestion,
                      style: const TextStyle(color: Colors.black, fontSize: 24),
                    )
                  : Text(
                      '${localizations!.pupuTimes} ${pupuTimes.map((pupu) => pupu["time"] + " " + localizations.by + " " + pupu['updater']).join(', ') }',
                      style: const TextStyle(color: Colors.black, fontSize: 24),
                    ),
                ElevatedButton(
                  onPressed: _addPupu,
                  child: Text(localizations.startPupuNow),
                ),
                if (pupuTimes.isNotEmpty)
                  ElevatedButton(
                    onPressed: _toggleDeleteOptions,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(localizations.clearSpecificTime),
                  ),
                if (showDeleteOptions)
                  Wrap(
                    spacing: 10,
                    children: pupuTimes
                        .map((pupu) => ElevatedButton(
                              onPressed: () => _deletePupu(pupu["time"], pupu["updater"]),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                              child: Text(pupu["time"]),
                            ))
                        .toList(),
                  )
              ],
            ),
      ),
    );
  }
}
