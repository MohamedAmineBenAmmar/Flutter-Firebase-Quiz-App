import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateQuizScreen extends StatefulWidget {
  @override
  _CreateQuizScreenState createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quizNameController = TextEditingController();
  final _questionController = TextEditingController();
  final _answer1Controller = TextEditingController();
  final _answer2Controller = TextEditingController();
  final _answer3Controller = TextEditingController();
  final _answer4Controller = TextEditingController();

  bool _answer1IsCorrect = false;
  bool _answer2IsCorrect = false;
  bool _answer3IsCorrect = false;
  bool _answer4IsCorrect = false;

  List<Map<String, dynamic>> _questions = [];

  void _addQuestion() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _questions.add({
          'question': _questionController.text,
          'answer1':
              _answer1Controller.text.isNotEmpty ? _answer1Controller.text : "",
          'correct1': _answer1IsCorrect,
          'answer2':
              _answer2Controller.text.isNotEmpty ? _answer2Controller.text : "",
          'correct2': _answer2IsCorrect,
          'answer3':
              _answer3Controller.text.isNotEmpty ? _answer3Controller.text : "",
          'correct3': _answer3IsCorrect,
          'answer4':
              _answer4Controller.text.isNotEmpty ? _answer4Controller.text : "",
          'correct4': _answer4IsCorrect,
        });
        _questionController.clear();
        _answer1Controller.clear();
        _answer2Controller.clear();
        _answer3Controller.clear();
        _answer4Controller.clear();
        _answer1IsCorrect = false;
        _answer2IsCorrect = false;
        _answer3IsCorrect = false;
        _answer4IsCorrect = false;
      });
    }
  }

  void _createQuiz() async {
    if (_quizNameController.text.isNotEmpty && _questions.isNotEmpty) {
      final quizData = {
        'name': _quizNameController.text,
        'questions_count': _questions.length,
        'questions': _questions,
      };

      await FirebaseFirestore.instance
          .collection('quizzes')
          .add(quizData)
          .then((_) {
        setState(() {
          _quizNameController.clear();
          _questions.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quiz created successfully!')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create quiz: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Quiz'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _quizNameController,
                  decoration: InputDecoration(
                    labelText: 'Quiz Name',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a quiz name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'Question',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a question';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _answer1Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 1',
                    suffixIcon: Radio(
                      value: true,
                      groupValue: _answer1IsCorrect,
                      onChanged: (value) {
                        setState(() {
                          _answer1IsCorrect = value!;
                          _answer2IsCorrect = false;
                          _answer3IsCorrect = false;
                          _answer4IsCorrect = false;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _answer2Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 2',
                    suffixIcon: Radio(
                      value: true,
                      groupValue: _answer2IsCorrect,
                      onChanged: (value) {
                        setState(() {
                          _answer1IsCorrect = false;
                          _answer2IsCorrect = value!;
                          _answer3IsCorrect = false;
                          _answer4IsCorrect = false;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _answer3Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 3',
                    suffixIcon: Radio(
                      value: true,
                      groupValue: _answer3IsCorrect,
                      onChanged: (value) {
                        setState(() {
                          _answer1IsCorrect = false;
                          _answer2IsCorrect = false;
                          _answer3IsCorrect = value!;
                          _answer4IsCorrect = false;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _answer4Controller,
                  decoration: InputDecoration(
                    labelText: 'Answer 4',
                    suffixIcon: Radio(
                      value: true,
                      groupValue: _answer4IsCorrect,
                      onChanged: (value) {
                        setState(() {
                          _answer1IsCorrect = false;
                          _answer2IsCorrect = false;
                          _answer3IsCorrect = false;
                          _answer4IsCorrect = value!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _addQuestion,
                  child: Text('Add Question'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _createQuiz,
                  child: Text('Create Quiz'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
