// ignore_for_file: deprecated_member_use

import 'package:authentication_firebase_bloc/view/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';

part '../constant/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthCubit(this._firebaseAuth) : super(AuthInitial());

  Future<void> signInOrSignUpWithEmailAndPassword(
      String email, String password) async {
    emit(AuthLoading());
    try {
      // If user not found, create a new user
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthFailure(
          'New user created Successfully with email: ${userCredential.user?.email}'));
      emit(AuthLoading());
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Get.offAll(() => Home(
            userCredential: userCredential,
          ));
      emit(AuthSuccess(userCredential.user));
    } on FirebaseAuthException catch (e) {
      if (e.message!
          .contains('The email address is already in use by another account')) {
        try {
          UserCredential userCredential =
              await _firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          emit(AuthFailure(
              'User signed in Successfully with email:  ${userCredential.user?.email}'));
          Get.offAll(() => Home(
                userCredential: userCredential,
              ));
        } on FirebaseAuthException catch (e) {
          // Handle errors related to user creation
          if (kDebugMode) {
            print("Failed to signed user: ${e.message}");
          }
          if (e.code == 'wrong-password') {
            emit(AuthFailure(e.message));
            // Handle incorrect password
            if (kDebugMode) {
              print("Wrong password provided.");
            }
            emit(AuthFailure('Wrong password provided.'));
            // Emit failure state or show an error message to the user
          } else {
            emit(AuthFailure(e.message));
            // Handle other errors
            if (kDebugMode) {
              print("Error: ${e.message}");
            }
            // Emit failure state or show an error message to the user
          }
        }
      }
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    emit(AuthInitial());
  }
}
