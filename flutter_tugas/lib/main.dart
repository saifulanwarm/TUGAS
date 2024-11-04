import 'package:flutter/material.dart';
import 'package:flutter_tugas/screens/home.dart';
import 'package:flutter_tugas/screens/user_list.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Route awal sebagai halaman utama
      routes: {
        '/': (context) => HomePage(), // Rute ke halaman utama (HomePage)
        '/userList': (context) =>
            const UserListPage(), // Rute ke halaman UserListPage
      },
    );
  }
}
