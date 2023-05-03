import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GuestSessionScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> session;

  const GuestSessionScreen({Key? key, required this.session}) : super(key: key);

  @override
  State<GuestSessionScreen> createState() => _GuestSessionScreenState();
}

class _GuestSessionScreenState extends State<GuestSessionScreen> {
  @override
  void initState() {
    super.initState();
    print("we got that from the constructor guest");
    print(widget.session.data());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Guest Screen quiz'),
    );
  }
}
