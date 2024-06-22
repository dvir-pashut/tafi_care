import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mongo_methods/mongo_methods.dart';
import '../l10n/localizations.dart'; // Ensure this is correctly imported
import 'package:intl/intl.dart';

class WalkPage extends StatefulWidget {
  const WalkPage({super.key});

  @override
  _WalkPageState createState() => _WalkPageState();
}

class _WalkPageState extends State<WalkPage> {
// 'Walk' is the third item
  Map<String, dynamic> walkTimes = {"morning": {"time": "", "updater": ""}, "evening": {"time": "", "updater": ""}};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWalkTimes();
  }

  void fetchWalkTimes() async {
    setState(() => isLoading = true);
    walkTimes = await MongoDatabase.getWalkTimes();
    setState(() => isLoading = false);
  }

  void updateWalkTime(String period) async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    setState(() => isLoading = true);
    String time = DateFormat('HH:mm').format(DateTime.now());
    await MongoDatabase.updateWalkTime(period, time, email!);
    fetchWalkTimes();
  }

  void clearWalkTime(String period) async {
    setState(() => isLoading = true);
    await MongoDatabase.updateWalkTime(period, "", "");
    fetchWalkTimes();
  }

  void _onItemTapped(int index) {
    setState(() {
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/snack');
        break;
      case 2:
        break;  // Already on Walk Page
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
        child: isLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildWalkPeriodUI('morning', localizations),
                buildWalkPeriodUI('evening', localizations),
              ],
            ),
      ),

    );
  }

  Widget buildWalkPeriodUI(String period, AppLocalizations? localizations) {
    Map<String, dynamic> periodData = walkTimes[period];
    String time = periodData["time"];
    String updater = periodData['updater'];
    bool hasTime = time.isNotEmpty;
  
    return Column(
      children: [
        Text(
          hasTime 
            ? '${period == "morning" ? localizations!.walkPeriodMorning : localizations!.walkPeriodEvening}: $time ${localizations.by} $updater ' 
            : (period == "morning" ? localizations!.walkNotYetMorning : localizations!.walkNotYetEvening),
          style: const TextStyle(color: Colors.black, fontSize: 24),
        ),
        hasTime
          ? ElevatedButton(
              onPressed: () => clearWalkTime(period),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: Text(localizations.clear),
            )
          : ElevatedButton(
              onPressed: () => updateWalkTime(period),
              child: Text(localizations.startWalkNow),
            ),
      ],
    );
  }
}
