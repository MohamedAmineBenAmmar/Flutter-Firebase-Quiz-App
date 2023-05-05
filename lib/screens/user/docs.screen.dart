import 'package:flutter/material.dart';

class DocsScreen extends StatelessWidget {
  final List<String> phrases = [
    'Choose a quiz category that interests you.',
    'Read the question carefully and select the correct answer.',
    'Make sure to keep an eye on the timer',
    "Once you've completed the quiz, submit your answers to see your score.",
    "Create your own quizzes and share them with the community.",
    "Have fun and keep learning!"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to use the app'),
      ),
      body: ListView.builder(
        itemCount: phrases.length,
        itemBuilder: (context, index) {
          final phrase = phrases[index];

          return ListTile(
            title: Text(
              phrase,
              style: TextStyle(fontSize: 18),
            ),
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
          );
        },
      ),
    );
  }
}
