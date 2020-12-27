import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
final _googleSignIn = GoogleSignIn();

showErrDialog(BuildContext context, String err) {
  FocusScope.of(context).requestFocus(new FocusNode());
  return showDialog(
    context: context,
    child: AlertDialog(
      title: Text("Hatali Islem"),
      content: Text(err),
      actions: <Widget>[
        OutlineButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Tamam"),
        ),
      ],
    ),
  );
}

Future<bool> signInWithGoogle() async {
  await Firebase.initializeApp();
  final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken);
  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  // ignore: await_only_futures
  final User currentUser = await _auth.currentUser;
  assert(currentUser.uid == user.uid);

  return Future.value(true);
}

Future<User> signUp(String email, String password, BuildContext context) async {
  await Firebase.initializeApp();
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return Future.value(user);
  } catch (e) {
    switch (e) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        print('error');
    }
  }
  return Future.value(null);
}

Future<User> signIn(String email, String password, BuildContext context) async {
  await Firebase.initializeApp();
  try {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return Future.value(user);
  } catch (e) {
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_WRONG_PASSWORD':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_USER_NOT_FOUND':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_USER_DISABLED':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        showErrDialog(context, e.code);
        break;
    }
  }
  return Future.value(null);
}

Future<Null>signOut() async {

  // ignore: await_only_futures
  User user = await _auth.currentUser;
  if(user.providerData[0].providerId == 'google.com'){
    await _googleSignIn.signOut();
  }

  
  await _auth.signOut();
  
}





