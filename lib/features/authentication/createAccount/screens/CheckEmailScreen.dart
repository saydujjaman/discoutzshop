import 'package:discountzshop/features/authentication/createAccount/screens/CreateNewPasswordScreen.dart';
import 'package:flutter/material.dart';
import './CheckEmailScreen.dart'; // Add this import

class CheckMailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text(''), // Empty title, adjust if needed
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.email,
              size: 50,
              color: Colors.orange,
            ),
            SizedBox(height: 20),
            Text(
              'Check Your Mail',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'We have sent a password recover instructions to your mail.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePasswordScreen()),
                ); // Navigate to CreatePasswordScreen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Open Your Mail', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            Text(
              'Did not receive the email? Check your spam folder, or try correct email address.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}