import 'package:authentication_firebase_bloc/controller/auth_cubit.dart';
import 'package:authentication_firebase_bloc/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class Home extends StatefulWidget {
  final UserCredential userCredential;
  const Home({super.key, required this.userCredential});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: InkWell(
                  onTap: () {
                    context.read<AuthCubit>().signOut();
                    Get.offAll(() => SignInScreen());
                  },
                  child: const Text(
                    'Logout',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'Welcome \n ${widget.userCredential.user?.email ?? ""}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        );
      }),
    );
  }
}
