import 'package:flutter/material.dart';

class GuestSessionScreen extends StatefulWidget {
  const GuestSessionScreen({super.key});

  @override
  State<GuestSessionScreen> createState() => _GuestSessionScreenState();
}

class _GuestSessionScreenState extends State<GuestSessionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Guest Screen quiz'),
    );
  }
}
