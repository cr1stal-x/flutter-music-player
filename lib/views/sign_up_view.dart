import 'package:flutter/material.dart';
import 'package:musix/views/drawer.dart';
import 'package:musix/views/login_view.dart';
import 'package:provider/provider.dart';
import '../view_models/sign_up_view_model.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignUpViewModel(),
      child: Consumer<SignUpViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(),
            drawer: MyDrawer(),
            backgroundColor: Theme.of(context).colorScheme.surface,
            body:
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: vm.formKey,
                      child: Column(
                        children: [
                          Text('Sign Up',
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary)),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: vm.userNameController,
                            validator: vm.validateUserName,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_)=>FocusScope.of(context).requestFocus(vm.emailFocusNode),
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.account_box_rounded),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: vm.emailController,
                            validator: vm.validateEmail,
                            focusNode: vm.emailFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(vm.passwordFocusNode);
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: vm.passwordController,
                            validator: vm.validatePassword,
                            // onChanged: (value) => vm.updatePasswordStrength(value),
                            obscureText: vm.isObscure(),
                            focusNode: vm.passwordFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(vm.confirmPasswordFocusNode);
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                 vm.isObscure()? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                    vm.changeObscure();
                                },
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          // if (vm.passwordStrength.isNotEmpty)
                          //   Text(
                          //     vm.passwordStrength,
                          //     style: TextStyle(
                          //       color: vm.passwordStrength.contains('Very Strong')
                          //           ? Colors.green
                          //           : vm.passwordStrength.contains('Strong')
                          //           ? Colors.lightGreen
                          //           : vm.passwordStrength.contains('Medium')
                          //           ? Colors.orange
                          //           : Colors.red,
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: vm.confirmPasswordController,
                            validator: vm.validateConfirmPassword,
                            obscureText: true,
                            focusNode: vm.confirmPasswordFocusNode,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => vm.signUp(context),
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              vm.signUp(context);

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700)),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 200),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>Login(),
                                  ),
                                );
                              },
                              child: Text(
                                'Already have an account?',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.secondary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          ),

                        ],
                      ),
                    ),

                  ),
                ),
                );
        },
      ),
    );
  }
}

