import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/providers/user_provider.dart';
import 'package:flutter_firebase_realtime_app/screens/session/guest_session_screen.dart';
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

    final CollectionReference sessions =
        FirebaseFirestore.instance.collection('sessions');

    sessions
        .where('name', isEqualTo: _sessionController.text)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // A session with the given name already exists
        print('Session with name ${_sessionController.text} already exists!');

        // Get the session ID
        final String sessionId = querySnapshot.docs[0].id;

        // Add the current authenticated user as a guest to the session
        sessions.doc(sessionId).update({
          'guests.${(user as User).uid}.me': (user as User).toJson(),
          'guests.${(user as User).uid}.score': 0,
        }).then((value) {
          // Get the updated document snapshot
          sessions.doc(sessionId).get().then((updatedDoc) {
            // Redirect to the guest screen with the updated document snapshot
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GuestSessionScreen(session: updatedDoc)));
          });
        }).catchError((error) {
          // Handle error
          showSnackBar(context, 'Error adding user as guest to session: $error');          
        });
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
