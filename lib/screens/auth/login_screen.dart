import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/resources/auth_methods.dart';
import 'package:flutter_firebase_realtime_app/screens/auth/signup_screen.dart';
import 'package:flutter_firebase_realtime_app/utils/colors.dart';
import 'package:flutter_firebase_realtime_app/utils/utils.dart';
import 'package:flutter_firebase_realtime_app/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    setState(() {
      _isLoading = false;
    });

    print("lool");
    print(res);
    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(Key("ResponsiveLayout"),
              WebScreenLayout(), MobileScreenLayout())));
    }
  }

  void navigateToSignUpScreen() {
    print("navigation to the signup screen");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            SvgPicture.asset('assets/images/react-logo.svg'),
            const SizedBox(
              height: 64,
            ),
            TextFieldInput(
                textEditingController: _emailController,
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
                textEditingController: _passwordController,
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                isPassword: true),
            const SizedBox(
              height: 24,
            ),
            InkWell(
                onTap: loginUser,
                child: _isLoading
                    ? (const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ))
                    : (Container(
                        child: const Text('Login'),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          color: blueColor,
                        ),
                      ))),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text("Don't have an account? "),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                InkWell(
                  onTap: navigateToSignUpScreen,
                  child: Container(
                    child: const Text(
                      "Signup",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: blueColor),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
