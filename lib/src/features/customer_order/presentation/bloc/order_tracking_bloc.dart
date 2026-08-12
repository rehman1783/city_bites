import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class OrderTrackingState extends Equatable {
  const OrderTrackingState();
  @override
  List<Object?> get props => [];
}

class TrackingLoading extends OrderTrackingState {}

class TrackingUpdated extends OrderTrackingState {
  final String orderId;
  final int
  currentStep; // 0: Pending, 1: Accepted, 2: Preparing, 3: Out for Delivery, 4: Delivered
  final String restaurantName;
  final String riderName;
  final String riderPhone;
  final String destination;
  final String eta;

  const TrackingUpdated({
    required this.orderId,
    required this.currentStep,
    required this.restaurantName,
    required this.riderName,
    required this.riderPhone,
    required this.destination,
    required this.eta,
  });

  @override
  List<Object?> get props => [
    orderId,
    currentStep,
    restaurantName,
    riderName,
    riderPhone,
    destination,
    eta,
  ];
}

class OrderTrackingBloc extends Cubit<OrderTrackingState> {
  OrderTrackingBloc() : super(TrackingLoading());

  void subscribeToOrderStream(String orderId) {
    emit(DummyTracking.dummyTracking(orderId));
  }
}

extension DummyTracking on OrderTrackingState {
  static TrackingUpdated dummyTracking(String orderId) {
    return TrackingUpdated(
      orderId: orderId.isEmpty ? 'ORD-SHW-9482' : orderId,
      currentStep: 2, // Out for Delivery
      restaurantName: 'Royal Taj Restaurant & Bakers',
      riderName: 'Muhammad Ali (Sahiwal Express Rider)',
      riderPhone: '+92 300 9876543',
      destination: 'Scheme 3, College Road, Sahiwal',
      eta: '12-18 mins',
    );
  }
}
