// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signup_page/ui/auth/login_Screen.dart';
import 'package:signup_page/utils/utils.dart';
import 'package:signup_page/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailContoller = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: emailContoller.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailContoller.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        // automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailContoller,
                        decoration: const InputDecoration(
                          // prefixIcon: Icon(Icons.alternate_email),
                          filled: true,
                          fillColor: Colors.white,
                          icon: Icon(Icons.email),
                          hintText: 'Enter Your Email',
                          hintStyle: TextStyle(
                              // color: Colors.black
                              ),
                          // border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          // prefixIcon: Icon(Icons.alternate_email),
                          filled: true,
                          fillColor: Colors.white,
                          icon: Icon(Icons.lock_open),
                          hintText: 'Enter A Strong Password',
                          hintStyle: TextStyle(
                              // color: Colors.black
                              ),
                          // border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'enter password';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              RoundButton(
                title: 'Sign Up',
                loading: loading,
                onTap: (() {
                  if (_formKey.currentState!.validate()) {
                    signUp();
                  }
                }),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an  account'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text('Login'))
                ],
              )
            ]),
      ),
    );
  }
}
