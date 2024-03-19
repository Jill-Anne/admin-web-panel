import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddUserPopUp extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _bodyNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  AddUserPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New User'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name')),
            TextField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name')),
            TextField(controller: _birthdateController, decoration: const InputDecoration(labelText: 'BirthDate')),
            TextField(controller: _idNumberController, decoration: const InputDecoration(labelText: 'ID Number')),
            TextField(controller: _bodyNumberController, decoration: const InputDecoration(labelText: 'Body Number')),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _addUser(context),
          child: const Text('Save'),
        ),
      ],
    );
  }

Future<void> _addUser(BuildContext context) async {
  final String email = _emailController.text.trim();
  final String password = "Date_" + _birthdateController.text.trim(); // Adjust as needed

  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    print("User successfully added to Firebase Auth with UID: ${userCredential.user!.uid}");

    await _database.child('driversAccount').push().set({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'birthDate': _birthdateController.text,
      'idNumber': _idNumberController.text,
      'bodyNumber': _bodyNumberController.text,
      'email': email,
      'uid': userCredential.user!.uid,
    });
    print("User details successfully added to Realtime Database.");

    Navigator.of(context).pop(); // Close the dialog
    _showDialog(context, "Success", "User added successfully.");
  } catch (e) {
    print("Error adding user: $e");
    Navigator.of(context).pop(); // Close the dialog
    _showDialog(context, "Error", e.toString());
  }
}


  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
