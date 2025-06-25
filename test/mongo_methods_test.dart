import 'package:flutter_test/flutter_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_app/mongo_methods/mongo_methods.dart';

void main() {
  test('switchToNoCacheUrlTemporarily changes URL temporarily', () {
    fakeAsync((async) {
      currentApiUrl = apiUrlCloudfront;
      MongoDatabase.switchToNoCacheUrlTemporarily();
      expect(currentApiUrl, apiUrlNoCache);
      async.elapse(const Duration(seconds: 5));
      expect(currentApiUrl, apiUrlCloudfront);
    });
  });
}
