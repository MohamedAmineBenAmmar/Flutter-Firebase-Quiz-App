import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HostSessionScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> session;

  const HostSessionScreen({Key? key, required this.session}) : super(key: key);

  @override
  State<HostSessionScreen> createState() => _HostSessionScreenState();
}

class _HostSessionScreenState extends State<HostSessionScreen> {
  @override
  void initState() {
    super.initState();
    print("we got that from the constructor host");
    print(widget.session.data());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('host screen quiz'),
    );
  }
}
