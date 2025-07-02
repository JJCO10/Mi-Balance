class UserModel {
  final String uid;
  final String email;
  final String name;
  final String nickname;
  final String gender;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.nickname,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'nickname': nickname,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      nickname: map['nickname'],
      gender: map['gender'],
    );
  }
}
