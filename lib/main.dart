import 'package:flutter/material.dart';
import 'allNotifier/authNotifier.dart';
import 'screens/screen.dart';
import 'package:provider/provider.dart';
import 'allNotifier/destinationNotifier.dart';
import 'allNotifier/newDestNotifier.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AuthNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => DestinationNotifier(),
      ),
      ChangeNotifierProvider(
        create: (context) => NewDestNotifier(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodybite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // textTheme:
        //     GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
        primaryColor: Color(0xff5663ff),
        accentColor: Color(0xFFD8ECF1),
        scaffoldBackgroundColor: Color(0xFFF3F5F7),
      ),
      initialRoute: '/',
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? LandingScreen() : LoginScreen();
        },
      ),
      // home: LoginScreen(),
    );
  }
}
