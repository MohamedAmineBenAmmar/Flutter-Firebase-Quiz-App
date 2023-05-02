import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/providers/user_provider.dart';
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
  dynamic user = null;

  void _createButtonPressed() {
    // Navigate to other screen with inputText
    print("The current authenticated user data moula el quiz");
    print((user as User).toJson());

    print("the session name created that must be unique");
    print(_sessionController.text);

    print("the quiz instance that we got from the viewer");
    print(widget.quiz.data());
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
