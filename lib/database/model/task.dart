class Task {
  static const String collectionName = 'task';
  String? id;
  String? title;
  String? desc;
  DateTime? dateTime;
  bool? isDone;

  Task({this.id, this.title, this.desc, this.dateTime, this.isDone = false});

  Task.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data['id'],
          title: data['title'],
          desc: data['desc'],
          dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
          isDone: data['isDone'],
        );

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'dateTime': dateTime?.millisecondsSinceEpoch,
      'isDone': isDone,
    };
  }
}
