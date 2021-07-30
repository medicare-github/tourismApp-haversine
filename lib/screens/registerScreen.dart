import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lobardestination/allNotifier/authNotifier.dart';
import '../pallete.dart';
import '../widgets/background-image.dart';
import '../widgets/widgets.dart';
import '../models/userModel.dart';
import 'package:provider/provider.dart';
import '../api/authApi.dart';
import '../widgets/loadingScreen.dart';
import '../screens/loginScreen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({this.error});
  final String error;
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  Future<void> _submitForm() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      AuthNotifier authNotifier =
          Provider.of<AuthNotifier>(context, listen: false);

      setState(() {
        loadingScreen = true;
      });

      dynamic result = await userSignUp(_user, authNotifier);
      if (result == null) {
        setState(() {
          loadingScreen = false;
          error = "email adresss already registred";
          // Navigator.pushNamed(context, '/');
        });
      } else {
        setState(() {
          loadingScreen = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              messageSignUp: 'success',
            ),
          ),
        );
      }
      // print("hasil" + result);
    }
  }

  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        BackgroundImage(
          image: 'assets/images/register_bg.png',
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: kWhite,
              ),
            ),
            title: Text(
              'Register new Account',
              style: kBodyText,
            ),
            centerTitle: true,
          ),
          body: loadingScreen
              ? Loading()
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: size.width * 0.8,
                              child: Text(
                                'Enter your data for create new account Lombok Destinations app',
                                style: kBodyText,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Form(
                              autovalidate: true,
                              key: _formkey,
                              child: Column(
                                children: <Widget>[
                                  TextInputField(
                                    icon: FontAwesomeIcons.user,
                                    hint: 'Fullname',
                                    inputAction: TextInputAction.next,
                                    inputType: TextInputType.text,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'Full name is required';
                                      }

                                      if (value.length < 4 ||
                                          value.length > 25) {
                                        return 'Full name must be betweem 4 and 25characters';
                                      }

                                      return null;
                                    },
                                    onSaved: (String value) {
                                      _user.displayName = value;
                                    },
                                  ),
                                  TextInputField(
                                    icon: FontAwesomeIcons.envelope,
                                    hint: 'Email',
                                    inputAction: TextInputAction.next,
                                    inputType: TextInputType.emailAddress,
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
                                    icon: FontAwesomeIcons.envelope,
                                    hint: 'Password',
                                    inputAction: TextInputAction.done,
                                    inputType: TextInputType.text,
                                    controller: _passwordController,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'Password is required';
                                      }

                                      if (value.length < 8 ||
                                          value.length > 20) {
                                        return 'Password must be betweem 8 and 20 characters';
                                      }

                                      return null;
                                    },
                                    onSaved: (String value) {
                                      _user.password = value;
                                    },
                                  ),
                                  PasswordInput(
                                    icon: FontAwesomeIcons.envelope,
                                    hint: 'Confirm Password',
                                    inputAction: TextInputAction.done,
                                    inputType: TextInputType.text,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'Confirm Password is required';
                                      }
                                      if (_passwordController.text != value) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RoundedButton(
                                    buttonName: "Register",
                                    routeName: 'ProfileScreen',
                                    onpress: () => _submitForm(),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Already have an account? ',
                                        style: kBodyText,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context, '/');
                                          },
                                          child: Text(
                                            'Login',
                                            style: kBodyText.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: kBlue),
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    error,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
        )
      ],
    );
  }
}
