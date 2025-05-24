import 'package:fintest/shop2.dart';
import 'package:flutter/material.dart';
import 'models/user_model.dart';

class Login extends StatefulWidget {

  //UserModel user;
  //Login({Key? test, required this.user}) : super(key: test);
  Login({Key? test}) : super(key: test);

  //making state for this page
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  //fields: 2 text & 1 error
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  String? _error;
  String? _welcome;

  //just for test!

  final user = UserModel(
      email: "sample@gmail.com",
      password: "ghghGH45",
      username: "Saytania"
  );

  //methods:
  void _login() {
    final username = _username.text.trim(); //for remove spaces
    final password = _password.text;

    if(!user.getName.equals(username) && !user.getEmail.equals(username)) {
      setState(() {
        _error = 'can not find a person with this name!';
        _welcome = null;
      });
      return;
    }

    else if(!user.getPassword.equals(password)) {
      setState(() {
        _error = 'incorrect password';
        _welcome = null;
      });
      return;
    }

    setState(() {
      _error = null;
      _welcome = 'Logged in successfully✅ welcome ${username}!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //totalPage
        backgroundColor: Color(0xFFFFE4E6), //lightPink
        appBar: AppBar( //topOfPage
          centerTitle: true, //center
          title:
          const Text(
            "Login to user account",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          //centerTitle: true,
        ),
        body: //mainOfPage
        Padding( //emptySpaceIn
        padding: const EdgeInsets.all(24.0), //24pixel emptySpaceIn in 4 corners
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center, //center
            children: [
              //welcome box
              const Text(
                "Welcome!",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 20),

              //username box
              Material( //art effects of widget
                elevation: 4,  //shadow
                borderRadius: BorderRadius.circular(16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Username:',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder( //cadr
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true, //necessary to set color for background
                    fillColor: Colors.white,
                  ),
                  controller: _username,
                ),
              ),
              const SizedBox(height: 24),

              //password box
              Material(
                elevation: 4,  //shadow
                borderRadius: BorderRadius.circular(16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Password:',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true, //necessary to set color for background
                    fillColor: Colors.white,//?
                  ),
                  controller: _password,
                  obscureText: true, //hide the letters
                ),
              ),
              const SizedBox(height: 24),

              if(_error != null) ...[
                Text(
                  _error!,
                  style:
                  const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
              ],

              if(_welcome != null) ...[
                Text(
                  _welcome!,
                  style:
                  const TextStyle(color: Colors.green),
                ),
                const SizedBox(height: 16),
              ],

              //enter box
              SizedBox( //?
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: _login,
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    textStyle: const TextStyle(fontSize: 16),
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              //goto signup page

              GestureDetector(//make widget clickAble
                onTap: () {
                  Navigator.push(
                    context,
                    //MaterialPageRoute(builder: (context) => SignUp()),
                    MaterialPageRoute(builder: (context) => Shop2(category: 'pop',)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.5, color: Colors.pink),
                      bottom: BorderSide(width: 1.5, color: Colors.pink),
                    ),
                  ),
                  child: const Text(
                    "don't have account? SignUp",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.pink,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                  ),
                  child: const Text(
                    "forget password?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }
}