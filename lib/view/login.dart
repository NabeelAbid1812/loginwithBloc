import 'package:authentication_firebase_bloc/constant/images.dart';
import 'package:authentication_firebase_bloc/constant/snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/auth_cubit.dart';

class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(FirebaseAuth.instance),
      child: Scaffold(
        backgroundColor: const Color(0xFF1B2236),
        // appBar: AppBar(title: const Text('Sign In')),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushReplacementNamed('/home');
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? 'Sign In Failed')),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 160,
                      width: 400,
                    ),
                    const Text(
                      "Log in!",
                      style: TextStyle(
                          fontSize: 41,
                          color: Color(0xFFCD5B97),
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 100,
                      width: 400,
                    ),
                    TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Image.asset(
                            Images.email,
                            height: 3,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: passwordController,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Image.asset(
                            Images.password,
                            height: 3,
                            width: 3,
                          ),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
              
                            if (email.isEmpty && password.isEmpty) {
                              SnackbarWidget()
                                  .snackbar('Alert', 'Please fill all fields');
                              return;
                            } else if (email.isEmpty) {
                              SnackbarWidget()
                                  .snackbar('Alert', 'Please fill email field');
                              return;
                            } else if (!validateEmail(emailController.text)) {
                              SnackbarWidget()
                                  .snackbar('Alert', 'Please enter valid email');
                              return;
                            } else if (password.isEmpty) {
                              SnackbarWidget().snackbar(
                                  'Alert', 'Please fill password field');
                              return;
                            } else {
                              context
                                  .read<AuthCubit>()
                                  .signInOrSignUpWithEmailAndPassword(
                                      email, password);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return false;
    } else {
      return true;
    }
  }
}
