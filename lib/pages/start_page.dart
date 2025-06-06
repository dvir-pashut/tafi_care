import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar.dart';
import '../mongo_methods/mongo_methods.dart';
import '../l10n/localizations.dart';
import '../provider/provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCredentialsAndLogin();
  }

  Future<void> _loadCredentialsAndLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');
    if (email != null && password != null) {
      _emailController.text = email;
      _passwordController.text = password;
      await _login();
    }
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    final email = _emailController.text;
    final password = _passwordController.text;

    final isAuthenticated =
        await MongoDatabase.authenticateUser(email, password);
    if (isAuthenticated) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)?.authenticationFailed ??
                'Authentication Failed')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Provider.of<BackgroundColorProvider>(context).color,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations?.welcome ??
                  'Welcome', // Fallback to 'Welcome' if null
              style: const TextStyle(color: Colors.black, fontSize: 30),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: localizations?.username ??
                        'Username'), // Fallback to 'Username'
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: localizations?.password ??
                        'Password'), // Fallback to 'Password'
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text(
                        localizations?.login ?? 'Login'), // Fallback to 'Login'
                  ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
