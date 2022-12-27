import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:signup_page/utils/utils.dart';
import 'package:signup_page/widgets/round_button.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {

  final PostController = TextEditingController();
  bool loading = false;
  // final databaseRef = FirebaseDatabase.instance.ref('Harsh');
  final fireStore = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add firestore Data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [

        SizedBox(height: 10,),

        TextFormField(
          maxLines: 4,
          controller: PostController,
          decoration: InputDecoration(
            hintText: 'what is in your mind',
            border: OutlineInputBorder(),
          ),
        ),

                SizedBox(height: 10,),

          RoundButton(title: 'Add', 
          loading: loading,
          onTap: (){

            setState(() {
              loading = true;
            });

              String id = DateTime.now().millisecondsSinceEpoch.toString();

            fireStore.doc(id).set({

              'title' : PostController.text.toString(),
              'id' : id,

            }).then((value){
              Utils().toastMessage('post Added');
              setState(() {
                loading : false;
              });
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
              setState(() {
                loading : false;
              });
            });

          }),

        ]),
      ),
    );
  }
}