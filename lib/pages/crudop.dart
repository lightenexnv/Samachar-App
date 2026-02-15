import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class crudOp extends StatefulWidget {
  const crudOp({super.key});

  @override
  State<crudOp> createState() => _crudOpState();
}

class _crudOpState extends State<crudOp> {

  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref("Post");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.all(20 ),
        child: Material(
          child: Column(
            children: [
              SizedBox(
                height:30,
              ),
              TextFormField(
                maxLines: 5,
                controller: postController,
                decoration: InputDecoration(
                  hintText: "Enter Your Text",
                  border: OutlineInputBorder(

                  )
                ),

              ),
              RoundButton(text: "Post", onTap: (){
                databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
                  'title' : postController.text,
                  'time' : DateTime.now().millisecondsSinceEpoch.toString()
                });
              }),
              Text("This is Read Data Using FirebaseAnimatedList"),
              Expanded(
                child: FirebaseAnimatedList(query: databaseRef, itemBuilder: (context,
                    snapshot, animation, index){
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('time').value.toString()),
                  );
                }),
              ),
              Text("This is Read Data Using StreamBuilder"),
              Expanded(child: StreamBuilder(
                  stream: databaseRef.onValue,
                  builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();

                    }else{
                      Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> list = [];
                      list.clear();
                      list = map.values.toList();
                      return ListView.builder(
                          itemCount: snapshot.data!.snapshot.children.length
                          ,itemBuilder: (context,index){
                        return ListTile(
                          title: Text(list[index]['title']),
                        );
                      });
                    }
              }))
            ],
          ),
        ),
      ),
    );
  }
}

Widget RoundButton({
  required String text,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(30),
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
