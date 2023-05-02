import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/screens/auth/login_screen.dart';
import 'package:flutter_firebase_realtime_app/screens/auth/signup_screen.dart';
import 'package:flutter_firebase_realtime_app/screens/quiz/create_quiz_screen.dart';
import 'package:flutter_firebase_realtime_app/screens/quiz/quizzes_list_screen.dart';

List<Widget> homeScreenItems = [
  QuizzesListScreen(),
  const SignupScreen(),
  CreateQuizScreen(),
  const Text('notifications'),
  const LoginScreen(),
  // ProfileScreen(
  //   uid: FirebaseAuth.instance.currentUser!.uid,
  // ),
];
