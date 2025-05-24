import 'package:musix/views/sign_up_view.dart';
import 'package:musix/views/user_account_view.dart';

import '../views/shop2_view.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class Login extends StatefulWidget {

  //UserModel user;
  //Login({Key? test, required this.user}) : super(key: test);
  const Login({Key? test}) : super(key: test);

  //making state for this page
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  //fields: 2 text & 1 error
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
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

    if(user.name!=username && user.email!=username) {
      setState(() {
        _error = 'can not find a person with this name!';
        _welcome = null;
      });
      return;
    }

    else if(user.password!=password) {
      setState(() {
        _error = 'incorrect password';
        _welcome = null;
      });
      return;
    }

    setState(() {
      _error = null;
      _welcome = 'Logged in successfully✅ welcome $username!';
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserAccount(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //totalPage
        backgroundColor: Theme.of(context).colorScheme.surface, //lightPink
        appBar: AppBar( //topOfPage
          centerTitle: true, //center
          title:
           Text(
            "Login to user account",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
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
               Text(
                "Welcome!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color:  Theme.of(context).colorScheme.secondary,
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
                    backgroundColor:  Theme.of(context).colorScheme.secondary,
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
                    MaterialPageRoute(builder: (context) => SignUpView()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration:  BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.5, color:  Theme.of(context).colorScheme.secondary),
                      bottom: BorderSide(width: 1.5, color:  Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  child:  Text(
                    "don't have account? SignUp",
                    style: TextStyle(
                      fontSize: 16,
                      color:  Theme.of(context).colorScheme.secondary,
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
                  child: Text(
                    "forget password?",
                    style: TextStyle(
                      fontSize: 16,
                      color:  Theme.of(context).colorScheme.inversePrimary,
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