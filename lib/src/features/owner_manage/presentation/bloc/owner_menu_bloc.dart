import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_paths.dart';

abstract class OwnerMenuState extends Equatable {
  const OwnerMenuState();
  @override
  List<Object?> get props => [];
}

class OwnerMenuLoading extends OwnerMenuState {}

class OwnerMenuLoaded extends OwnerMenuState {
  final List<Map<String, dynamic>> menuItems;

  const OwnerMenuLoaded({required this.menuItems});

  @override
  List<Object?> get props => [menuItems];
}

class OwnerMenuBloc extends Cubit<OwnerMenuState> {
  OwnerMenuBloc() : super(OwnerMenuLoading());

  void fetchMenu() {
    emit(const OwnerMenuLoaded(
      menuItems: [
        {
          'id': 'dish_1',
          'name': 'Special Sahiwal Chicken Biryani',
          'category': 'Biryani',
          'price': 450.0,
          'isAvailable': true,
          'image': AssetPaths.chickenBiryani,
        },
        {
          'id': 'dish_2',
          'name': 'Crispy Zinger Burger',
          'category': 'Fast Food',
          'price': 380.0,
          'isAvailable': true,
          'image': AssetPaths.zingerBurger,
        },
        {
          'id': 'dish_3',
          'name': 'Pepperoni Pizza (Medium)',
          'category': 'Pizza',
          'price': 990.0,
          'isAvailable': false,
          'image': AssetPaths.pepperPizza,
        },
      ],
    ));
  }

  void toggleAvailability(String itemId, bool isAvailable) {
    if (state is OwnerMenuLoaded) {
      final current = state as OwnerMenuLoaded;
      final updated = current.menuItems.map((item) {
        if (item['id'] == itemId) {
          return {...item, 'isAvailable': isAvailable};
        }
        return item;
      }).toList();
      emit(OwnerMenuLoaded(menuItems: updated));
    }
  }

  void deleteItem(String itemId) {
    if (state is OwnerMenuLoaded) {
      final current = state as OwnerMenuLoaded;
      final updated =
          current.menuItems.where((item) => item['id'] != itemId).toList();
      emit(OwnerMenuLoaded(menuItems: updated));
    }
  }

  void addFoodItem(Map<String, dynamic> item) {
    if (state is OwnerMenuLoaded) {
      final current = state as OwnerMenuLoaded;
      final updated = List<Map<String, dynamic>>.from(current.menuItems)
        ..add(item);
      emit(OwnerMenuLoaded(menuItems: updated));
    }
  }
}
