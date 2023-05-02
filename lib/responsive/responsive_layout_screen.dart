import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../utils/dimensions.dart';

class ResponsiveLayout extends StatefulWidget {
  // We accept the final Widget as a parameter in the constructor
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout(
      Key? key, this.webScreenLayout, this.mobileScreenLayout)
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
    // This is all it takes to sotre the user in our user provider
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          // Web screen
          return widget.webScreenLayout;
        } else {
          // Mobile screen
          return widget.mobileScreenLayout;
        }
      },
    );
  }
}
