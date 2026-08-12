import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_paths.dart';

abstract class RestaurantDetailState extends Equatable {
  const RestaurantDetailState();
  @override
  List<Object?> get props => [];
}

class RestaurantLoading extends RestaurantDetailState {}

class RestaurantLoaded extends RestaurantDetailState {
  final Map<String, dynamic> restaurant;
  final String activeTab;
  final List<Map<String, dynamic>> menuItems;
  final List<Map<String, dynamic>> allMenuItems;

  const RestaurantLoaded({
    required this.restaurant,
    required this.activeTab,
    required this.menuItems,
    required this.allMenuItems,
  });

  List<Map<String, dynamic>> get fullMenuItems =>
      allMenuItems.isNotEmpty ? allMenuItems : menuItems;

  @override
  List<Object?> get props => [restaurant, activeTab, menuItems, allMenuItems];
}

class RestaurantDetailBloc extends Cubit<RestaurantDetailState> {
  RestaurantDetailBloc() : super(RestaurantLoading());

  void loadRestaurant(Map<String, dynamic> rest) {
    emit(RestaurantLoading());

    final dummyItems = [
      {
        'id': 'dish_1',
        'name': 'Special Sahiwal Chicken Biryani',
        'description':
            'Aromatic basmati rice cooked with tender chicken pieces, local spices, and served with mint raita.',
        'price': 450.0,
        'image': AssetPaths.chickenBiryani,
        'category': 'Popular',
        'isSpicy': true,
        'isVeg': false,
      },
      {
        'id': 'dish_2',
        'name': 'Crispy Zinger Burger',
        'description':
            'Crispy fried chicken breast fillet topped with lettuce and signature garlic mayo sauce.',
        'price': 380.0,
        'image': AssetPaths.zingerBurger,
        'category': 'Fast Food',
        'isSpicy': false,
        'isVeg': false,
      },
      {
        'id': 'dish_3',
        'name': 'Pepperoni Pizza (Medium)',
        'description':
            'Hand-tossed pizza crust with rich tomato sauce, melted mozzarella, and spicy beef pepperoni slices.',
        'price': 990.0,
        'image': AssetPaths.pepperPizza,
        'category': 'Popular',
        'isSpicy': false,
        'isVeg': false,
      },
      {
        'id': 'dish_4',
        'name': 'Desi Chicken Karahi (Half)',
        'description':
            'Freshly prepared chicken karahi with green chillies, ginger julienne, and tomatoes cooked in desi ghee.',
        'price': 1250.0,
        'image': AssetPaths.chickenKarahi,
        'category': 'Deals',
        'isSpicy': true,
        'isVeg': false,
      },
      {
        'id': 'dish_5',
        'name': 'Fudge Chocolate Brownie',
        'description':
            'Warm, dense chocolate fudge brownie served with dark chocolate drizzle.',
        'price': 250.0,
        'image': AssetPaths.chocolateBrownie,
        'category': 'Drinks & Desserts',
        'isSpicy': false,
        'isVeg': true,
      },
    ];

    emit(
      RestaurantLoaded(
        restaurant: rest,
        activeTab: 'all',
        menuItems: dummyItems,
        allMenuItems: dummyItems,
      ),
    );
  }

  void filterByCategory(String cat) {
    if (state is RestaurantLoaded) {
      final current = state as RestaurantLoaded;
      final sourceItems = current.allMenuItems.isNotEmpty
          ? current.allMenuItems
          : current.menuItems;
      final catLower = cat.toString().toLowerCase();
      final filteredItems = catLower == 'all'
          ? List<Map<String, dynamic>>.from(sourceItems)
          : sourceItems
                .where(
                  (item) => (item['category'] ?? '')
                      .toString()
                      .toLowerCase()
                      .contains(catLower),
                )
                .cast<Map<String, dynamic>>()
                .toList();

      emit(
        RestaurantLoaded(
          restaurant: current.restaurant,
          activeTab: cat,
          menuItems: filteredItems,
          allMenuItems: List<Map<String, dynamic>>.from(sourceItems),
        ),
      );
    }
  }
}
