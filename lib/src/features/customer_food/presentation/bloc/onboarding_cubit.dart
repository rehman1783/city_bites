import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingState extends Equatable {
  final int currentPage;

  const OnboardingState({this.currentPage = 0});

  @override
  List<Object?> get props => [currentPage];
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState(currentPage: 0));

  void pageChanged(int index) {
    emit(OnboardingState(currentPage: index));
  }
}
