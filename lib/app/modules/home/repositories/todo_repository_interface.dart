import '../models/todo_model.dart';

abstract class ITodoRepository {
  Stream<List<TodoModel>> getTodos();
  Future salvar(TodoModel model);
  Future delete(TodoModel model);
}
