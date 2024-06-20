import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrl = "https://ty87xd8q40.execute-api.il-central-1.amazonaws.com/prod/lambda";

class MongoDatabase {
  static Future<bool> checkUserLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<bool> authenticateUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "authenticateUser",
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['authenticated'];
    } else {
      print('Error in authenticateUser: ${response.body}');
      return false;
    }
  }

  static Future<Map<String, dynamic>> getTodayDogData() async {
    final response = await http.get(
      Uri.parse('$apiUrl?action=getTodayDogData'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error in getTodayDogData: ${response.body}');
      return {};
    }
  }

  static Future<void> updateFoodStatus(bool status) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "updateFoodStatus",
        "status": status,
      }),
    );

    if (response.statusCode == 200) {
      print("Updated food status to ${status ? 'true' : 'false'}");
    } else {
      print('Error in updateFoodStatus: ${response.body}');
    }
  }

  static Future<List<String>> getTodaySnackData() async {
    final response = await http.get(
      Uri.parse('$apiUrl?action=getTodaySnackData'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      print('Error in getTodaySnackData: ${response.body}');
      return [];
    }
  }

  static Future<void> addSnack(String time) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "addSnack",
        "time": time,
      }),
    );

    if (response.statusCode == 200) {
      print("Added snack time: $time");
    } else {
      print('Error in addSnack: ${response.body}');
    }
  }

  static Future<void> deleteSnack(String time) async {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "deleteSnack",
        "time": time,
      }),
    );

    if (response.statusCode == 200) {
      print("Deleted snack time: $time");
    } else {
      print('Error in deleteSnack: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getWalkTimes() async {
    final response = await http.get(
      Uri.parse('$apiUrl?action=getWalkTimes'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error in getWalkTimes: ${response.body}');
      return {"morning": "", "evening": ""};
    }
  }

  static Future<void> updateWalkTime(String period, String? time) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "updateWalkTime",
        "period": period,
        "time": time,
      }),
    );

    if (response.statusCode == 200) {
      print("Updated $period walk time to $time");
    } else {
      print('Error in updateWalkTime: ${response.body}');
    }
  }
}
