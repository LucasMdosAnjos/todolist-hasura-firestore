import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo/app/modules/home/models/todo_model.dart';

import 'todo_repository_interface.dart';

class TodoFirebaseRepository implements ITodoRepository {
  final Firestore firestore;

  TodoFirebaseRepository(this.firestore);

  @override
  Stream<List<TodoModel>> getTodos() {
    return firestore
        .collection('todo')
        .orderBy('date')
        .snapshots()
        .map((query) {
      return query.documents.map((doc) {
        return TodoModel.fromDocument(doc);
      }).toList();
    });
  }

  @override
  Future delete(TodoModel model)async {
    await model.reference.delete();
  }
  
    @override
    Future salvar(TodoModel model) async {
      if(model.reference == null){
      model.reference = await Firestore.instance.collection('todo').add({
        'title':model.title,
        'check':model.check,
        'date':DateTime.now()
      });
    }else{
      await model.reference.updateData({
        'title':model.title,
        'check':model.check,
        'date':DateTime.now()
      });
    }
  }
}
