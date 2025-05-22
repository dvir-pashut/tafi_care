import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:shared_preferences/shared_preferences.dart';

const String apiUrlCloudfront =
    "https://d1cqlij8972v6p.cloudfront.net/prod/lambda";
const String apiUrlNoCache =
    "https://ty87xd8q40.execute-api.il-central-1.amazonaws.com/prod/lambda";

String currentApiUrl = apiUrlCloudfront;

// Cache keys for local persistence
const String _dogCacheKey = 'cache_today_dog_data';
const String _dogIndexKey = 'cache_today_dog_data_index';
const String _snackCacheKey = 'cache_today_snack_data';
const String _snackIndexKey = 'cache_today_snack_data_index';
const String _walkCacheKey = 'cache_walk_times';
const String _walkIndexKey = 'cache_walk_times_index';
const String _pupuCacheKey = 'cache_today_pupu_data';
const String _pupuIndexKey = 'cache_today_pupu_data_index';

class MongoDatabase {
  static Future<http.Response> _get(Uri url) async {
    if (kIsWeb) {
      return await http.get(url);
    } else {
      return await _getMobile(url);
    }
  }

  static Future<http.Response> _post(Uri url, Map<String, dynamic> body) async {
    if (kIsWeb) {
      return await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));
    } else {
      return await _postMobile(url, body);
    }
  }

  static Future<http.Response> _delete(
      Uri url, Map<String, dynamic> body) async {
    if (kIsWeb) {
      return await http.delete(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));
    } else {
      return await _deleteMobile(url, body);
    }
  }

  static Future<http.Response> _getMobile(Uri url) async {
    io.HttpClient client = _httpClient;
    io.HttpClientRequest request = await client.getUrl(url);
    io.HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    return http.Response(responseBody, response.statusCode);
  }

  static Future<http.Response> _postMobile(
      Uri url, Map<String, dynamic> body) async {
    io.HttpClient client = _httpClient;
    io.HttpClientRequest request = await client.postUrl(url);
    request.headers.set(io.HttpHeaders.contentTypeHeader, "application/json");
    request.add(utf8.encode(jsonEncode(body)));
    io.HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    return http.Response(responseBody, response.statusCode);
  }

  static Future<http.Response> _deleteMobile(
      Uri url, Map<String, dynamic> body) async {
    io.HttpClient client = _httpClient;
    io.HttpClientRequest request = await client.deleteUrl(url);
    request.headers.set(io.HttpHeaders.contentTypeHeader, "application/json");
    request.add(utf8.encode(jsonEncode(body)));
    io.HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    return http.Response(responseBody, response.statusCode);
  }

  static Future<void> _clearCache(String dataKey, String indexKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(dataKey);
    await prefs.remove(indexKey);
  }

  static Future<DateTime?> _fetchRemoteIndex(String action) async {
    try {
      final response = await _get(Uri.parse('$currentApiUrl?action=$action'));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return DateTime.tryParse(body['updatedAt'] ?? body['date'] ?? '');
      }
    } catch (_) {}
    return null;
  }

  static Future<Map<String, dynamic>> _getMapWithCache({
    required String dataAction,
    required String indexAction,
    required String cacheKey,
    required String indexKey,
    Map<String, dynamic>? defaultValue,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(cacheKey);
    final cachedIndex = prefs.getString(indexKey);
    final remoteIndex = await _fetchRemoteIndex(indexAction);

    if (remoteIndex != null &&
        cachedData != null &&
        cachedIndex == remoteIndex.toIso8601String()) {
      return jsonDecode(cachedData);
    }

    final response = await _get(Uri.parse('$currentApiUrl?action=$dataAction'));
    if (response.statusCode == 200) {
      await prefs.setString(cacheKey, response.body);
      if (remoteIndex != null) {
        await prefs.setString(indexKey, remoteIndex.toIso8601String());
      }
      return jsonDecode(response.body);
    } else {
      if (cachedData != null) {
        return jsonDecode(cachedData);
      }
      return defaultValue ?? {};
    }
  }

  static Future<List<Map<String, dynamic>>> _getListWithCache({
    required String dataAction,
    required String indexAction,
    required String cacheKey,
    required String indexKey,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(cacheKey);
    final cachedIndex = prefs.getString(indexKey);
    final remoteIndex = await _fetchRemoteIndex(indexAction);

    if (remoteIndex != null &&
        cachedData != null &&
        cachedIndex == remoteIndex.toIso8601String()) {
      return List<Map<String, dynamic>>.from(jsonDecode(cachedData));
    }

    final response = await _get(Uri.parse('$currentApiUrl?action=$dataAction'));
    if (response.statusCode == 200) {
      await prefs.setString(cacheKey, response.body);
      if (remoteIndex != null) {
        await prefs.setString(indexKey, remoteIndex.toIso8601String());
      }
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      if (cachedData != null) {
        return List<Map<String, dynamic>>.from(jsonDecode(cachedData));
      }
      return [];
    }
  }

  static io.HttpClient get _httpClient {
    io.HttpClient client = io.HttpClient();
    if (kDebugMode) {
      client.badCertificateCallback =
          (io.X509Certificate cert, String host, int port) => true;
    }
    return client;
  }

  static Future<void> switchToNoCacheUrlTemporarily() async {
    currentApiUrl = apiUrlNoCache;
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
    return await _getMapWithCache(
      dataAction: 'getTodayDogData',
      indexAction: 'getTodayDogDataIndex',
      cacheKey: _dogCacheKey,
      indexKey: _dogIndexKey,
    );
  }

  static Future<void> updateFoodStatus(bool status, String email) async {
    final response = await _post(Uri.parse(currentApiUrl), {
      "action": "updateFoodStatus",
      "status": status,
      "username": email,
    });
    print("updating food status to $status with email $email");
    if (response.statusCode == 200) {
      print("Updated food status to ${status ? 'true' : 'false'}");
      await _clearCache(_dogCacheKey, _dogIndexKey);
      await switchToNoCacheUrlTemporarily();
    } else {
      print('Error in updateFoodStatus: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getTodaySnackData() async {
    return await _getListWithCache(
      dataAction: 'getTodaySnackData',
      indexAction: 'getTodaySnackDataIndex',
      cacheKey: _snackCacheKey,
      indexKey: _snackIndexKey,
    );
  }

  static Future<void> addSnack(String time, String email) async {
    final response = await _post(Uri.parse(currentApiUrl),
        {"action": "addSnack", "time": time, "username": email});

    if (response.statusCode == 200) {
      print("Added snack time: $time");
      await _clearCache(_snackCacheKey, _snackIndexKey);
      await switchToNoCacheUrlTemporarily();
    } else {
      print('Error in addSnack: ${response.body}');
    }
  }

  static Future<void> deleteSnack(String time, String email) async {
    final response = await _delete(Uri.parse(currentApiUrl),
        {"action": "deleteSnack", "time": time, "username": email});

    if (response.statusCode == 200) {
      print("Deleted snack time: $time");
      await _clearCache(_snackCacheKey, _snackIndexKey);
    } else {
      print('Error in deleteSnack: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getWalkTimes() async {
    return await _getMapWithCache(
      dataAction: 'getWalkTimes',
      indexAction: 'getWalkTimesIndex',
      cacheKey: _walkCacheKey,
      indexKey: _walkIndexKey,
      defaultValue: {
        "morning": {"time": "", "updater": ""},
        "evening": {"time": "", "updater": ""}
      },
    );
  }

  static Future<void> updateWalkTime(
      String period, String? time, String email) async {
    print(period);
    print(time);
    print(email);
    final response = await _post(Uri.parse(currentApiUrl), {
      "action": "updateWalkTime",
      "period": period,
      "time": time,
      "username": email
    });

    if (response.statusCode == 200) {
      print("Updated $period walk time to $time");
      await _clearCache(_walkCacheKey, _walkIndexKey);
      await switchToNoCacheUrlTemporarily();
    } else {
      print('Error in updateWalkTime: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> getTodayPupuData() async {
    return await _getListWithCache(
      dataAction: 'getTodayPupuData',
      indexAction: 'getTodayPupuDataIndex',
      cacheKey: _pupuCacheKey,
      indexKey: _pupuIndexKey,
    );
  }

  static Future<void> addPupu(String time, String email) async {
    final response = await _post(Uri.parse(currentApiUrl),
        {"action": "addPupu", "time": time, "username": email});

    if (response.statusCode == 200) {
      print("Added pupu time: $time");
      await _clearCache(_pupuCacheKey, _pupuIndexKey);
      await switchToNoCacheUrlTemporarily();
    } else {
      print('Error in addPupu: ${response.body}');
    }
  }

  static Future<void> deletePupu(String time, String email) async {
    final response = await _delete(Uri.parse(currentApiUrl), {
      "action": "deletePupu",
      "time": time,
      "username": email,
    });

    if (response.statusCode == 200) {
      print("Deleted pupu time: $time");
      await _clearCache(_pupuCacheKey, _pupuIndexKey);
    } else {
      print('Error in deletePupu: ${response.body}');
    }
  }
}
