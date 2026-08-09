import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:city_bites/src/features/customer_home/presentation/bloc/home_cubit.dart';

class CartItem extends Equatable {
  final FoodItem foodItem;
  final int quantity;

  const CartItem({
    required this.foodItem,
    this.quantity = 1,
  });

  double get itemTotal => foodItem.price * quantity;

  CartItem copyWith({
    FoodItem? foodItem,
    int? quantity,
  }) {
    return CartItem(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [foodItem, quantity];
}

class CartState extends Equatable {
  final List<CartItem> items;
  final String deliveryAddress;
  final String? promoCode;
  final double discountAmount;
  final bool isOrderPlaced;

  const CartState({
    this.items = const [],
    this.deliveryAddress = AppConstants.defaultLocation,
    this.promoCode,
    this.discountAmount = 0.0,
    this.isOrderPlaced = false,
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.itemTotal);

  double get deliveryFee => items.isEmpty ? 0.0 : AppConstants.defaultDeliveryFee;

  double get tax => subtotal * AppConstants.taxPercentage;

  double get total => (subtotal + deliveryFee + tax - discountAmount).clamp(0.0, double.infinity);

  CartState copyWith({
    List<CartItem>? items,
    String? deliveryAddress,
    String? promoCode,
    double? discountAmount,
    bool? isOrderPlaced,
  }) {
    return CartState(
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      promoCode: promoCode ?? this.promoCode,
      discountAmount: discountAmount ?? this.discountAmount,
      isOrderPlaced: isOrderPlaced ?? this.isOrderPlaced,
    );
  }

  @override
  List<Object?> get props => [items, deliveryAddress, promoCode, discountAmount, isOrderPlaced];
}

class CartCubit extends Cubit<CartState> {
  CartCubit()
      : super(CartState(
          items: [
            CartItem(foodItem: HomeCubit.mockFoodList[0], quantity: 2),
            CartItem(foodItem: HomeCubit.mockFoodList[1], quantity: 1),
          ],
        ));

  void addItem(FoodItem item, {int quantity = 1}) {
    final existingIndex = state.items.indexWhere((i) => i.foodItem.id == item.id);
    List<CartItem> updated = List.from(state.items);

    if (existingIndex >= 0) {
      final current = updated[existingIndex];
      updated[existingIndex] = current.copyWith(quantity: current.quantity + quantity);
    } else {
      updated.add(CartItem(foodItem: item, quantity: quantity));
    }

    emit(state.copyWith(items: updated, isOrderPlaced: false));
  }

  void removeItem(String foodId) {
    final updated = state.items.where((i) => i.foodItem.id != foodId).toList();
    emit(state.copyWith(items: updated));
  }

  void updateQuantity(String foodId, int quantity) {
    if (quantity <= 0) {
      removeItem(foodId);
      return;
    }
    final updated = state.items.map((item) {
      if (item.foodItem.id == foodId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updated));
  }

  bool applyPromoCode(String code) {
    if (code.trim().toUpperCase() == 'SAHIWAL30') {
      final discount = state.subtotal * 0.30;
      emit(state.copyWith(promoCode: 'SAHIWAL30', discountAmount: discount));
      return true;
    }
    return false;
  }

  void clearPromoCode() {
    emit(state.copyWith(promoCode: null, discountAmount: 0.0));
  }

  void placeOrder() {
    emit(state.copyWith(items: [], promoCode: null, discountAmount: 0.0, isOrderPlaced: true));
  }

  void resetOrderPlaced() {
    emit(state.copyWith(isOrderPlaced: false));
  }
}
