import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/screens/session/create_session_screen.dart';

class UpdateQuizScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> quiz;

  const UpdateQuizScreen({Key? key, required this.quiz}) : super(key: key);

  @override
  _UpdateQuizScreenState createState() => _UpdateQuizScreenState();
}

class _UpdateQuizScreenState extends State<UpdateQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late List<Map<String, dynamic>> _questions;

  bool isHidden = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.quiz['name']);
    _questions = List<Map<String, dynamic>>.from(widget.quiz['questions']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void handleCheckbox(int index, String fieldName, String key, bool? checked) {
    setState(() {
      _questions[index][key] = checked;
    });
  }

  Widget _buildAnswer(String fieldName, String initialValue, bool correct,
      int index, String key) {
    return Row(
      children: [
        Checkbox(
          value: correct,
          onChanged: (bool? checked) {
            handleCheckbox(index, fieldName, key, checked);
          },
        ),
        Expanded(
          child: TextFormField(
            onChanged: (String newValue) {
              handleInputChange(index, false, newValue, fieldName);
            },

            initialValue: initialValue,
            decoration: InputDecoration(
              labelText: fieldName,
            ),
            // readOnly: true,
            // enabled: false,
          ),
        ),
      ],
    );
  }

  void handleInputChange(
      int index, bool entity, String newValue, String answerIndex) {
    if (entity) {
      // We are deadling with the question
      _questions[index]['question'] = newValue;
    } else {
      // We are dealing with the answer
      _questions[index][answerIndex] = newValue;
    }
    setState(() {});
  }

  void handleDelete(int index) {
    setState(() {
      _questions.removeAt(index);
      isHidden = true;
      print(_questions);
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        isHidden = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Viewer & Editor'),
        ),
        body: !isHidden
            ? (SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Quiz Name',
                          ),
                          // readOnly: false,
                          // enabled: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter quiz name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Questions:',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 8.0),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Question ${index + 1}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              handleDelete(index);
                                            },
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        onChanged: (String newValue) {
                                          handleInputChange(
                                              index, true, newValue, "");
                                        },
                                        initialValue: _questions[index]
                                            ['question'],

                                        decoration: InputDecoration(
                                          labelText: 'Question',
                                        ),
                                        // readOnly: true,
                                        // enabled: false,
                                      ),
                                      const SizedBox(height: 8.0),
                                      _buildAnswer(
                                          'answer1',
                                          _questions[index]['answer1'],
                                          _questions[index]['correct1'],
                                          index,
                                          "correct1"),
                                      _buildAnswer(
                                          'answer2',
                                          _questions[index]['answer2'],
                                          _questions[index]['correct2'],
                                          index,
                                          "correct2"),
                                      _buildAnswer(
                                          'answer3',
                                          _questions[index]['answer3'],
                                          _questions[index]['correct3'],
                                          index,
                                          "correct3"),
                                      _buildAnswer(
                                          'answer4',
                                          _questions[index]['answer4'],
                                          _questions[index]['correct4'],
                                          index,
                                          "correct4"),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _questions.add({
                                  'question': '',
                                  'answer1': '',
                                  'answer2': '',
                                  'answer3': '',
                                  'answer4': '',
                                  'correct1': false,
                                  'correct2': false,
                                  'correct3': false,
                                  'correct4': false,
                                });
                              });
                            },
                            child: Text('Add Question'),
                          ),
                        ),
                        const SizedBox(height: 125.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _saveQuiz,
                              child: Text('Save Quiz'),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                              ),
                              onPressed: _deleteQuiz,
                              child: Text('Delete Quiz'),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                              ),
                              onPressed: _createSession,
                              child: Text('Set Session'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ))
            : (const Center(child: CircularProgressIndicator())));
  }

  void _saveQuiz() {
    if (_formKey.currentState!.validate()) {
      widget.quiz.reference.update({
        'name': _nameController.text,
        'questions': _questions,
        'questions_count': _questions.length,
      });
      Navigator.of(context).pop();
    }
  }

  void _deleteQuiz() {
    widget.quiz.reference.delete();
    Navigator.of(context).pop();
  }

  void _createSession() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateSessionScreen(quiz: widget.quiz)));
  }
}
