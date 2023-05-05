import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/models/user.dart';
import 'package:flutter_firebase_realtime_app/providers/user_provider.dart';
import 'package:flutter_firebase_realtime_app/screens/quiz/update_quiz_screen.dart';
import 'package:flutter_firebase_realtime_app/utils/colors.dart';
import 'package:flutter_firebase_realtime_app/widgets/not_found.dart';
import 'package:provider/provider.dart';

class QuizzesListScreen extends StatefulWidget {
  @override
  _QuizzesListScreenState createState() => _QuizzesListScreenState();
}

class _QuizzesListScreenState extends State<QuizzesListScreen> {
  String filterQuery = '';
  dynamic user = null;
  String uid = "";

  void handleClickedQuiz(
      BuildContext context, QueryDocumentSnapshot<Object?> snap) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateQuizScreen(quiz: snap),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    uid = (user == null) ? "" : user.uid;
    return Column(
      children: [
        SizedBox(height: 50.0),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search quizzes...',
            ),
            onChanged: (value) {
              setState(() {
                filterQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('quizzes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              // final quizzes = snapshot.data!.docs.where((quiz) => quiz['name']
              //     .toString()
              //     .toLowerCase()
              //     .contains(filterQuery.toLowerCase()));
              if (uid.length == 0) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final quizzes = snapshot.data!.docs.where((quiz) =>
                  quiz['uid'] == uid &&
                  quiz['name']
                      .toString()
                      .toLowerCase()
                      .contains(filterQuery.toLowerCase()));
              if (quizzes.length == 0) {
                return NotFound(
                  message: "No quizzes found wit that name",
                );
              }
              return ListView.builder(
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes.elementAt(index);
                  final quizName = quiz['name'];
                  final numQuestions = quiz['questions_count'];

                  return Card(
                    color: secondaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            child: Text(
                              numQuestions.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: mobileBackgroundColor,
                          ),
                          SizedBox(width: 16.0),
                          Text(
                            quizName,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            onPressed: () {
                              handleClickedQuiz(context, quiz);
                            },
                            icon: Icon(Icons.arrow_forward_ios),
                            color: mobileBackgroundColor,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
