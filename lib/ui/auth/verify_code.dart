import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signup_page/ui/posts/post_screen.dart';
import 'package:signup_page/utils/utils.dart';
import 'package:signup_page/widgets/round_button.dart';


class VerifyCodeScreen extends StatefulWidget {

  final String verificationId;
  const VerifyCodeScreen({Key? key , required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
 bool loading = false;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

          SizedBox(height: 50,),

          TextFormField(
            controller: verificationCodeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: '6 digit code',
              icon: Icon(Icons.phone),
              
            ),
          ),

          const SizedBox(height: 50,),

          RoundButton(title: 'verify', loading: loading  ,onTap: () async{

            setState(() {
              loading = true;
            });

            final credential = PhoneAuthProvider.credential(verificationId: widget.verificationId,
             smsCode: verificationCodeController.text.toString(),
             );

             try{

              await auth.signInWithCredential(credential);
              Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen()));
              
             }catch(e){

              setState(() {
                loading = false;
              });
              Utils().toastMessage(e.toString());
             }
            
          })
        ]),
      ),
    );
  }
}
