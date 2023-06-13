import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/database/model/task.dart';
import 'package:todo_app/database/model/user.dart';

class MyDataBase {
  static CollectionReference<User> getUSerCollection() {
    return FirebaseFirestore.instance.collection('users').withConverter<User>(
      fromFirestore: (snapshot, snapshotOptions) {
        return User.fromFireStore(snapshot.data());
      },
      toFirestore: (user, options) {
        return user.toFireStore();
      },
    );
  }

  static CollectionReference<Task> getTasksCollection(String uid) {
    return getUSerCollection()
        .doc(uid)
        .collection(Task.collectionName)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Task.fromFireStore(snapshot.data()!),
          toFirestore: (task, options) => task.toFireStore(),
        );
  }

  static CollectionReference<Task> getTaskCollection(String uid) {
    return getUSerCollection()
        .doc(uid)
        .collection(Task.collectionName)
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Task.fromFireStore(snapshot.data()!),
          toFirestore: (task, options) => task.toFireStore(),
        );
  }

  static Future<void> addUser(User user) {
    var collection = getUSerCollection();
    return collection.doc(user.id).set(user);
  }

  static Future<User?> readUser(String id) async {
    var collection = getUSerCollection();
    var docSnapshot = await collection.doc(id).get();
    return docSnapshot.data();
  }

  static Future<void> addTask(Task task, String uid) {
    var newTaskDoc = getTaskCollection(uid).doc();
    task.id = newTaskDoc.id;
    return newTaskDoc.set(task);
  }

  static Future<QuerySnapshot<Task>> getTasks(String uId) {
    return getTaskCollection(uId).get();
  }

  static Stream<QuerySnapshot<Task>> getTasksRealTimeUpdates(String uId) {
    return getTaskCollection(uId).snapshots();
  }

  static Future<void> deleteTask(String uid, String taskId) {
    return getTaskCollection(uid).doc(taskId).delete();
  }
}
