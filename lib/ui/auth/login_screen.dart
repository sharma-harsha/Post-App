import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signup_page/ui/auth/login_with_phone_number.dart';
import 'package:signup_page/ui/auth/signup_screen.dart';
import 'package:signup_page/ui/forgot_passward.dart';
import 'package:signup_page/ui/posts/post_screen.dart';
import 'package:signup_page/utils/utils.dart';
import 'package:signup_page/widgets/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailContoller = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailContoller.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailContoller.text, password: passwordController.text)
        .then((value) {
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PostScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          centerTitle: true,
          automaticallyImplyLeading: false,
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
                  title: 'Login',
                  loading: loading,
                  onTap: (() {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  }),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPasswardScreen()),);
                          },
                          child: Text('Forgot passward?')),
                ),

                const SizedBox(height: 20,),

                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Forget passward'),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        },
                        child: Text('Sign Up'))
                  ],
                ),

                const SizedBox(height: 20,),

                InkWell(
                  onTap: (() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginWithPhoneNumber()));
                  }),
                  child: Container(
                    height: 50,
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.black,
                      )
                    ),
                
                    child: Center(child: Text(' login with the phone No '),),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
