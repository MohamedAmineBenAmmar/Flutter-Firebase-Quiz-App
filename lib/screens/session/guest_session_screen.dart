import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/models/user.dart';
import 'package:flutter_firebase_realtime_app/providers/user_provider.dart';
import 'package:flutter_firebase_realtime_app/screens/session/blocked_screen.dart';
import 'package:flutter_firebase_realtime_app/screens/session/scoreboard_screen.dart';
import 'package:flutter_firebase_realtime_app/utils/utils.dart';
import 'package:provider/provider.dart';

class GuestSessionScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> session;

  const GuestSessionScreen({Key? key, required this.session}) : super(key: key);

  @override
  State<GuestSessionScreen> createState() => _GuestSessionScreenState();
}

class _GuestSessionScreenState extends State<GuestSessionScreen> {
  dynamic user = null; // Storing the current authenticated user
  bool isBlocked = false;
  bool hasAnswered = false;
  int _currentQuestionIndex = 0;
  @override
  void initState() {
    super.initState();
    print("we got that from the constructor guest");
    print(widget.session.data());
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Session'),
      ),
      drawer: Drawer(
        child: StreamBuilder<DocumentSnapshot>(
          stream: widget.session.reference.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            final guests = Map<String, dynamic>.from(
                snapshot.data!['guests'] as Map<dynamic, dynamic>);
            final questionsCount = snapshot.data!['quiz']['questions_count'];

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  child: Text('Session Guests'),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                for (var guest in guests.values)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        guest['me']['photoUrl'],
                      ),
                    ),
                    title: Text(
                        '${guest['me']['firstName']} ${guest['me']['lastName']}'),
                    subtitle: Text('Score: ${guest['score']}'),
                    trailing: Text('Joined the session'),
                  ),
              ],
            );
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: widget.session.reference.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!['started']) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text("Waiting for the host to start the session")
              ],
            ));
          }

          // Test if the current question has incremented by the host
          if (snapshot.data!['currentQuestion'] > _currentQuestionIndex) {
            _currentQuestionIndex = snapshot.data!['currentQuestion'] as int;
            hasAnswered = false;
            isBlocked = false;
          }

          if (isBlocked) {
            if ((snapshot.data!['quiz']['questions_count'] as int) - 1 ==
                (snapshot.data!['currentQuestion'] as int)) {
              return ScoreboardScreen(session: snapshot.data!);
            }
            return (BlockedScreen(
                score: snapshot.data!['guests'][(user as User).uid]['score'],
                photoUrl: snapshot.data!['guests'][(user as User).uid]['me']
                    ['photoUrl']));
          }

          final currentQuestionIndex = snapshot.data!['currentQuestion'] as int;

          final currentQuestion =
              snapshot.data!['quiz']['questions'][currentQuestionIndex] as Map;

          final options = [];

          // Loop 4 times and check if the current index is the correct answer
          // If it is, then we return a green button, otherwise we return a red button
          // If the current index is the selected answer, we return a blue button
          for (var i = 1; i <= 4; i++) {
            if (currentQuestion['answer$i'].length > 0) {
              options.add({
                'text': currentQuestion['answer$i'] as String,
                'isCorrect': currentQuestion['correct$i'] as bool,
              });
            }
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Question ${currentQuestionIndex + 1} of ${widget.session['quiz']['questions_count']}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 16.0),
                Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          currentQuestion['question'] as String,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 16.0),
                        ...options.map((option) => ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  hasAnswered
                                      ? option['isCorrect']
                                          ? Colors.green
                                          : Colors.red
                                      : Colors.blue,
                                ),
                              ),
                              onPressed: () {
                                if (option['isCorrect']) {
                                  // Update the score of the current authenticated user
                                  if (snapshot.data!['calculations']['points'] >
                                      25) {
                                    _updateScore(
                                        (user as User),
                                        snapshot.data!['guests']
                                                [(user as User).uid]['score'] +
                                            snapshot.data!['calculations']
                                                ['points'],
                                        true,
                                        snapshot.data!['calculations']
                                                ['points'] -
                                            25);
                                  } else {
                                    _updateScore(
                                        (user as User),
                                        snapshot.data!['guests']
                                                [(user as User).uid]['score'] +
                                            snapshot.data!['calculations']
                                                ['points'],
                                        false,
                                        0);
                                  }
                                }

                                setState(() {
                                  hasAnswered = true;
                                  if (_currentQuestionIndex == 0) {
                                    showSnackBar(context,
                                        "After 5 seconds you will be blocked until the host releases you");
                                  }
                                });

                                Future.delayed(Duration(seconds: 5), () {
                                  if ((snapshot.data!['quiz']['questions_count']
                                              as int) -
                                          1 ==
                                      (snapshot.data!['currentQuestion']
                                          as int)) {
                                    // Here I answered the last question
                                    // Navigator.of(context).pushReplacement(
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             ScoreboardScreen(
                                    //                 session: snapshot.data!)));
                                    setState(() {
                                      // your state change here
                                      isBlocked = true;
                                    });
                                  } else {
                                    // test if we hit the last question
                                    setState(() {
                                      // your state change here
                                      isBlocked = true;
                                    });
                                  }
                                });
                              },
                              child: Text(option['text'] as String),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateScore(
      User user, int score, bool updatePointsCalculations, int newScore) {
    final sessionRef = widget.session.reference;

    if (updatePointsCalculations) {
      sessionRef.update(
        {
          'guests': {
            user.uid: {
              'me': user.toJson(),
              'score': score,
            }
          },
          'calculations': {
            'points': newScore,
          }
        },
      );
    } else {
      sessionRef.update(
        {
          'guests': {
            user.uid: {
              'me': user.toJson(),
              'score': score,
            }
          }
        },
      );
    }
  }
}
