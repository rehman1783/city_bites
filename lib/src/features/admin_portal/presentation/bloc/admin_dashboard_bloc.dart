import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AdminDashboardState extends Equatable {
  const AdminDashboardState();
  @override
  List<Object?> get props => [];
}

class AdminDashboardLoaded extends AdminDashboardState {
  final double totalGmv;
  final int totalOrders;
  final int activeRestaurants;
  final int totalCustomers;
  final int activeLiveOrders;
  final int activeRiders;

  const AdminDashboardLoaded({
    required this.totalGmv,
    required this.totalOrders,
    required this.activeRestaurants,
    required this.totalCustomers,
    required this.activeLiveOrders,
    required this.activeRiders,
  });

  @override
  List<Object?> get props => [
        totalGmv,
        totalOrders,
        activeRestaurants,
        totalCustomers,
        activeLiveOrders,
        activeRiders,
      ];
}

class AdminDashboardBloc extends Cubit<AdminDashboardState> {
  AdminDashboardBloc()
      : super(const AdminDashboardLoaded(
          totalGmv: 4200000.0,
          totalOrders: 8420,
          activeRestaurants: 42,
          totalCustomers: 18500,
          activeLiveOrders: 64,
          activeRiders: 28,
        ));
}
