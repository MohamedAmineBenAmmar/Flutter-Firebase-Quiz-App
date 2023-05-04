import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/providers/user_provider.dart';
import 'package:flutter_firebase_realtime_app/screens/session/host_session_screen.dart';
import 'package:flutter_firebase_realtime_app/utils/utils.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class CreateSessionScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> quiz;

  const CreateSessionScreen({Key? key, required this.quiz}) : super(key: key);
  @override
  _CreateSessionScreenState createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  final TextEditingController _sessionController = TextEditingController();
  dynamic user = null; // Storing the current authenticated user

  Future<void> _createButtonPressed() async {
    // Verify if session name is unique
    final isSessionNameUnique = await FirebaseFirestore.instance
        .collection('sessions')
        .where('name', isEqualTo: _sessionController.text)
        .get()
        .then((snapshot) => snapshot.docs.isEmpty);

    if (!isSessionNameUnique) {
      showSnackBar(context, "Session name already exists.");
      return;
    }

    // Create new session
    final sessionData = {
      'name': _sessionController.text,
      'host': user.toJson(),
      'guests': {},
      'quiz': widget.quiz.data(),
      'currentQuestion': 0,
      'calculations': {'points': 100},
      'started': false
    };

    FirebaseFirestore.instance
        .collection('sessions')
        .add(sessionData)
        .then((documentRef) {
      // Handle successful completion
      showSnackBar(context, 'Session added with ID: ${documentRef.id}');

      // Retrieve the newly created document
      documentRef.get().then((snapshot) {
        if (snapshot.exists) {
          // Do something with the document data
          // print("the newly created session");
          // print(snapshot.data());
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HostSessionScreen(session: snapshot)));
        } else {
          print('Document does not exist');
        }
      }).catchError((error) {
        // Handle error
        print('Error retrieving document: $error');
      });
    }).catchError((error) {
      // Handle error
      showSnackBar(context, 'Error adding session: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _sessionController,
                  decoration: InputDecoration(
                    hintText: 'Enter a unique session name',
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
                onPressed: _createButtonPressed,
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
