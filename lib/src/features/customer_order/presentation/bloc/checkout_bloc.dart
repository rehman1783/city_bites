import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CheckoutState extends Equatable {
  final String selectedAddress;
  final String selectedPaymentMethod;
  const CheckoutState({
    this.selectedAddress = 'Scheme 3, College Road, Sahiwal',
    this.selectedPaymentMethod = 'COD',
  });
  @override
  List<Object?> get props => [selectedAddress, selectedPaymentMethod];
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial({super.selectedAddress, super.selectedPaymentMethod});
}

class OrderPlacing extends CheckoutState {
  const OrderPlacing({super.selectedAddress, super.selectedPaymentMethod});
}

class OrderSuccess extends CheckoutState {
  final String orderId;
  const OrderSuccess({
    required this.orderId,
    super.selectedAddress,
    super.selectedPaymentMethod,
  });
  @override
  List<Object?> get props =>
      [orderId, selectedAddress, selectedPaymentMethod];
}

class OrderFailure extends CheckoutState {
  final String error;
  const OrderFailure({
    required this.error,
    super.selectedAddress,
    super.selectedPaymentMethod,
  });
  @override
  List<Object?> get props => [error, selectedAddress, selectedPaymentMethod];
}

class CheckoutBloc extends Cubit<CheckoutState> {
  CheckoutBloc() : super(const CheckoutInitial());

  void selectAddress(String address) {
    emit(CheckoutInitial(
      selectedAddress: address,
      selectedPaymentMethod: state.selectedPaymentMethod,
    ));
  }

  void selectPaymentMethod(String method) {
    emit(CheckoutInitial(
      selectedAddress: state.selectedAddress,
      selectedPaymentMethod: method,
    ));
  }

  Future<void> submitOrder() async {
    emit(OrderPlacing(
      selectedAddress: state.selectedAddress,
      selectedPaymentMethod: state.selectedPaymentMethod,
    ));

    await Future.delayed(const Duration(milliseconds: 1200));

    emit(OrderSuccess(
      orderId: 'ORD-SHW-9482',
      selectedAddress: state.selectedAddress,
      selectedPaymentMethod: state.selectedPaymentMethod,
    ));
  }
}
