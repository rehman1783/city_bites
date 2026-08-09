import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AdminOrdersState extends Equatable {
  const AdminOrdersState();
  @override
  List<Object?> get props => [];
}

class AdminOrdersLoaded extends AdminOrdersState {
  final List<Map<String, dynamic>> globalOrders;

  const AdminOrdersLoaded({required this.globalOrders});

  @override
  List<Object?> get props => [globalOrders];
}

class AdminOrdersBloc extends Cubit<AdminOrdersState> {
  AdminOrdersBloc()
      : super(const AdminOrdersLoaded(
          globalOrders: [
            {
              'id': 'ORD-SHW-9482',
              'restaurant': 'Royal Taj Restaurant',
              'customer': 'Usman Raza',
              'amount': 990.0,
              'status': 'Out for Delivery',
              'date': '09 Aug 2026',
            },
            {
              'id': 'ORD-SHW-9481',
              'restaurant': 'Sahiwal Grill',
              'customer': 'Tariq Mehmood',
              'amount': 380.0,
              'status': 'Preparing',
              'date': '09 Aug 2026',
            },
            {
              'id': 'ORD-SHW-9480',
              'restaurant': 'Pizza Haven',
              'customer': 'Farhan Khan',
              'amount': 1250.0,
              'status': 'Delivered',
              'date': '09 Aug 2026',
            },
          ],
        ));

  void forceCancelOrder(String orderId) {
    if (state is AdminOrdersLoaded) {
      final current = state as AdminOrdersLoaded;
      final updated = current.globalOrders.map((o) {
        if (o['id'] == orderId) {
          return {...o, 'status': 'Cancelled by Admin'};
        }
        return o;
      }).toList();
      emit(AdminOrdersLoaded(globalOrders: updated));
    }
  }
}
