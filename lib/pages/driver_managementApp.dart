import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddDriverUserPage extends StatefulWidget {
  static const String id = "webPageDriverManagement";

  const AddDriverUserPage({Key? key}) : super(key: key);

  @override
  State<AddDriverUserPage> createState() => _AddDriverUserPageState();
}

class _AddDriverUserPageState extends State<AddDriverUserPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _bodyNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> _driverUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchDriverUsers();
  }

  void _fetchDriverUsers() {
    _database.child('driversAccount').once().then((DatabaseEvent event) {
      DataSnapshot dataSnapshot = event.snapshot;
      dynamic data = dataSnapshot.value;

      if (data != null && data is Map<dynamic, dynamic>) {
        List<Map<String, dynamic>> usersList = [];

        data.forEach((key, value) {
          if (value != null && value is Map<dynamic, dynamic>) {
            usersList.add({...value, 'id': key});
          }
        });

        setState(() {
          _driverUsers = usersList;
        });
      } else {
        setState(() {
          _driverUsers = [];
        });
        print('No valid data found in driversAccount node.');
      }
    }).catchError((error) {
      print('Error fetching driver users: $error');
      setState(() {
        _driverUsers = [];
      });
    });
  }

  Future<bool> _authenticateWithCredentials(
      String email, String birthdate) async {
    return email.isNotEmpty && birthdate.isNotEmpty;
  }

  void _addDriverUser() async {
    try {
      // Get values from text controllers
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String birthdate = _birthdateController.text.trim();
      String idNumber = _idNumberController.text.trim();
      String bodyNumber = _bodyNumberController.text.trim();
      String email = _emailController.text.trim();
      String phoneNumber = _phoneNumberController.text.trim();

      // Validate input fields
      if (firstName.isEmpty ||
          lastName.isEmpty ||
          birthdate.isEmpty ||
          idNumber.isEmpty ||
          bodyNumber.isEmpty ||
          email.isEmpty ||
          phoneNumber.isEmpty) {
        _showDialog(context, "Error", "Please fill in all fields.");
        return;
      }

      // Authenticate with credentials
      bool isAuthenticated =
          await _authenticateWithCredentials(email, birthdate);

      if (isAuthenticated) {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: birthdate,
        );

        // Check if user creation was successful
        if (userCredential.user != null) {
          // Add user to the database
          await _database.child('driversAccount').push().set({
            'firstName': firstName,
            'lastName': lastName,
            'birthdate': birthdate,
            'idNumber': idNumber,
            'bodyNumber': bodyNumber,
            'email': email,
            'phoneNumber': phoneNumber,
            'uid': userCredential.user!.uid,
          });

          // Fetch updated list of driver users and clear input fields
          _fetchDriverUsers();
          _clearControllers();
          print("User added successfully.");
        } else {
          _showDialog(context, "Error", "Failed to create user.");
        }
      } else {
        _showDialog(context, "Error",
            "Authentication failed. Please check your credentials.");
      }
    } catch (e) {
      print("Error adding user: $e");
      _showDialog(context, "Error", "Failed to add user: $e");
    }
  }

  void _clearControllers() {
    _firstNameController.clear();
    _lastNameController.clear();
    _birthdateController.clear();
    _idNumberController.clear();
    _bodyNumberController.clear();
    _emailController.clear();
    _phoneNumberController.clear();
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Driver User"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Add New User'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _firstNameController,
                              decoration:
                                  InputDecoration(labelText: 'First Name'),
                            ),
                            TextField(
                              controller: _lastNameController,
                              decoration:
                                  InputDecoration(labelText: 'Last Name'),
                            ),
                            TextField(
                              controller: _birthdateController,
                              decoration:
                                  InputDecoration(labelText: 'Birthdate'),
                            ),
                            TextField(
                              controller: _idNumberController,
                              decoration:
                                  InputDecoration(labelText: 'ID Number'),
                            ),
                            TextField(
                              controller: _bodyNumberController,
                              decoration:
                                  InputDecoration(labelText: 'Body Number'),
                            ),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                            ),
                            TextField(
                              controller: _phoneNumberController,
                              decoration:
                                  InputDecoration(labelText: 'Phone Number'),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _addDriverUser();
                            Navigator.of(context).pop();
                          },
                          child: Text('Add User'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("+ Add new User"),
            ),
            SizedBox(height: 16.0),
            DataTable(
              columns: [
                DataColumn(label: Text('First Name')),
                DataColumn(label: Text('Last Name')),
                DataColumn(label: Text('Birthdate')),
                DataColumn(label: Text('ID Number')),
                DataColumn(label: Text('Body Number')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone Number')),
              ],
              rows: _buildUserRows(),
            ),
          ],
        ),
      ),
    );
  }

  List<DataRow> _buildUserRows() {
    return _driverUsers.map((user) {
      return DataRow(cells: [
        DataCell(Text(user['firstName'] ?? '')),
        DataCell(Text(user['lastName'] ?? '')),
        DataCell(Text(user['birthdate'] ?? '')),
        DataCell(Text(user['idNumber'] ?? '')),
        DataCell(Text(user['bodyNumber'] ?? '')),
        DataCell(Text(user['email'] ?? '')),
        DataCell(Text(user['phoneNumber'] ?? '')),
      ]);
    }).toList();
  }
}
