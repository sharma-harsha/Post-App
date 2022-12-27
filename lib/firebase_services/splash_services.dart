import 'dart:async';
// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signup_page/ui/auth/login_Screen.dart';
import 'package:signup_page/ui/firestore/firestore_list_screen.dart';
import 'package:signup_page/ui/posts/post_screen.dart';
import 'package:signup_page/ui/upload_image.dart';

class SplashServices{

  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if(user != null){
       Timer(const Duration(seconds: 3) , ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => UploadImageScreen())));
  
    }else{
       Timer(const Duration(seconds: 3) , ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())));
  
    }

   
  }

}