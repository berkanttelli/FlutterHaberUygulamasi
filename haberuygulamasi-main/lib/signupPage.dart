import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'auth.dart';
import 'newsPage.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String email;
  String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void creatingAccount() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      signUp(email.trim(), password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NewsPage(uid: value.uid),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        bottomOpacity: 0.2,
        toolbarOpacity: 1,
        elevation: 0.0,
        title: Text(""),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
          child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.grey, Colors.grey[300]],
                begin: FractionalOffset(0.5, 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(top:90.0),),
            Form(
              child: Column(
                children: [
                  Text(
                    "Hemen kayıt ol ve son dakika haberlerini ilk sen öğren!",
                    style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)
                  ),
                  Padding(
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(45)),
                          labelText: "Email"),
                      validator: (_val) {
                        if (_val.isEmpty) {
                          return "Lutfen gecerli bir mail giriniz.";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        email = val;
                      },
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(45)),
                          labelText: "Password"),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: "Bir sifre belirlemeniz lazim"),
                        MinLengthValidator(8,
                            errorText:
                                "En az 8 karakterli bir sifre belirleyiniz")
                      ]),
                      onChanged: (val) {
                        password = val;
                      },
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45)),
                    child: Text("Kayit Ol"),
                    color: Colors.green,
                    onPressed: () {
                      creatingAccount();
                    },
                  )
                ],
              ),
              key: formkey,
            )
          ],
        ),
      )),
    );
  }
}
