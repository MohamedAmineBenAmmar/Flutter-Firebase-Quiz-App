import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/screens/session/scoreboard_screen.dart';

class HostSessionScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> session;

  const HostSessionScreen({Key? key, required this.session}) : super(key: key);

  @override
  State<HostSessionScreen> createState() => _HostSessionScreenState();
}

class _HostSessionScreenState extends State<HostSessionScreen> {
  int _currentQuestionIndex = 0;
  bool isFinished = false;
  bool started = false;

  @override
  Widget build(BuildContext context) {
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
      body: started
          ? (StreamBuilder<DocumentSnapshot>(
              stream: widget.session.reference.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final currentQuestionIndex =
                    snapshot.data!['currentQuestion'] as int;

                if (currentQuestionIndex == -1) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.session.reference.update({
                          'currentQuestion': 0,
                        });
                      },
                      child: Text('Start Quiz'),
                    ),
                  );
                }

                final currentQuestion = snapshot.data!['quiz']['questions']
                    [currentQuestionIndex] as Map;

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
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              SizedBox(height: 16.0),
                              ...options.map((option) => ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: option['isCorrect']
                                            ? (MaterialStateColor.resolveWith(
                                                (states) => Color.fromRGBO(
                                                    33, 243, 79, 1)))
                                            : (MaterialStateColor.resolveWith(
                                                (states) => Color.fromARGB(
                                                    255, 243, 33, 33)))),
                                    onPressed: () {
                                      if ((option['isCorrect']) &&
                                          (currentQuestionIndex <
                                              snapshot.data!['quiz']
                                                      ['questions_count'] -
                                                  1)) {
                                        setState(() {
                                          _currentQuestionIndex =
                                              currentQuestionIndex;
                                        });

                                        _checkAnswer();
                                      } else {
                                        // setState(() {
                                        //   isFinished = true;
                                        // });
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ScoreboardScreen(
                                                        session:
                                                            snapshot.data!)));
                                      }
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
            ))
          : (Center(
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    started = true;
                    _startSession();
                  });
                },
                child: Text('Start Quiz'),
              ),
            )),
    );
  }

  void _checkAnswer() {
    final currentQuestionIndex = _currentQuestionIndex;
    final sessionRef = widget.session.reference;

    sessionRef.update({
      'currentQuestion': currentQuestionIndex + 1,
      'calculations': {'points': 100}
    });
  }

  void _startSession() {
    final sessionRef = widget.session.reference;

    sessionRef.update({
      'started': true,
    });
  }
}
