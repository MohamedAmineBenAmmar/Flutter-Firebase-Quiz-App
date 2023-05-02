import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/resources/auth_methods.dart';
import 'package:flutter_firebase_realtime_app/screens/auth/login_screen.dart';
import 'package:flutter_firebase_realtime_app/utils/colors.dart';
import 'package:flutter_firebase_realtime_app/utils/utils.dart';
import 'package:flutter_firebase_realtime_app/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../responsive/mobile_screen_layout.dart';
import '../../responsive/responsive_layout_screen.dart';
import '../../responsive/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        firtName: _firstnameController.text,
        lastName: _lastnameController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(Key("ResponsiveLayout"),
              WebScreenLayout(), MobileScreenLayout())));
    }
  }

  void navigateToLoginScreen() {
    print("navigation to the login screen");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
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
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            "https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg"),
                      ),
                Positioned(
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                    bottom: -10,
                    left: 80)
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
                textEditingController: _firstnameController,
                hintText: "Enter your firstname",
                textInputType: TextInputType.text),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
                textEditingController: _lastnameController,
                hintText: "Enter your lastname",
                textInputType: TextInputType.text),
            const SizedBox(
              height: 24,
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
                onTap: signUpUser,
                child: _isLoading
                    ? (const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ))
                    : (Container(
                        child: const Text('Signup'),
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
                  child: const Text("Already have an account? "),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                InkWell(
                  onTap: navigateToLoginScreen,
                  child: Container(
                    child: const Text(
                      "Login",
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
