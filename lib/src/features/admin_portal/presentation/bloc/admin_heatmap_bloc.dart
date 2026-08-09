import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AdminHeatmapState extends Equatable {
  const AdminHeatmapState();
  @override
  List<Object?> get props => [];
}

class AdminHeatmapLoaded extends AdminHeatmapState {
  final List<Map<String, dynamic>> densityAreas;
  final List<Map<String, dynamic>> slaLeaderboard;

  const AdminHeatmapLoaded({
    required this.densityAreas,
    required this.slaLeaderboard,
  });

  @override
  List<Object?> get props => [densityAreas, slaLeaderboard];
}

class AdminHeatmapBloc extends Cubit<AdminHeatmapState> {
  AdminHeatmapBloc()
      : super(const AdminHeatmapLoaded(
          densityAreas: [
            {'zone': 'Scheme 3, Sahiwal', 'density': 'High (42%)', 'ordersCount': 3540},
            {'zone': 'College Road', 'density': 'High (28%)', 'ordersCount': 2350},
            {'zone': 'High Street Market', 'density': 'Medium (18%)', 'ordersCount': 1510},
            {'zone': 'Fateh Sher Colony', 'density': 'Moderate (12%)', 'ordersCount': 1020},
          ],
          slaLeaderboard: [
            {'rank': 1, 'name': 'Pizza Haven Sahiwal', 'avgPrepTime': '12 min', 'rating': 4.9},
            {'rank': 2, 'name': 'Royal Taj Restaurant', 'avgPrepTime': '16 min', 'rating': 4.8},
            {'rank': 3, 'name': 'Sahiwal Grill & Fast Food', 'avgPrepTime': '18 min', 'rating': 4.7},
          ],
        ));
}
