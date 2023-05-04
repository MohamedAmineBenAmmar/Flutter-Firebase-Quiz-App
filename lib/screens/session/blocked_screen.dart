import 'package:flutter/material.dart';

class BlockedScreen extends StatelessWidget {
  final int score;
  final String photoUrl;

  const BlockedScreen({required this.score, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(photoUrl),
        ),
        SizedBox(height: 16),
        Text(
          'Your current score is: $score',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 16),
        Text(
          'Waiting for host to move on',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
