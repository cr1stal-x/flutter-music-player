import 'package:musix/views/sign_up_view.dart';
import 'package:musix/views/user_account_view.dart';
import 'package:provider/provider.dart';
import '../Auth.dart';
import '../testClient.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  const Login({Key? test}) : super(key: test);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? _error;
  String? _welcome;


  void _login() async {
    final username = _username.text.trim();
    final password = _password.text;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final client = Provider.of<CommandClient>(context, listen: false);

    final success = await authProvider.login(username, password, client);
    if (success) {
      setState(() {
        _error = null;
        _welcome = 'Logged in successfully✅ welcome $username!';
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserAccount()),
      );
    } else {
      setState(() {
        _error = 'Login failed. Check your username or password.';
        _welcome = null;
      });
    }
  }

  Future<void> _forgetPassword(String newValue) async {
    final client = Provider.of<CommandClient>(context, listen: false);
    final response = await client.sendCommand("ForgetPassword",extraData: {"username":newValue});
    if(response["status-code"]==200){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("new password sent to your email.")),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("user not found.")),);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold( //totalPage
        backgroundColor: Theme.of(context).colorScheme.surface, //lightPink
        appBar: AppBar( //topOfPage
          centerTitle: true,
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
                  Navigator.pushReplacement(
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
                onTap: (){
                  TextEditingController controller = TextEditingController();
                  showDialog(context: context,
                      builder: (context){
                        return AlertDialog(
                          backgroundColor: Colors.white70,
                          title: Text("Enter your username"),
                          content: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText:"username",
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Theme.of(context).colorScheme.secondary,
                                    side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                  ),
                                  child: Text("Cancel"),
                                ),
                                SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    String newValue = controller.text.trim();
                                    if(newValue.isNotEmpty) {
                                      _forgetPassword(newValue);
                                    }
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("new password sent to your email.")),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.secondary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text("ok"),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                  );

                },
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