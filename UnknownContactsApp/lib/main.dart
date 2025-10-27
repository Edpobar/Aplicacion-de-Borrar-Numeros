import 'package:flutter/material.dart';
import 'package:unknown_contacts_app/pages/login_page.dart';

void main() {
  runApp(const UnknownContactsApp());
}

class UnknownContactsApp extends StatelessWidget {
  const UnknownContactsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unknown Contacts Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
