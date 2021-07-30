import 'package:flutter/material.dart';
import 'aboutApp.dart';
import 'package:provider/provider.dart';
import '../screens/aboutApp.dart';
import '../api/authApi.dart';
import 'loginScreen.dart';
import 'package:lobardestination/allNotifier/authNotifier.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    String name = authNotifier.user.displayName;
    String firstCha = name[0].toUpperCase();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Center(
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.42,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.red,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 1.0),
                              blurRadius: 2.0,
                            )
                          ],
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            firstCha,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 80,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        authNotifier?.user?.displayName ?? "username",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 0.5,
                      ),
                      Text(
                        authNotifier?.user?.email ?? "email addreess",
                        style: TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        child: GestureDetector(
                          onTap: () {
                            _showDialogLogout(context);
                          },
                          child: Center(
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(80.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(25),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutApp()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "About App",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<void> _showDialogLogout(BuildContext context) {
  AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(child: Text('Are you Sure to Logout')),
            content: Container(
              height: 100,
              width: 80,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            signout(authNotifier);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    LoginScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.green),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "Click outside for cancel",
                            style:
                                TextStyle(color: Colors.black45, fontSize: 11),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
      });
}
