part of '../controller/auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User? user;

  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String? error;

  AuthFailure(this.error);
}