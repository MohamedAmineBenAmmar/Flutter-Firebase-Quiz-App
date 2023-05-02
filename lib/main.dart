import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_realtime_app/screens/auth/login_screen.dart';
import 'package:flutter_firebase_realtime_app/screens/auth/signup_screen.dart';
import 'package:flutter_firebase_realtime_app/utils/colors.dart';
import 'package:flutter_firebase_realtime_app/responsive/responsive_layout_screen.dart';
import 'package:flutter_firebase_realtime_app/responsive/mobile_screen_layout.dart';
import 'package:flutter_firebase_realtime_app/responsive/web_screen_layout.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase_realtime_app/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Check the platforme that we are running on
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB6PwHn0o-Bbt3zl4QpG9p6ohonL1Mjuiw",
          appId: '1:85187679574:web:b4190756e02df61ae8f2f7',
          messagingSenderId: '85187679574',
          projectId: 'flutter-firebase-realtime-app',
          storageBucket: "flutter-firebase-realtime-app.appspot.com"),
    );
  } else {
    // This initialization is for android and ios apps
    await Firebase.initializeApp();
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Realtime App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: const Scaffold(
        //   body: ResponsiveLayout(
        //     Key("ResponsiveLayout"),
        //     WebScreenLayout(),
        //     MobileScreenLayout(),
        //   ),
        // ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(Key("ResponsiveLayout"),
                    WebScreenLayout(), MobileScreenLayout());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            return const LoginScreen();
          },
        ),
        // home: SignupScreen(),
      ),
    );
  }
}
