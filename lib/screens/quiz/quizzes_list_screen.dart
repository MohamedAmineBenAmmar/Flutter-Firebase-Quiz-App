import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/screens/quiz/update_quiz_screen.dart';
import 'package:flutter_firebase_realtime_app/utils/colors.dart';

class QuizzesListScreen extends StatelessWidget {
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
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final quizzes = snapshot.data!.docs;
          return ListView.builder(
            itemCount: quizzes.length,
            itemBuilder: (context, index) {
              final quiz = quizzes[index];
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
    );
  }
}
