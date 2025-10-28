// src/screens/login_screen.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(hintText: 'Email')),
            const SizedBox(height: 10),
            TextField(obscureText: true, decoration: const InputDecoration(hintText: 'Password')),
            const SizedBox(height: 16),
            FilledButton(onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                child: const Text('Sign in')),
            const SizedBox(height: 10),
            TextButton(onPressed: () {}, child: Text('Forgot password?', style: TextStyle(color: cs.primary))),
          ],
        ),
      ),
    );
  }
}
