import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OwnerAnalyticsState extends Equatable {
  const OwnerAnalyticsState();
  @override
  List<Object?> get props => [];
}

class OwnerAnalyticsLoaded extends OwnerAnalyticsState {
  final String timeRange;
  final double totalRevenue;
  final int totalOrders;
  final List<Map<String, dynamic>> topDishes;
  final List<Map<String, dynamic>> hourlyVolume;

  const OwnerAnalyticsLoaded({
    required this.timeRange,
    required this.totalRevenue,
    required this.totalOrders,
    required this.topDishes,
    required this.hourlyVolume,
  });

  @override
  List<Object?> get props => [
        timeRange,
        totalRevenue,
        totalOrders,
        topDishes,
        hourlyVolume,
      ];
}

class OwnerAnalyticsBloc extends Cubit<OwnerAnalyticsState> {
  OwnerAnalyticsBloc()
      : super(const OwnerAnalyticsLoaded(
          timeRange: 'This Week',
          totalRevenue: 98400.0,
          totalOrders: 184,
          topDishes: [
            {'name': 'Special Sahiwal Chicken Biryani', 'salesCount': 84},
            {'name': 'Crispy Zinger Burger', 'salesCount': 52},
            {'name': 'Pepperoni Pizza', 'salesCount': 28},
            {'name': 'Desi Chicken Karahi', 'salesCount': 12},
            {'name': 'Fudge Chocolate Brownie', 'salesCount': 8},
          ],
          hourlyVolume: [
            {'hour': '12 PM', 'orders': 24},
            {'hour': '02 PM', 'orders': 38},
            {'hour': '08 PM', 'orders': 65},
            {'hour': '10 PM', 'orders': 42},
          ],
        ));

  void setTimeRange(String range) {
    emit(OwnerAnalyticsLoaded(
      timeRange: range,
      totalRevenue: range == 'Today'
          ? 14200.0
          : range == 'This Week'
              ? 98400.0
              : 380000.0,
      totalOrders: range == 'Today'
          ? 28
          : range == 'This Week'
              ? 184
              : 720,
      topDishes: (state as OwnerAnalyticsLoaded).topDishes,
      hourlyVolume: (state as OwnerAnalyticsLoaded).hourlyVolume,
    ));
  }
}
