import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:signup_page/utils/utils.dart';
import 'package:signup_page/widgets/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  final PostController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Harsh');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
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

            String id = DateTime.now().microsecondsSinceEpoch.toString();

            databaseRef.child(id).set({
              'title' : PostController.text.toString() ,
              'id' : id,
            }).then((value){
              Utils().toastMessage('Post Added');
              setState(() {
                loading = false;
              });
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
              setState(() {
                loading = false;
              });
            });

          }),

        ]),
      ),
    );
  }
}