class UserModel {
  final String email;
  final String password;
  final String username;
  UserModel({required this.email, required this.password, required this.username});
  get name =>username;
}
