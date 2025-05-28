import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/widgets/app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp({required bool loggedIn}) {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: MaterialApp(
        home: Scaffold(appBar: CustomAppBar(isLoggedIn: loggedIn)),
      ),
    );
  }

  testWidgets('logout icon visibility depends on login state', (tester) async {
    await tester.pumpWidget(buildApp(loggedIn: true));
    expect(find.byIcon(Icons.exit_to_app), findsOneWidget);

    await tester.pumpWidget(buildApp(loggedIn: false));
    expect(find.byIcon(Icons.exit_to_app), findsNothing);
  });
}
