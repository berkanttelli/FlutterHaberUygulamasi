import 'package:flutter/material.dart';
import 'package:haberuygulamasi/signupPage.dart';
import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'newsPage.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginRegisterPage extends StatefulWidget {
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
  LoginRegisterPage({Key key}) : super(key: key);
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  String email;
  String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.purpleAccent, Colors.purple[200]],
                    begin: FractionalOffset(0.5, 1))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                  child: Image(
                    image: AssetImage('assets/mask.png'),
                    height: 110,
                    fit: BoxFit.fill,
                  ),
                ),
                Form(
                    key: formkey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300.0,
                            height: 70.0,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(45)),
                                labelText: "Email",
                              ),
                              onChanged: (val) {
                                email = val;
                              },
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Doldurulması zorunlu"),
                                EmailValidator(
                                    errorText:
                                        "Geçerli Bir Mail Adresi Giriniz.")
                              ]),
                            ),
                          ),
                          SizedBox(
                            width: 300.0,
                            height: 70.0,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(45)),
                                  labelText: "Şifre"),
                              onChanged: (val) {
                                password = val;
                              },
                              obscureText: true,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: "Lütfen Şifrenizi Giriniz.")
                              ]),
                            ),
                          ),
                          SizedBox(
                            width: 200.0,
                            child: RaisedButton(
                              onPressed: () {
                                if (formkey.currentState.validate()) {
                                  formkey.currentState.save();
                                  signIn(email, password, context)
                                      .then((value) {
                                    if (value != null) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => NewsPage(
                                                    uid: value.uid,
                                                  )));
                                    }
                                  });
                                }
                              },
                              child: Text("Giriş Yap"),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(45)),
                              color: Colors.green,
                            ),
                          )
                        ])),
                Container(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 100, 0, 20),
                  child: Text("Hesabın yok mu?"),
                ),
                RaisedButton(
                  clipBehavior: Clip.antiAlias,
                  onPressed: () => {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignUpScreen()))
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45)),
                  color: Colors.grey[300],
                  child: Text("Hesap Oluştur"),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text("Ya da"),
                ),
                RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/google_logo.png'),
                            height: 20,
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Google ile giriş yap",
                              ))
                        ],
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45)),
                    onPressed: () => signInWithGoogle().whenComplete(() async {
                          // ignore: await_only_futures
                          User user = await FirebaseAuth.instance.currentUser;

                          if (user.uid != null) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => NewsPage(
                                          uid: user.uid,
                                        )));
                          }
                        }))
              ],
            ),
          ),
        ));
  }
}


