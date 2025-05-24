class UserModel {
  late final String email;
  late final String password;
  late final String username;
  UserModel({required this.email, required this.password, required this.username});
  get getName =>username;
  get getPassword =>password;
  get getEmail =>email;

  void setName(String name){ username = name;}
  void setPassword(String pass){ password = pass;}
  void setEmail(String emmail){ email = emmail;}

}
