import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OwnerOrdersState extends Equatable {
  const OwnerOrdersState();
  @override
  List<Object?> get props => [];
}

class OwnerOrdersLoading extends OwnerOrdersState {}

class OwnerOrdersLoaded extends OwnerOrdersState {
  final List<Map<String, dynamic>> pending;
  final List<Map<String, dynamic>> preparing;
  final List<Map<String, dynamic>> dispatched;
  final List<Map<String, dynamic>> completed;

  const OwnerOrdersLoaded({
    required this.pending,
    required this.preparing,
    required this.dispatched,
    required this.completed,
  });

  @override
  List<Object?> get props => [pending, preparing, dispatched, completed];
}

class OwnerOrdersBloc extends Cubit<OwnerOrdersState> {
  OwnerOrdersBloc() : super(OwnerOrdersLoading());

  void loadOrders() {
    emit(const OwnerOrdersLoaded(
      pending: [
        {
          'id': 'ORD-SHW-9482',
          'time': '10:45 AM',
          'customer': 'Usman Raza',
          'address': 'Scheme 3, Sahiwal',
          'items': ['2x Special Chicken Biryani', '1x Cold Drink 345ml'],
          'amount': 990.0,
          'paymentStatus': 'COD',
        },
      ],
      preparing: [
        {
          'id': 'ORD-SHW-9480',
          'time': '10:30 AM',
          'customer': 'Hamza Bilal',
          'address': 'College Road, Sahiwal',
          'items': ['1x Crispy Zinger Burger', '1x Fries'],
          'amount': 480.0,
          'paymentStatus': 'Paid (JazzCash)',
        },
      ],
      dispatched: [
        {
          'id': 'ORD-SHW-9478',
          'time': '10:15 AM',
          'customer': 'Zainab Bibi',
          'address': 'High Street Market, Sahiwal',
          'items': ['1x Pepperoni Pizza (Medium)'],
          'amount': 990.0,
          'paymentStatus': 'Paid (Card)',
        },
      ],
      completed: [
        {
          'id': 'ORD-SHW-9475',
          'time': '09:40 AM',
          'customer': 'Farhan Khan',
          'address': 'Fateh Sher Colony, Sahiwal',
          'items': ['1x Chicken Karahi (Half)'],
          'amount': 1250.0,
          'paymentStatus': 'COD',
        },
      ],
    ));
  }

  void updateOrderStatus(String orderId, String newStatus) {
    loadOrders();
  }
}
