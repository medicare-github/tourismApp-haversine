import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/widgets.dart';
import 'package:lobardestination/pallete.dart';
import '../api/authApi.dart';
import 'landingScreen.dart';
import 'registerScreen.dart';
import 'package:lobardestination/allNotifier/authNotifier.dart';
import '../models/userModel.dart';
import 'package:provider/provider.dart';
import '../widgets/loadingScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({this.messageSignUp});
  final messageSignUp;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();

  User _user = User();
  bool loadingScreen = false;
  String error = '';

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  Future<void> _submitLogin() async {
    if (_formkey.currentState.validate()) {
      setState(() => loadingScreen = true);
      _formkey.currentState.save();

      AuthNotifier authNotifier =
          Provider.of<AuthNotifier>(context, listen: false);

      dynamic result = await userLogin(_user, authNotifier);
      if (result == null) {
        setState(() {
          loadingScreen = false;
          error = "please check email and password";
        });
      } else {
        setState(() {
          loadingScreen = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LandingScreen(),
          ),
        );
      }
    }
  }

  Widget build(BuildContext context) {
    String message = widget.messageSignUp;
    return Stack(
      children: [
        BackgroundImage(
          image: 'assets/images/login_bg.png',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: loadingScreen
              ? Loading()
              : Column(
                  children: [
                    widget.messageSignUp != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 50),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.green[100],
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.done_all,
                                    size: 40,
                                  ),
                                  Text(
                                    "Email Adrees success Registred ",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    Flexible(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Welcome to Lombok',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Destinations',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Form(
                      autovalidate: true,
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          TextInputField(
                            icon: FontAwesomeIcons.envelope,
                            hint: "Email",
                            inputType: TextInputType.emailAddress,
                            inputAction: TextInputAction.next,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Email is required';
                              }

                              if (!RegExp(
                                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }

                              return null;
                            },
                            onSaved: (String value) {
                              _user.email = value;
                            },
                          ),
                          PasswordInput(
                            icon: FontAwesomeIcons.lock,
                            hint: "Password",
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Password is required';
                              }

                              if (value.length < 8 || value.length > 20) {
                                return 'Password must be betweem 8 and 20 characters';
                              }

                              return null;
                            },
                            onSaved: (String value) {
                              _user.password = value;
                            },
                          ),
                          Text(
                            'Forgot Password',
                            style: kBodyText,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RoundedButton(
                            buttonName: "Login",
                            routeName: "LandingScreen",
                            onpress: () => _submitLogin(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Container(
                        child: Text(
                          'Create New Account',
                          style: kBodyText,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1, color: kWhite),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
        )
      ],
    );
  }
}
