import 'package:flutter_bloc/flutter_bloc.dart';

enum SplashStatus { initial, loading, completed }

class SplashCubit extends Cubit<SplashStatus> {
  SplashCubit() : super(SplashStatus.initial);

  void startSplashTimer() async {
    emit(SplashStatus.loading);
    await Future.delayed(const Duration(seconds: 2));
    emit(SplashStatus.completed);
  }
}
