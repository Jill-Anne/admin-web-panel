import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  static const String id = 'account_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Page'),
      ),
      body: const Center(
        child: Text('This is the account page'),
      ),
    );
  }
}
