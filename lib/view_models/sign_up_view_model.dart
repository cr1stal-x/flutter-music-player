import 'package:flutter/material.dart';
import 'package:musix/testClient.dart';
import 'package:musix/views/user_account_view.dart';
import 'package:provider/provider.dart';
import '../Auth.dart';

class SignUpViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final userNameController=TextEditingController();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final userNameFocusNode=FocusNode();
  final emailFocusNode=FocusNode();
  String passwordStrength = '';
  bool obscureText = true;


  void updatePasswordStrength(String value) {
    passwordStrength = validatePassword(value) ?? '';
    notifyListeners();
  }
  String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || !emailRegex.hasMatch(value)) {
      return 'Invalid email address.';
    }
    return null;
  }
  void changeObscure(){
    obscureText=!obscureText;
    notifyListeners();
  }
  bool isObscure(){
    return obscureText;
  }

  String? validatePassword(String? value) {
    // final veryStrongRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()]).{12,}$');
    // final strongRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    // final mediumRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{6,}$');
    // final weakRegex = RegExp(r'^[a-zA-Z]{4,}$');
    // final veryWeakRegex = RegExp(r'^([a-zA-Z]{1,3}|[0-9]{1,3})$');
    // if (value != null && value.isNotEmpty) {
    //   if (veryStrongRegex.hasMatch(value)) {
    //     return 'Very Strong';
    //   } else if (strongRegex.hasMatch(value)) {
    //     return 'Strong';
    //   } else if (mediumRegex.hasMatch(value)) {
    //     return 'Medium';
    //   } else if (weakRegex.hasMatch(value)) {
    //     return 'Weak';
    //   } else if (veryWeakRegex.hasMatch(value)) {
    //     return 'Very Weak';
    //   }
    // }
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$');
    if(value !=null && value.isNotEmpty){
      if(!regex.hasMatch(value) || value.toLowerCase().contains(userNameController.text.toLowerCase())){
          return 'Invalid password';
      }
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Passwords not matching.';
    }
    return null;
  }
  String? validateUserName(String? value){

    if (value == null || value.isEmpty) {
      return 'Username is required';
    } else if (value.length < 3) {
      return 'Username too short';
    }
    return null;
  }


  Future<void> signUp(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final client = Provider.of<CommandClient>(context, listen: false);

    final success = await auth.signUp(
      userNameController.text,
      emailController.text,
      passwordController.text,
      client,
    );

    if (success) {
      formKey.currentState?.reset();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      userNameController.clear();
      passwordStrength = '';
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text('SignUp complete!'))),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserAccount()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SignUp failed!')),
      );
    }
  }



  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

}
