import 'package:firebase_todo/app/modules/home/model/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Lista de tarefas"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Observer(
        builder: (_) {
          if (controller.todoList.hasError) {
            return Center(
              child: RaisedButton(
                onPressed: controller.getList(),
                child: Text('Error'),
              ),
            );
          }

          if (controller.todoList.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<TodoModel> list = controller.todoList.data;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, index) {
              TodoModel model = list[index];
              return ListTile(
                title: Text(model.title),
                subtitle: Text(model.detail),
                onTap: () {
                  _showDialog(model);
                },
                leading: IconButton(
                  icon: Icon(Icons.delete_sharp, color: Colors.red),
                  onPressed: model.delete,
                ),
                trailing: Checkbox(
                  value: model.check,
                  onChanged: (check) {
                    model.check = check;
                    model.save();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  _showDialog([TodoModel model]) {
    model ??= TodoModel();
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(model.title.isEmpty ? 'Novo' : 'Edição'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: model.title,
                  onChanged: (value) => model.title = value,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Título...'),
                ),
                SizedBox(height: 12),
                TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  initialValue: model.detail,
                  onChanged: (value) => model.detail = value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Detalhes...',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Modular.to.pop();
                },
                child: Text('Cancelar'),
              ),
              FlatButton(
                onPressed: () async {
                  await model.save();
                  Modular.to.pop();
                },
                child: Text('Salvar'),
              )
            ],
          );
        });
  }
}
