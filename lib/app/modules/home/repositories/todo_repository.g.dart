part of 'todo_repository.dart';

final $TodoRepository = BindInject(
  (i) => TodoRepository(FirebaseFirestore.instance),
  singleton: true,
  lazy: true,
);
