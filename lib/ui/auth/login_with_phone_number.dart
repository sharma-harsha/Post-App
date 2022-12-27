// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_page/ui/auth/verify_code.dart';
import 'package:signup_page/utils/utils.dart';
import 'package:signup_page/widgets/round_button.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  bool loading = false;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login with phone'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          SizedBox(height: 50,),

          TextFormField(
            controller: phoneNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '+91 8764037976',
              icon: Icon(Icons.phone),
              
            ),
          ),

          SizedBox(height: 50,),

          RoundButton(title: 'Login', loading: loading  ,onTap: (){

            setState((){
              loading = true;
            });

            auth.verifyPhoneNumber(
              phoneNumber: phoneNumberController.text,
              verificationCompleted: (_){
               setState(() {
                 loading = false;
               });
              },
             verificationFailed: (e){
              setState(() {
                loading = false;
              });
              Utils().toastMessage(e.toString());
             },
              codeSent: (String verificationId , int? token){
                Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeScreen(verificationId: verificationId,)));
                setState(() {
                  loading = false;
                });

              }, 
              codeAutoRetrievalTimeout: (e){
                Utils().toastMessage(e.toString());
                setState(() {
                  loading = false;
                });
              }
              );
          })
        ]),
      ),
    );
  }
}
