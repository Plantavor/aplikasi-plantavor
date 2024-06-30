class UserData {
  final String? uid;
  final String? name;
  final String? email;
  final String? no;

  UserData({this.uid, this.name, this.email, this.no = ''});

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'email': email,
        'no': no,
      };
}
