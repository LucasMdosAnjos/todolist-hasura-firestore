import 'package:firebase_todo/app/modules/home/models/todo_model.dart';
import 'package:firebase_todo/app/modules/home/repositories/todo_repository_interface.dart';
import 'package:hasura_connect/hasura_connect.dart';
import './documents/todo_document.dart';

class TodoHasuraRepository implements ITodoRepository {

  final HasuraConnect connect;

  TodoHasuraRepository(this.connect);
  
  @override
  Stream<List<TodoModel>> getTodos() {
    return connect.subscription(todosQuery).map((query){
      return (query['data']['todos'] as List).map((json){
        return TodoModel.fromJson(json);
      }).toList();
    });
  }

  @override
  Future salvar(TodoModel model)async {
    if(model.id == null){
      var data = await connect.mutation(
        todosInsertQuery,
        variables: {
          'title':model.title
        }
        );
        model.id = data['data']['insert_todos']['returning'][0]['id'];
    }else{
      await connect.mutation(
        todosUpdateQuery,
        variables: {
          'title':model.title,
          'check':model.check,
          'id':model.id
        },
      );
    }
  }

  @override
  Future delete(TodoModel model) async {
    await connect.mutation(todosDeleteQuery,variables: {
      'id':model.id
    });
  }


}