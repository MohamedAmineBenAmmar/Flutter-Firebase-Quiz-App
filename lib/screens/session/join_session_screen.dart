import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/providers/user_provider.dart';
import 'package:flutter_firebase_realtime_app/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class JoinSessionScreen extends StatefulWidget {
  @override
  _JoinSessionScreenState createState() => _JoinSessionScreenState();
}

class _JoinSessionScreenState extends State<JoinSessionScreen> {
  final TextEditingController _sessionController = TextEditingController();
  dynamic user = null;

  void _joinButtonPressed() {
    // Navigate to other screen with inputText
    // print("The current authenticated user data");
    // print((user as User).toJson());

    // print("the session name");
    // print(_sessionController.text);

    FirebaseFirestore.instance
        .collection('sessions')
        .where('name', isEqualTo: _sessionController.text)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // A session with the given name already exists
        print('Session with name ${_sessionController.text} already exists!');

        // redicrection to the guest screen
        // ...
      } else {
        // Session does not exist
        showSnackBar(context,
            'Session with name ${_sessionController.text} does not exist.');
      }
    }).catchError((error) {
      // Handle error
      print('Error checking session: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _sessionController,
              decoration: InputDecoration(
                hintText: 'Enter a string',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.link),
            onPressed: () {
              // Do something when icon button is pressed
            },
          ),
          SizedBox(width: 16.0),
          ElevatedButton(
            onPressed: _joinButtonPressed,
            child: Text('Join'),
          ),
        ],
      ),
    );
  }
}
