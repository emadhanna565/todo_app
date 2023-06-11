class User {
  // data class
  String? id;

  String? name;
  String? email;

  User({this.id, this.name, this.email});

  //convert map to object from data base
  User.fromFireStore(Map<String, dynamic>? data)
      : this(id: data?['id'], name: data?['name'], email: data?['email']);

  /*{
    id = data['id'];
    name = data['name'];
    email = data['email'];
  }*/

  //convert object to map to dat base
  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
