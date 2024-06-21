import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

const String apiUrlCloudfront = "https://d1cqlij8972v6p.cloudfront.net/prod/lambda";
const String apiUrlNoCache = "https://ty87xd8q40.execute-api.il-central-1.amazonaws.com/prod/lambda";

String currentApiUrl = apiUrlCloudfront;

class MongoDatabase {
  static HttpClient get _httpClient {
    HttpClient client = HttpClient();
    if (kDebugMode) {
      // Allow self-signed certificates in debug mode
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    }
    return client;
  }

  static Future<http.Response> _get(Uri url) async {
    HttpClientRequest request = await _httpClient.getUrl(url);
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    return http.Response(responseBody, response.statusCode);
  }

  static Future<http.Response> _post(Uri url, Map<String, dynamic> body) async {
    HttpClientRequest request = await _httpClient.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    return http.Response(responseBody, response.statusCode);
  }

  static Future<http.Response> _delete(Uri url, Map<String, dynamic> body) async {
    HttpClientRequest request = await _httpClient.deleteUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
    request.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    return http.Response(responseBody, response.statusCode);
  }

  static Future<void> switchToNoCacheUrlTemporarily() async {
    currentApiUrl = apiUrlNoCache;
    // Switch back to CloudFront URL after 5 seconds
    await Future.delayed(const Duration(seconds: 5));
    currentApiUrl = apiUrlCloudfront;
  }

  static Future<bool> checkUserLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<bool> authenticateUser(String email, String password) async {
    final response = await _post(Uri.parse(currentApiUrl), {
      "action": "authenticateUser",
      "email": email,
      "password": password,
    });

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['authenticated'];
    } else {
      print('Error in authenticateUser: ${response.body}');
      return false;
    }
  }

  static Future<Map<String, dynamic>> getTodayDogData() async {
    final response = await _get(Uri.parse('$currentApiUrl?action=getTodayDogData'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error in getTodayDogData: ${response.body}');
      return {};
    }
  }

  static Future<void> updateFoodStatus(bool status) async {
    final response = await _post(Uri.parse(currentApiUrl), {
      "action": "updateFoodStatus",
      "status": status,
    });

    if (response.statusCode == 200) {
      print("Updated food status to ${status ? 'true' : 'false'}");
      await switchToNoCacheUrlTemporarily();
    } else {
      print('Error in updateFoodStatus: ${response.body}');
    }
  }

  static Future<List<String>> getTodaySnackData() async {
    final response = await _get(Uri.parse('$currentApiUrl?action=getTodaySnackData'));

    if (response.statusCode == 200) {
      return List<String>.from(jsonDecode(response.body));
    } else {
      print('Error in getTodaySnackData: ${response.body}');
      return [];
    }
  }

  static Future<void> addSnack(String time) async {
    final response = await _post(Uri.parse(currentApiUrl), {
      "action": "addSnack",
      "time": time,
    });

    if (response.statusCode == 200) {
      print("Added snack time: $time");
      await switchToNoCacheUrlTemporarily();
    } else {
      print('Error in addSnack: ${response.body}');
    }
  }

  static Future<void> deleteSnack(String time) async {
    final response = await _delete(Uri.parse(currentApiUrl), {
      "action": "deleteSnack",
      "time": time,
    });

    if (response.statusCode == 200) {
      print("Deleted snack time: $time");
      await switchToNoCacheUrlTemporarily();
    } else {
      print('Error in deleteSnack: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getWalkTimes() async {
    final response = await _get(Uri.parse('$currentApiUrl?action=getWalkTimes'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error in getWalkTimes: ${response.body}');
      return {"morning": "", "evening": ""};
    }
  }

  static Future<void> updateWalkTime(String period, String? time) async {
    final response = await _post(Uri.parse(currentApiUrl), {
      "action": "updateWalkTime",
      "period": period,
      "time": time,
    });

    if (response.statusCode == 200) {
      print("Updated $period walk time to $time");
      await switchToNoCacheUrlTemporarily();
    } else {
      print('Error in updateWalkTime: ${response.body}');
    }
  }
}
