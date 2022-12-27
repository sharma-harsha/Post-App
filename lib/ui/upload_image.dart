// import 'dart:html';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signup_page/utils/utils.dart';
import 'package:signup_page/widgets/round_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'auth/login_Screen.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  bool loading = false;
  File? _image ;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Harsh');
  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery , imageQuality: 80);

    setState(() {
      if(pickedFile != null){

      _image = File(pickedFile.path);

    }else{
      print('no image picked');
    }
    });

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        centerTitle: true,
        actions: [IconButton(onPressed: (){
          auth.signOut().then((value){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          });
        }, icon: Icon(Icons.logout_outlined),),
        ],
        
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Center(
            child: InkWell(
              onTap: () {
                getImageGallery();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black
                  )
                ),
                child:  _image !=  null? Image.file(_image!.absolute) :  Center(child: Icon(Icons.image)),
              ),
            ),
          ),
          SizedBox(height: 39),
          RoundButton(title: 'Upload',loading: loading, onTap: (() async{
            
            setState(() {
              loading = true;
            });
            firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/foldername/' + DateTime.now().millisecondsSinceEpoch.toString());
            firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
            
            await Future.value(uploadTask);

            var newUrl = ref.getDownloadURL();
            databaseRef.child('1').set({
              'id' : '1211',
              'title' : newUrl.toString()
            }).then((value){
              setState(() {
              loading = false;
            });

            }).onError((error, stackTrace){
              setState(() {
              loading = false;
            });
            });
            setState(() {
              loading = false;
            });

            Utils().toastMessage('uploaded');

          }),)
        ]),
      ),
    );
  }
}
