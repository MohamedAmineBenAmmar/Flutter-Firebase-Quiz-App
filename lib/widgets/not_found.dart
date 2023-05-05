import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  final String message;

  const NotFound({Key? key, this.message = "Not found"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          child: Image.asset(
            'assets/images/not_found.jpg',
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          message,
          style: TextStyle(fontSize: 20.0),
        ),
      ],
    );
  }
}
