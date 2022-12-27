import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_page/main.dart';
import 'package:signup_page/utils/utils.dart';
import 'package:signup_page/widgets/round_button.dart';

class ForgotPasswardScreen extends StatefulWidget {
  const ForgotPasswardScreen({super.key});

  @override
  State<ForgotPasswardScreen> createState() => _ForgotPasswardScreenState();
}

class _ForgotPasswardScreenState extends State<ForgotPasswardScreen> {

  final emailContoller = TextEditingController();
  final Auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Passward'),
      centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
  
          children: [
          TextFormField(
            controller: emailContoller,
            decoration: InputDecoration(
              hintText: 'email'
            ),
          ),
          SizedBox(height: 40,),
          RoundButton(title: 'forgot', onTap: (){
            Auth.sendPasswordResetEmail(email: emailContoller.text.toString()).then((value){
              Utils().toastMessage('we have sent a email to recover passward , please check email');
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          })
        ]),
      ),
    );
  }
}