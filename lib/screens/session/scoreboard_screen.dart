import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/models/user.dart';
import 'package:flutter_firebase_realtime_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ScoreboardScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> session;
  const ScoreboardScreen({Key? key, required this.session}) : super(key: key);

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  bool isLoaded = false;
  Map<String, dynamic> guests = {};
  List<dynamic> sortedGuests = [];
  dynamic user = null; // Storing the current authenticated user

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoaded = true;
      guests = widget.session['guests'] as Map<String, dynamic>;
      sortedGuests = guests.values.toList()
        ..sort((a, b) => b['score'].compareTo(a['score']));
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;

    // Sort the guests based on their scores
    return Scaffold(
      // appBar: AppBar(
      // title: Text('Scoreboard'),
      // ),
      body: isLoaded
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...sortedGuests.map((guest) => Column(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(guest['me']['photoUrl']),
                              radius: 40,
                            ),
                            Text(
                              '${guest['me']['firstName']} ${guest['me']['lastName']}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Score: ${guest['score']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20)
                          ],
                        )),
                    Expanded(child: Container()),
                    (user as User).uid == widget.session['host']['uid']
                        ? ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('sessions')
                                  .doc(widget.session.id)
                                  .update({'isFinished': true});
                              Navigator.pop(context);
                            },
                            child: Text('Finish Session'),
                          )
                        : Container()
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
