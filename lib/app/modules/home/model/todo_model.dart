import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String title;
  String detail;
  bool check;
  DocumentReference reference;

  TodoModel(
      {this.reference, this.title = '', this.check = false, this.detail = ''});

  factory TodoModel.fromDocument(DocumentSnapshot doc) {
    return TodoModel(
        title: doc['title'],
        check: doc['check'],
        reference: doc.reference,
        detail: doc['detail']);
  }

  Future save() async {
    if (reference == null) {
      int total = (await FirebaseFirestore.instance.collection('todo').get())
          .docs
          .length;
      reference = await FirebaseFirestore.instance.collection('todo').add({
        'title': title,
        'check': check,
        'position': total,
        'detail': detail
      });
    } else {
      reference.update({'title': title, 'check': check, 'detail': detail});
    }
  }

  Future<void> delete() async {
    reference.delete();
  }
}
