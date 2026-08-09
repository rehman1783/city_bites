import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartEmpty extends CartState {}

class CartLoaded extends CartState {
  final List<Map<String, dynamic>> items;
  final String promoCode;
  final double discountAmount;
  final String restaurantName;
  final double deliveryFee;
  final double serviceFee;

  const CartLoaded({
    required this.items,
    this.promoCode = '',
    this.discountAmount = 0.0,
    this.restaurantName = 'Royal Taj Restaurant & Bakers',
    this.deliveryFee = 60.0,
    this.serviceFee = 20.0,
  });

  double get subtotal => items.fold(
      0.0, (sum, item) => sum + (item['price'] * item['quantity']));

  double get totalPayable =>
      (subtotal + deliveryFee + serviceFee - discountAmount).clamp(0, 999999);

  CartLoaded copyWith({
    List<Map<String, dynamic>>? items,
    String? promoCode,
    double? discountAmount,
    String? restaurantName,
    double? deliveryFee,
    double? serviceFee,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      promoCode: promoCode ?? this.promoCode,
      discountAmount: discountAmount ?? this.discountAmount,
      restaurantName: restaurantName ?? this.restaurantName,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      serviceFee: serviceFee ?? this.serviceFee,
    );
  }

  @override
  List<Object?> get props => [
        items,
        promoCode,
        discountAmount,
        restaurantName,
        deliveryFee,
        serviceFee,
      ];
}

class CartBloc extends Cubit<CartState> {
  CartBloc()
      : super(const CartLoaded(items: [
          {
            'id': 'dish_1',
            'name': 'Special Sahiwal Chicken Biryani',
            'price': 450.0,
            'quantity': 2,
            'portion': 'Single',
            'addons': ['Extra Cheese'],
            'image':
                'https://images.unsplash.com/photo-1633945274405-b6c8069047b0?w=600&auto=format&fit=crop&q=60',
          },
          {
            'id': 'dish_2',
            'name': 'Crispy Zinger Burger',
            'price': 380.0,
            'quantity': 1,
            'portion': 'Single',
            'addons': [],
            'image':
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop&q=60',
          },
        ]));

  void addItem(Map<String, dynamic> item) {
    if (state is CartEmpty) {
      emit(CartLoaded(items: [item]));
      return;
    }

    if (state is CartLoaded) {
      final current = state as CartLoaded;
      final existingIndex =
          current.items.indexWhere((element) => element['id'] == item['id']);

      final updatedItems = List<Map<String, dynamic>>.from(current.items);
      if (existingIndex >= 0) {
        final existing = updatedItems[existingIndex];
        updatedItems[existingIndex] = {
          ...existing,
          'quantity': (existing['quantity'] as int) + (item['quantity'] as int),
        };
      } else {
        updatedItems.add(item);
      }

      emit(current.copyWith(items: updatedItems));
    }
  }

  void updateQuantity(String id, int qty) {
    if (state is CartLoaded) {
      final current = state as CartLoaded;
      final updatedItems = current.items
          .map((item) {
            if (item['id'] == id) {
              return {...item, 'quantity': qty};
            }
            return item;
          })
          .where((item) => (item['quantity'] as int) > 0)
          .toList();

      if (updatedItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(current.copyWith(items: updatedItems));
      }
    }
  }

  void removeItem(String id) {
    if (state is CartLoaded) {
      final current = state as CartLoaded;
      final updatedItems =
          current.items.where((item) => item['id'] != id).toList();
      if (updatedItems.isEmpty) {
        emit(CartEmpty());
      } else {
        emit(current.copyWith(items: updatedItems));
      }
    }
  }

  void applyPromoCode(String code) {
    if (state is CartLoaded) {
      final current = state as CartLoaded;
      if (code.toUpperCase() == 'SAHIWAL50') {
        emit(current.copyWith(promoCode: 'SAHIWAL50', discountAmount: 50.0));
      } else {
        emit(current.copyWith(promoCode: code, discountAmount: 20.0));
      }
    }
  }
}
