import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/providers/user_provider.dart';
import 'package:flutter_firebase_realtime_app/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _deleteAccount(BuildContext context) async {
    if (user != null) {
      await user?.delete();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.photoUrl),
            ),
            SizedBox(height: 16),
            Text(
              '${user.firstName} ${user.lastName}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              user.email,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: Text('Logout'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(100, 50)),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () => _deleteAccount(context),
                  child: Text('Delete'),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(100, 50)),
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
