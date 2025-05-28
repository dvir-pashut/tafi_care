import 'package:flutter_app/mongo_methods/mongo_methods.dart';

/// Simple fake implementation of [DatabaseService] used in tests.
class FakeMongoService implements DatabaseService {
  bool authResult;
  Map<String, dynamic> dogData;
  List<Map<String, dynamic>> snackData;
  Map<String, dynamic> walkTimes;
  List<Map<String, dynamic>> pupuData;

  FakeMongoService({
    this.authResult = true,
    Map<String, dynamic>? dogData,
    List<Map<String, dynamic>>? snackData,
    Map<String, dynamic>? walkTimes,
    List<Map<String, dynamic>>? pupuData,
  }) : dogData = dogData ?? const {},
       snackData = snackData ?? const [],
       walkTimes =
           walkTimes ??
           const {
             'morning': {'time': '', 'updater': ''},
             'evening': {'time': '', 'updater': ''},
           },
       pupuData = pupuData ?? const [];

  @override
  Future<void> addPupu(String time, String email) async {}

  @override
  Future<void> addSnack(String time, String email) async {}

  @override
  Future<bool> authenticateUser(String email, String password) async =>
      authResult;

  @override
  Future<void> deletePupu(String time, String email) async {}

  @override
  Future<void> deleteSnack(String time, String email) async {}

  @override
  Future<Map<String, dynamic>> getTodayDogData() async => dogData;

  @override
  Future<List<Map<String, dynamic>>> getTodayPupuData() async => pupuData;

  @override
  Future<List<Map<String, dynamic>>> getTodaySnackData() async => snackData;

  @override
  Future<Map<String, dynamic>> getWalkTimes() async => walkTimes;

  @override
  Future<void> updateFoodStatus(bool status, String email) async {}

  @override
  Future<void> updateWalkTime(
    String period,
    String? time,
    String email,
  ) async {}
}
