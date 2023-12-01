import 'package:flutter/material.dart';
import 'package:news_feed/views/authentication/authentication_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/button.dart';
import '../widgets/text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confrimPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthenticationProvider(),
      child: Consumer<AuthenticationProvider>(
          builder: (context, valueModel, child) {
        return Scaffold(
          backgroundColor: Colors.grey[300],
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: valueModel.formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),

                      // logo
                      const Icon(
                        Icons.lock,
                        size: 100,
                      ),

                      const SizedBox(height: 50),

                      // welcome back, you've been missed!
                      Text(
                        'Welcome back you\'ve been missed!',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // username textfield

                      // username textfield
                      TextFieldWidget(
                        controller: usernameController,
                        hintText: 'User Name',
                        obscureText: false,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an user name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      TextFieldWidget(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address';
                          }

                          final RegExp emailRegex = RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
                          );

                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 10),

                      // password textfield
                      TextFieldWidget(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: valueModel.showPassword,
                        passwordSurfixIcon: true,
                        sufixIcon: GestureDetector(
                            onTap: () => valueModel.toggleShowPasswrod(),
                            child: valueModel.showPassword
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.black,
                                  )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      TextFieldWidget(
                        controller: confrimPasswordController,
                        hintText: 'Confrim Password',
                        obscureText: valueModel.showConfrimPassword,
                        passwordSurfixIcon: true,
                        sufixIcon: GestureDetector(
                            onTap: () => valueModel.toggleConfrimShowPasswrod(),
                            child: valueModel.showConfrimPassword
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.black,
                                  )),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (value != passwordController.text) {
                            return 'passwrod is not match';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 45),

                      // sign in button
                      ButtonWidget(
                        onTap: () {
                          valueModel.userModel.name = usernameController.text;
                          valueModel.userModel.email = emailController.text;
                          valueModel.userModel.password =
                              passwordController.text;

                          valueModel.signUp(context);
                        },
                        title: 'Sign Up',
                        isLoading: valueModel.isLoading,
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
