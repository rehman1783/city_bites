import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OwnerDashboardState extends Equatable {
  const OwnerDashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardLoading extends OwnerDashboardState {}

class DashboardLoaded extends OwnerDashboardState {
  final bool isStoreOpen;
  final double todaySales;
  final int todayOrders;
  final int activeItems;
  final int pendingAlerts;
  final List<Map<String, dynamic>> pendingOrders;

  const DashboardLoaded({
    required this.isStoreOpen,
    required this.todaySales,
    required this.todayOrders,
    required this.activeItems,
    required this.pendingAlerts,
    required this.pendingOrders,
  });

  DashboardLoaded copyWith({
    bool? isStoreOpen,
    double? todaySales,
    int? todayOrders,
    int? activeItems,
    int? pendingAlerts,
    List<Map<String, dynamic>>? pendingOrders,
  }) {
    return DashboardLoaded(
      isStoreOpen: isStoreOpen ?? this.isStoreOpen,
      todaySales: todaySales ?? this.todaySales,
      todayOrders: todayOrders ?? this.todayOrders,
      activeItems: activeItems ?? this.activeItems,
      pendingAlerts: pendingAlerts ?? this.pendingAlerts,
      pendingOrders: pendingOrders ?? this.pendingOrders,
    );
  }

  @override
  List<Object?> get props => [
        isStoreOpen,
        todaySales,
        todayOrders,
        activeItems,
        pendingAlerts,
        pendingOrders,
      ];
}

class OwnerDashboardBloc extends Cubit<OwnerDashboardState> {
  OwnerDashboardBloc() : super(DashboardLoading());

  void fetchDashboardMetrics() {
    emit(const DashboardLoaded(
      isStoreOpen: true,
      todaySales: 14200.0,
      todayOrders: 28,
      activeItems: 18,
      pendingAlerts: 3,
      pendingOrders: [
        {
          'id': 'ORD-SHW-9482',
          'time': '3 mins ago',
          'customer': 'Usman Raza',
          'address': 'Scheme 3, Sahiwal',
          'items': '2x Chicken Biryani, 1x Cold Drink',
          'amount': 990.0,
          'status': 'Pending',
        },
        {
          'id': 'ORD-SHW-9483',
          'time': '7 mins ago',
          'customer': 'Tariq Mehmood',
          'address': 'College Road, Sahiwal',
          'items': '1x Crispy Zinger Burger',
          'amount': 380.0,
          'status': 'Pending',
        },
      ],
    ));
  }

  void toggleStoreStatus(bool isOpen) {
    if (state is DashboardLoaded) {
      final current = state as DashboardLoaded;
      emit(current.copyWith(isStoreOpen: isOpen));
    }
  }

  void acceptOrder(String orderId) {
    if (state is DashboardLoaded) {
      final current = state as DashboardLoaded;
      final updated = current.pendingOrders
          .where((o) => o['id'] != orderId)
          .toList();
      emit(current.copyWith(
        pendingOrders: updated,
        pendingAlerts: (current.pendingAlerts - 1).clamp(0, 99),
      ));
    }
  }
}
