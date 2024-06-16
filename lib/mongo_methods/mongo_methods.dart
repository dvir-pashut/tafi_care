import 'package:mongo_dart/mongo_dart.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String mongoUriUsers = "mongodb://root:IIOvTEH6qmRzInkh@ac-rkih2hp-shard-00-00.xnwn2xw.mongodb.net:27017,ac-rkih2hp-shard-00-01.xnwn2xw.mongodb.net:27017,ac-rkih2hp-shard-00-02.xnwn2xw.mongodb.net:27017/Users?authSource=admin&compressors=disabled&gssapiServiceName=mongodb&replicaSet=atlas-stcn2i-shard-0&ssl=true";

const String mongoUriDogStuff = "mongodb://root:IIOvTEH6qmRzInkh@ac-rkih2hp-shard-00-00.xnwn2xw.mongodb.net:27017,ac-rkih2hp-shard-00-01.xnwn2xw.mongodb.net:27017,ac-rkih2hp-shard-00-02.xnwn2xw.mongodb.net:27017/dog-is-fed?authSource=admin&compressors=disabled&gssapiServiceName=mongodb&replicaSet=atlas-stcn2i-shard-0&ssl=true";

class MongoDatabase {
  static Future<bool> checkUserLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<bool> authenticateUser(String email, String password) async {
    try {
      var db = await Db.create(mongoUriUsers);
      await db.open();
      print("Connected to users database");

      final collection = db.collection('users');
      final user = await collection.findOne(where.eq('email', email).eq('password', password));
      await db.close();
      print("User authentication ${user != null ? 'successful' : 'failed'}");
      return user != null;
    } catch (e) {
      print('Error in authenticateUser: $e');
      return false;
    }
  }

  static Future<DbCollection> _getTodayCollection() async {
    try {
      var db = await Db.create(mongoUriDogStuff);
      await db.open();
      print("Connected to dog-is-fed database");

      final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
      final collection = db.collection(today);

      final exists = await collection.count() > 0;
      if (!exists) {
        await collection.insertOne({
          "food": "",
          "snack": [],
          "walk": {"morning": "", "evening": ""}
        });
      }

      print("Accessed today's collection: $today");
      return collection;
    } catch (e) {
      print('Error in _getTodayCollection: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getTodayDogData() async {
    try {
      final collection = await _getTodayCollection();
      final data = await collection.findOne();
      print("Today's data: $data");
      return data ?? {};
    } catch (e) {
      print('Error in getTodayDogData: $e');
      return {};
    }
  }

  static Future<void> updateFoodStatus(bool status) async {
    try {
      final collection = await _getTodayCollection();
      await collection.updateOne(
        where.exists('food'),
        modify.set('food', status ? 'true' : 'false'),
      );
      print("Updated food status to ${status ? 'true' : 'false'}");
    } catch (e) {
      print('Error in updateFoodStatus: $e');
    }
  }

  static Future<List<String>> getTodaySnackData() async {
    try {
      final collection = await _getTodayCollection();
      final data = await collection.findOne();
      print("Today's snack data: ${data?['snack']}");
      return data?['snack'].cast<String>() ?? [];
    } catch (e) {
      print('Error in getTodaySnackData: $e');
      return [];
    }
  }

  static Future<void> addSnack(String time) async {
    try {
      final collection = await _getTodayCollection();
      await collection.updateOne(
        where.exists('snack'),
        modify.push('snack', time),
      );
      print("Added snack time: $time");
    } catch (e) {
      print('Error in addSnack: $e');
    }
  }

  static Future<void> deleteSnack(String time) async {
    try {
      final collection = await _getTodayCollection();
      await collection.updateOne(
        where.exists('snack'),
        modify.pull('snack', time),
      );
      print("Deleted snack time: $time");
    } catch (e) {
      print('Error in deleteSnack: $e');
    }
  }

  static Future<Map<String, dynamic>> getWalkTimes() async {
    try {
      var db = await Db.create(mongoUriDogStuff);
      await db.open();
      var collection = db.collection(DateFormat('dd-MM-yyyy').format(DateTime.now()));
      var data = await collection.findOne();
      print("Today's walk times: ${data?['walk']}");
      await db.close();
      return data?['walk'] ?? {"morning": "", "evening": ""};
    } catch (e) {
      print('Error in getWalkTimes: $e');
      return {"morning": "", "evening": ""};
    }
  }

  static Future<void> updateWalkTime(String period, String? time) async {
    try {
      var db = await Db.create(mongoUriDogStuff);
      await db.open();
      var collection = db.collection(DateFormat('dd-MM-yyyy').format(DateTime.now()));
      await collection.updateOne(
        where.exists('walk'),
        modify.set('walk.$period', time ?? "")
      );
      print("Updated $period walk time to $time");
      await db.close();
    } catch (e) {
      print('Error in updateWalkTime: $e');
    }
  }
}
