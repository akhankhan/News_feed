import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/button.dart';
import '../widgets/square_tile.dart';
import '../widgets/text_field.dart';
import 'authentication_provider.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final String email;
  LoginScreen({super.key, this.email = ''});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    emailController.text = email.toString();
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
                    key: valueModel.loginFormkey,
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
                        AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Welcome back you\'ve been missed!',
                              textStyle: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                              speed: const Duration(milliseconds: 200),
                            ),
                          ],
                          totalRepeatCount: 2,
                          pause: const Duration(milliseconds: 1000),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),

                        const SizedBox(height: 25),

                        // username textfield
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
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 35),

                        // sign in button
                        ButtonWidget(
                          onTap: () {
                            valueModel.signIn(
                              context,
                              emailController.text,
                              passwordController.text,
                            );
                          },
                          title: 'Sign In',
                          isLoading: valueModel.isLoading,
                        ),

                        const SizedBox(height: 50),

                        // or continue with
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  'Or continue with',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // google + apple sign in buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // google button
                            GestureDetector(
                              onTap: () => valueModel.googleSignIn(context),
                              child: const SquareTile(
                                  imagePath: 'assets/images/google.png'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 50),

                        // not a member? register now
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Not a member?',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpScreen()));
                              },
                              child: const Text(
                                'Register now',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}
