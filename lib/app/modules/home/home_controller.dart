import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo/app/modules/home/model/todo_model.dart';
import 'package:firebase_todo/app/modules/home/repositories/todo_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'repositories/todo_repository_interface.dart';

part 'home_controller.g.dart';

final $HomeController = BindInject(
  (i) => HomeController(i.get()),
  singleton: true,
  lazy: true,
);

@Injectable()
class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final ITodoRepository repository;

  @observable
  ObservableStream<List<TodoModel>> todoList;

  _HomeControllerBase(ITodoRepository this.repository) {
    getList();
  }

  @action
  getList() {
    todoList = repository.getTodos().asObservable();
  }
}
