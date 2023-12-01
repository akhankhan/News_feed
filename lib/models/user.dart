class UserModel {
  String? name;
  String? email;
  String? password;
  String? userProfile;

  UserModel({this.name, this.email, this.password, this.userProfile});

  factory UserModel.fromJson(json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      userProfile: json['userProfile'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': name,
      'email': email,
      'userProfile': userProfile,
    };
  }
}
