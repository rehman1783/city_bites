import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum UserRole { customer, restaurantOwner }
enum AuthMode { login, signup }

class AuthState extends Equatable {
  final UserRole role;
  final AuthMode mode;
  final bool isLoading;
  final bool isAuthenticated;
  final String? userEmail;
  final String? userName;

  const AuthState({
    this.role = UserRole.customer,
    this.mode = AuthMode.login,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userEmail,
    this.userName,
  });

  AuthState copyWith({
    UserRole? role,
    AuthMode? mode,
    bool? isLoading,
    bool? isAuthenticated,
    String? userEmail,
    String? userName,
  }) {
    return AuthState(
      role: role ?? this.role,
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object?> get props => [role, mode, isLoading, isAuthenticated, userEmail, userName];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void setRole(UserRole role) {
    emit(state.copyWith(role: role));
  }

  void setMode(AuthMode mode) {
    emit(state.copyWith(mode: mode));
  }

  void login({required String email, required String password}) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 1000));
    emit(state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      userEmail: email,
      userName: state.role == UserRole.customer ? 'Ali Raza' : 'Royal Taj Restaurant Owner',
    ));
  }

  void signup({required String name, required String email, required String password}) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 1000));
    emit(state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      userEmail: email,
      userName: name,
    ));
  }

  void logout() {
    emit(const AuthState());
  }
}
