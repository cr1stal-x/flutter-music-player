class UserModel {
  final String email;
  late final String password;
  late final String username;
  UserModel({required this.email, required this.password, required this.username});
  get name =>username;
  void setName(String n) {
    username = n;
  }
  void setPassword(String pass){
    password=pass;
  }
}
