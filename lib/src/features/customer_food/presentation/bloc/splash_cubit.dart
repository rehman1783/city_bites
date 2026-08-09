import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}
class SplashLoading extends SplashState {}
class Unauthenticated extends SplashState {}
class AuthenticatedCustomer extends SplashState {}
class AuthenticatedOwner extends SplashState {}
class AuthenticatedAdmin extends SplashState {}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkAuthStatusAndConfig() async {
    emit(SplashLoading());
    await Future.delayed(const Duration(milliseconds: 2500));
    // Default to Unauthenticated for fresh onboarding
    emit(Unauthenticated());
  }
}
