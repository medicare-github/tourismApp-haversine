import '../models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lobardestination/allNotifier/authNotifier.dart';

Future<FirebaseUser> userLogin(User user, AuthNotifier authNotifier) async {
  try {
    FirebaseAuth _auth = FirebaseAuth.instance;
    AuthResult authResult = await _auth.signInWithEmailAndPassword(
        email: user.email, password: user.password);
    FirebaseUser firebaseUser = authResult.user;
    authNotifier.setUser(firebaseUser);
    return firebaseUser;
  } catch (e) {
    print("error: " + e.toString());
    return null;
  }
}

Future<FirebaseUser> userSignUp(User user, AuthNotifier authNotifier) async {
  try {
    FirebaseAuth _auth = FirebaseAuth.instance;
    AuthResult authResult = await _auth.createUserWithEmailAndPassword(
        email: user.email, password: user.password);

    if (authResult != null) {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = user.displayName;
      FirebaseUser firebaseUser = authResult.user;

      if (firebaseUser != null) {
        await firebaseUser.updateProfile(updateInfo);

        await firebaseUser.reload();

        print("Sign up: $firebaseUser");

        FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
        authNotifier.setUser(currentUser);
        return firebaseUser;
      }
    }
  } catch (e) {
    return null;
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance
      .signOut()
      .catchError((error) => print(error.code));
  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}
