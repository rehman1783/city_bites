import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/role_toggle_button.dart';

abstract class AuthState extends Equatable {
  final UserRole selectedRole;
  const AuthState({this.selectedRole = UserRole.customer});
  @override
  List<Object?> get props => [selectedRole];
}

class AuthInitial extends AuthState {
  const AuthInitial({super.selectedRole});
}

class AuthLoading extends AuthState {
  const AuthLoading({super.selectedRole});
}

class Authenticated extends AuthState {
  final String email;
  final UserRole role;
  const Authenticated({required this.email, required this.role, super.selectedRole});
  @override
  List<Object?> get props => [email, role, selectedRole];
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure({required this.message, super.selectedRole});
  @override
  List<Object?> get props => [message, selectedRole];
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  void roleToggled(UserRole role) {
    emit(AuthInitial(selectedRole: role));
  }

  Future<void> loginSubmitted({
    required String email,
    required String password,
  }) async {
    final currentRole = state.selectedRole;
    emit(AuthLoading(selectedRole: currentRole));
    await Future.delayed(const Duration(milliseconds: 1000));
    emit(Authenticated(
      email: email,
      role: currentRole,
      selectedRole: currentRole,
    ));
  }

  void logout() {
    emit(const AuthInitial());
  }
}
