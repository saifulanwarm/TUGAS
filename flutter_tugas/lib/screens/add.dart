import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/user.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Ambil pengguna yang ada untuk menentukan ID
                    List<User> users = await ApiService().fetchUsers();
                    // Buat ID baru sebagai string
                    String newId = (users.isNotEmpty
                        ? (int.parse(users.last.id) + 1).toString()
                        : '1');

                    // Buat pengguna baru
                    User newUser = User(
                      id: newId, // Set ID baru sebagai string
                      name: _name,
                      email: _email,
                      password: _password,
                    );

                    // Simpan pengguna baru
                    await ApiService().createUser(newUser);

                    // Tampilkan dialog konfirmasi
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('User Added'),
                        content:
                            const Text('The user has been added successfully.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Tutup dialog
                              Navigator.of(context).popUntil((route) =>
                                  route.isFirst); // Kembali ke HomePage
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
