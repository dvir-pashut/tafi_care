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
    final title = localizations?.title ??
        'tafi care'; // Fallback to 'Default Title' if null

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
    final actions = <Widget>[
      IconButton(
        icon: const Icon(Icons.color_lens),
        onPressed: () => _showColorPicker(context),
        tooltip: 'Background Color',
      ),
    ];

    if (widget.isLoggedIn) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('isLoggedIn');
            await prefs.setBool('isLoggedIn', false);
            await prefs.remove('email');
            await prefs.remove('password');
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/');
            }
          },
          tooltip: AppLocalizations.of(context)?.logout ?? 'Logout',
        ),
      );
    }

    return actions;
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

  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose Background Color'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                _changeColor(Colors.white);
              },
              child: const Text('White'),
            ),
            SimpleDialogOption(
              onPressed: () {
                _changeColor(Colors.lightBlue);
              },
              child: const Text('Light Blue'),
            ),
            SimpleDialogOption(
              onPressed: () {
                _changeColor(Colors.grey);
              },
              child: const Text('Grey'),
            ),
          ],
        );
      },
    );
  }

  void _changeColor(Color color) {
    if (mounted) {
      final colorProvider =
          Provider.of<BackgroundColorProvider>(context, listen: false);
      colorProvider.setColor(color);
      Navigator.pop(context);
    }
  }
}
