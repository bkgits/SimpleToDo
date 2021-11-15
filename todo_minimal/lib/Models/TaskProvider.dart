


import 'package:flutter/material.dart';
import 'package:scientisst_db/scientisst_db.dart';

class TaskProvider extends ChangeNotifier{
  List<DocumentSnapshot> tasksList = <DocumentSnapshot>[];
  CollectionReference ref = ScientISSTdb.instance.collection('Tasks');
  //Get Tasks
  List<DocumentSnapshot> get getTasks {
   ref.getDocuments().then((value){
      tasksList = value;
    });
    return tasksList;
  }

  void addTask(String task,String description)async{
   DocumentReference docRef = await ref.add(
     {
       "task":task,
       "description":description,
       "completed":false,
     }
   );
    tasksList.add(await docRef.get());
   notifyListeners();
  }

  void updateTask(DocumentSnapshot snap,int index)async{
    ref.document(snap.id).update(
     snap.data
    );
    tasksList[index]=snap;

    notifyListeners();
  }

  void updateComplete(String id,int index,bool isCompleted)async{
    ref.document(id).update({
  "completed":isCompleted,
   });
    tasksList[index].data['completed']=isCompleted;
    notifyListeners();
  }

  //remove Tasks
  void removeTask(String id){
    ref.document(id).delete();
    tasksList.removeWhere((element) => element.id==id);
    notifyListeners();
}

}