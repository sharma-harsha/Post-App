import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:signup_page/ui/auth/login_Screen.dart';
import 'package:signup_page/ui/firestore/add_firestore_data.dart';
import 'package:signup_page/ui/posts/add_post.dart';
import 'package:signup_page/utils/utils.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
   final auth = FirebaseAuth.instance;
  // final ref = FirebaseDatabase.instance.ref('Harsh');
  // final searchFilter = TextEditingController();
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('Users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('Users');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('FireStore'),
        actions: [IconButton(onPressed: (){
          auth.signOut().then((value){
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          });
        }, icon: Icon(Icons.logout_outlined),),
        SizedBox(width: 10,),
        ],
      ),

      body: Column(
        children: [
          SizedBox(height: 10,),

        StreamBuilder<QuerySnapshot>(
          stream:fireStore,
          builder : (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

            if(snapshot.connectionState == ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            if(snapshot.hasError)
              return Text('some error');

            return  Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context , index){
            return ListTile(
              onTap: (() {
                // ref.doc(snapshot.data!.docs[index]['id'].toString()).update({
                //   'title' : 'harsh'
                // }).then((value) => 
                //   Utils().toastMessage('updated')
                // ).onError((error, stackTrace) => 
                // Utils().toastMessage(error.toString())
                // );

                ref.doc(snapshot.data!.docs[index]['id'].toString()).delete();
              }),
              title: Text(snapshot.data!.docs[index]['title'].toString()),
              subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
            );
          }
          ),
          
           );}
        ),

        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
        //   child: TextFormField(
        //     controller: searchFilter,
        //     decoration: InputDecoration(
        //       hintText: 'search',
        //       border: OutlineInputBorder(),
              
        //       ),

        //       onChanged: (String value){
        //           setState(() {
                    
        //           });
        //       },
        //   ),
        // ),

        // Expanded(child: StreamBuilder(
        //   stream: ref.onValue,
        //   builder: (context , AsyncSnapshot<DatabaseEvent> snapshot){


        //     if(!snapshot.hasData){
        //       return CircularProgressIndicator();
        //     }else{
        //       Map<dynamic , dynamic> map = snapshot.data!.snapshot.value as dynamic;
        //       List<dynamic> list = [];
        //       list.clear();
        //       list = map.values.toList();

        //       return ListView.builder(
        //       itemCount: snapshot.data!.snapshot.children.length,
        //       itemBuilder: (context , index){
        //       return ListTile(
        //         title: Text(list[index]['title']),
        //         subtitle: Text(list[index]['id']),
        //       );
        //     });
 
        //     }
        //              },
        // )),

        

       
      ]
      ),

      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddFirestoreDataScreen()));
      } , 
       
       child: const Icon(Icons.add),

       ),

    );
  }

  Future<void> showMyDialog(String title , String id) async{
    editController.text = title;
    return showDialog(context: context, builder: (BuildContext context) { 
      return AlertDialog(
        title: Text('update'),
        content: Container(
          child: TextField(
            controller: editController,
            decoration: InputDecoration(
              hintText: 'edit here',

            ),

          ),
        ),
        actions: [
          TextButton(onPressed: (){
              Navigator.pop(context);
          }, child: Text('Cancel'),),

          TextButton(onPressed: (){
              Navigator.pop(context);
          }, child: Text('Update'),),
        ],
      );
     }
      
    );
  }
  

}