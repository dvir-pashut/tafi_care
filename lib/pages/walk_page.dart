import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../mongo_methods/mongo_methods.dart';
import 'package:intl/intl.dart';

class WalkPage extends StatefulWidget {
  const WalkPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WalkPageState createState() => _WalkPageState();
}

class _WalkPageState extends State<WalkPage> {
  int _selectedIndex = 2;  // 'Walk' is the third item
  Map<String, dynamic> walkTimes = {"morning": "", "evening": ""};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWalkTimes();
  }

  void fetchWalkTimes() async {
    setState(() {
      isLoading = true;
    });
    walkTimes = await MongoDatabase.getWalkTimes();
    setState(() {
      isLoading = false;
    });
  }

  void updateWalkTime(String period) async {
    String time = DateFormat('HH:mm').format(DateTime.now());
    await MongoDatabase.updateWalkTime(period, time);
    fetchWalkTimes();
  }

  void clearWalkTime(String period) async {
    await MongoDatabase.updateWalkTime(period, null);
    fetchWalkTimes();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/main');  // Navigate to Food Page
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/snack');  // Navigate to Snack Page
        break;
      case 2:
        break;  // Already on Walk Page
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
                buildWalkPeriodUI('morning'),
                buildWalkPeriodUI('evening'),
              ],
            ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget buildWalkPeriodUI(String period) {
    String time = walkTimes[period];
    bool hasTime = time.isNotEmpty;
    String Hperiod = period == 'evening' ? 'ערב' : 'בוקר';
  
    return Column(
      children: [
        Text(
          hasTime ? 'טיול $Hperiod: $time' : '$Hperiod עדיין לא קרה',
          style: const TextStyle(color: Colors.black, fontSize: 24),
        ),
        hasTime
          ? ElevatedButton(
              onPressed: () => clearWalkTime(period),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('מחיקה'),
            )
          : ElevatedButton(
              onPressed: () => updateWalkTime(period),
              child: const Text('הוצאתי אותה לטיול עכשיו'),
            ),
      ],
    );
  }
}
