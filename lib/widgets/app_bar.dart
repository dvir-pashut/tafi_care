import 'package:flutter/material.dart';
import 'package:flutter_app/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/localizations.dart'; // Ensure this is correctly imported

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  const CustomAppBar({super.key, this.isLoggedIn = false});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final title = localizations?.title ?? 'tafi care'; // Fallback to 'Default Title' if null

    return AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.language),
        onPressed: () => _showLanguagePicker(context),
      ),
      title: Text(title),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    if (!widget.isLoggedIn) {
      return [];
    }

    return [
      IconButton(
        icon: const Icon(Icons.exit_to_app),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('isLoggedIn');
          await prefs.setBool('isLoggedIn', false);
          await prefs.remove('email');
          await prefs.remove('password');
          // Use mounted check to prevent setState if widget is not in tree
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
        tooltip: AppLocalizations.of(context)?.logout ?? 'Logout', // Handle null with fallback
      ),
    ];
  }

  void _showLanguagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose Language'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                _changeLanguage(const Locale('en', 'US'));
              },
              child: const Text('English'),
            ),
            SimpleDialogOption(
              onPressed: () {
                _changeLanguage(const Locale('he', 'IL'));
              },
              child: const Text('עברית'), // Hebrew
            ),
                        SimpleDialogOption(
              onPressed: () {
                _changeLanguage(const Locale('zh', 'ZH'));
              },
              child: const Text('סינית'), // Hebrew
            ),
          ],
        );
      },
    );
  }

  void _changeLanguage(Locale newLocale) {
    if (mounted) {
      final localeProvider =
          Provider.of<LocaleProvider>(context, listen: false);
      localeProvider.setLocale(newLocale);
      Navigator.pop(context); // Close the dialog after changing the language
    }
  }
}
