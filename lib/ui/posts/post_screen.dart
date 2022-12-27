import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signup_page/ui/auth/login_Screen.dart';
import 'package:signup_page/ui/posts/add_post.dart';
import 'package:signup_page/utils/utils.dart';


class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {

  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Harsh');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('posts'),
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
    
        body: Column(children: [
    
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: 'search',
                border: OutlineInputBorder(),
                
                ),
    
                onChanged: (String value){
                    setState(() {
                      
                    });
                },
            ),
          ),
    
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
    
          Expanded(
            child: FirebaseAnimatedList(query: ref,
            defaultChild: Text('loading'),
             itemBuilder: (context, snapshot, animation, index){
              
              final title = snapshot.child('title').value.toString();
              if(searchFilter.text.isEmpty){
    
                return  ListTile(
              title: Text(snapshot.child('title').value.toString()),
              subtitle: Text(snapshot.child('id').value.toString()),
              trailing: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    
                    value: 1,
                    child: ListTile(
    
                      onTap: (() {
                        
                        showMyDialog(title , snapshot.child('id').value.toString());
                        Navigator.pop(context);
                      }),
                    leading: Icon(Icons.edit),
                    title: Text('edit'),
                  ),
                  ),
    
                  PopupMenuItem(
                    value: 2,
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        ref.child(snapshot.child('id').value.toString()).remove();
                      },
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                    )
                    
                    ),
                ],
              ),
              );
    
              }else if(title.toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())){
                
                return  ListTile(
              title: Text(snapshot.child('title').value.toString()),
              subtitle: Text(snapshot.child('id').value.toString()),
              trailing: PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: ListTile(
                      onTap: (() {
                        
                        showMyDialog(title , snapshot.child('id').value.toString());
                        Navigator.pop(context);
                      }),
                    leading: Icon(Icons.edit),
                    title: Text('edit'),
                  ),
                  ),
    
                  PopupMenuItem(
                    value: 2,
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        ref.child(snapshot.child('id').value.toString()).remove();
                      },
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                    )
                    
                    ),
                ],
              ),
    
              );
    
              }else{
                return Container();
              }
    
              
             }
            ),
          ),
    
         
        ]),
    
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostScreen()));
        } , 
         
         child: const Icon(Icons.add),
    
         ),
    
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
              ref.child(id).update({
                'title' : editController.text.toLowerCase(),
              }).then((value){
                Utils().toastMessage('post updated');
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
              });
          }, child: Text('Update'),),
        ],
      );
     }
      
    );
  }


}