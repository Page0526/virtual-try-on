class UserModel {
  final String id;
  final String firstname;
  final String lastname;
  final String username;
  final String emailorphone;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.username,
    required this.emailorphone,
  });

  // Convert a UserModel into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'emailorphone': emailorphone,
   
    };
  }

  String get fullname => '$firstname $lastname';

  bool get isEmail => emailorphone.contains('@');


  // convert model to Json for firebase storing 
  Map<String, dynamic> toJson() {
    String email = isEmail ? emailorphone : '';
    String phone = isEmail ? '' : emailorphone;    
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'phone': phone,
    };
  }

  String toString() {
    return 'UserModel{id: $id, firstname: $firstname, emailorphone: $emailorphone}';
  }
}
