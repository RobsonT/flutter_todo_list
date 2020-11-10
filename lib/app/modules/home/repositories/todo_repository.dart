import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo/app/modules/home/model/todo_model.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'todo_repository_interface.dart';

part 'todo_repository.g.dart';

@Injectable()
class TodoRepository implements ITodoRepository {
  final FirebaseFirestore firestore;

  TodoRepository(this.firestore);
  @override
  Stream<List<TodoModel>> getTodos() {
    return firestore
        .collection('todo')
        .orderBy('position')
        .snapshots()
        .map((query) {
      return query.docs.map((doc) {
        return TodoModel.fromDocument(doc);
      }).toList();
    });
  }
}
