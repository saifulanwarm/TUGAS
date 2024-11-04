import 'package:flutter/material.dart';
import '../models/user.dart';
import '../api/api_service.dart'; // Import service API

class EditProfilePage extends StatefulWidget {
  final List<User> users; // List of users
  const EditProfilePage({super.key, required this.users});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? selectedUserId; // Store the selected user ID
  late User selectedUser; // User object based on selection
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with the first user in the list, or set to null
    if (widget.users.isNotEmpty) {
      selectedUser = widget.users[0];
      _initializeControllers(selectedUser);
    }
  }

  void _initializeControllers(User user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _passwordController.text = user.password;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 24.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedUserId,
              hint: const Text('Select User ID'),
              items: widget.users.map((User user) {
                return DropdownMenuItem<String>(
                  value: user.id,
                  child: Text(user.id),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedUserId = newValue;
                  selectedUser =
                      widget.users.firstWhere((user) => user.id == newValue);
                  _initializeControllers(selectedUser);
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // To hide the password input
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _updateUserProfile();
                  _showSuccessDialog(context);
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserProfile() async {
    final updatedUser = User(
      id: selectedUser.id, // Use the selected user ID
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    final apiService = ApiService();

    try {
      await apiService.updateUser(int.parse(updatedUser.id), updatedUser);
    } catch (e) {
      print('Error updating user: $e');
      _showErrorDialog(context, e.toString());
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Profile has been successfully edited!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
