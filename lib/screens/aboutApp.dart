import 'package:flutter/material.dart';

class AboutApp extends StatefulWidget {
  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                "Lobar Destination application",
                style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Developer by Risca",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.blue[300]),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                "Email : emailrisca@gmail.com",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
