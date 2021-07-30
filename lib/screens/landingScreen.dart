import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../allNotifier/authNotifier.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'mapScreen.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({this.notif});
  final notif;

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    final tab = [
      HomeScreen(
        notifRating: widget.notif,
      ),
      MapScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: tab[_currentTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (int value) {
          setState(() {
            _currentTab = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
              size: 30,
            ),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 15.0,
              backgroundImage: NetworkImage('http://i.imgur.com/zL4Krbz.png'),
            ),
            title: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
