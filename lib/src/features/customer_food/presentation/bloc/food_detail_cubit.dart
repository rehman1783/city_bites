import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDetailState extends Equatable {
  final Map<String, dynamic> dish;
  final String selectedPortion;
  final Set<String> selectedAddons;
  final int quantity;
  final String specialInstructions;

  const FoodDetailState({
    required this.dish,
    this.selectedPortion = 'Single',
    this.selectedAddons = const {},
    this.quantity = 1,
    this.specialInstructions = '',
  });

  double get basePrice => (dish['price'] as num).toDouble();

  double get portionExtraPrice {
    switch (selectedPortion) {
      case 'Double':
        return 150.0;
      case 'Family':
        return 350.0;
      default:
        return 0.0;
    }
  }

  double get addonsExtraPrice {
    double total = 0;
    if (selectedAddons.contains('Extra Cheese')) total += 80;
    if (selectedAddons.contains('Mayo Dip')) total += 40;
    if (selectedAddons.contains('Cold Drink 345ml')) total += 90;
    return total;
  }

  double get unitPrice => basePrice + portionExtraPrice + addonsExtraPrice;
  double get totalPrice => unitPrice * quantity;

  FoodDetailState copyWith({
    Map<String, dynamic>? dish,
    String? selectedPortion,
    Set<String>? selectedAddons,
    int? quantity,
    String? specialInstructions,
  }) {
    return FoodDetailState(
      dish: dish ?? this.dish,
      selectedPortion: selectedPortion ?? this.selectedPortion,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  @override
  List<Object?> get props => [
        dish,
        selectedPortion,
        selectedAddons,
        quantity,
        specialInstructions,
      ];
}

class FoodDetailCubit extends Cubit<FoodDetailState> {
  FoodDetailCubit(Map<String, dynamic> dish)
      : super(FoodDetailState(dish: dish));

  void selectPortion(String portion) {
    emit(state.copyWith(selectedPortion: portion));
  }

  void toggleAddon(String addon) {
    final updated = Set<String>.from(state.selectedAddons);
    if (updated.contains(addon)) {
      updated.remove(addon);
    } else {
      updated.add(addon);
    }
    emit(state.copyWith(selectedAddons: updated));
  }

  void updateQuantity(int newQty) {
    if (newQty >= 1) {
      emit(state.copyWith(quantity: newQty));
    }
  }

  void updateSpecialInstructions(String text) {
    emit(state.copyWith(specialInstructions: text));
  }
}
