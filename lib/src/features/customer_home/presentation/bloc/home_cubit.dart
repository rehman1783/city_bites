import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_paths.dart';

class FoodItem extends Equatable {
  final String id;
  final String title;
  final String restaurantName;
  final double price;
  final double rating;
  final String deliveryTime;
  final String category;
  final String imageUrl;
  final String description;
  final List<String> addOns;

  const FoodItem({
    required this.id,
    required this.title,
    required this.restaurantName,
    required this.price,
    required this.rating,
    required this.deliveryTime,
    required this.category,
    required this.imageUrl,
    required this.description,
    this.addOns = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        restaurantName,
        price,
        rating,
        deliveryTime,
        category,
        imageUrl,
        description,
        addOns,
      ];
}

class HomeState extends Equatable {
  final String selectedCategory;
  final String searchQuery;
  final String selectedLocation;
  final List<FoodItem> foodItems;
  final List<FoodItem> filteredItems;

  const HomeState({
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.selectedLocation = 'Scheme 3, College Road',
    this.foodItems = const [],
    this.filteredItems = const [],
  });

  HomeState copyWith({
    String? selectedCategory,
    String? searchQuery,
    String? selectedLocation,
    List<FoodItem>? foodItems,
    List<FoodItem>? filteredItems,
  }) {
    return HomeState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      foodItems: foodItems ?? this.foodItems,
      filteredItems: filteredItems ?? this.filteredItems,
    );
  }

  @override
  List<Object?> get props => [
        selectedCategory,
        searchQuery,
        selectedLocation,
        foodItems,
        filteredItems,
      ];
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState()) {
    loadMockData();
  }

  static const List<FoodItem> mockFoodList = [
    FoodItem(
      id: 'f1',
      title: 'Special Chicken Biryani',
      restaurantName: 'Royal Taj Restaurant (Scheme 3)',
      price: 380,
      rating: 4.8,
      deliveryTime: '20-25 min',
      category: 'Biryani',
      imageUrl: AssetPaths.chickenBiryani,
      description:
          'Aromatic Basmati rice cooked with succulent chicken pieces, saffron, and traditional Sahiwali spices.',
      addOns: ['Extra Raita (Rs. 40)', 'Salad Container (Rs. 30)', 'Extra Chicken Piece (Rs. 150)'],
    ),
    FoodItem(
      id: 'f2',
      title: 'Double Patty Zinger Burger',
      restaurantName: 'Sahiwal Grill & Fast Food',
      price: 540,
      rating: 4.6,
      deliveryTime: '25-30 min',
      category: 'Burgers',
      imageUrl: AssetPaths.zingerBurger,
      description:
          'Crispy double chicken fillet with melted cheddar cheese, mayo sauce, and fresh lettuce.',
      addOns: ['Extra Cheese Slice (Rs. 50)', 'Fries Basket (Rs. 120)', 'Cold Drink 345ml (Rs. 70)'],
    ),
    FoodItem(
      id: 'f3',
      title: 'Cheesy Pepperoni Pizza (Large)',
      restaurantName: 'Pizza Haven Sahiwal',
      price: 1450,
      rating: 4.9,
      deliveryTime: '30-35 min',
      category: 'Pizza',
      imageUrl: AssetPaths.pepperPizza,
      description:
          'Loaded with mozzarella cheese, rich tomato sauce, and savory smoked pepperoni slices.',
      addOns: ['Cheese Burst Crust (Rs. 250)', 'Garlic Sauce (Rs. 60)', 'Dip Sauce (Rs. 50)'],
    ),
    FoodItem(
      id: 'f4',
      title: 'Desi Ghee Chicken Karahi (Half)',
      restaurantName: 'Farooq-e-Azam Shinwari',
      price: 950,
      rating: 4.7,
      deliveryTime: '35-40 min',
      category: 'Karahi',
      imageUrl: AssetPaths.chickenKarahi,
      description:
          'Traditional Pakistani karahi prepared in pure desi ghee with ginger, green chillies, and tomatoes.',
      addOns: ['Roghni Naan (Rs. 50)', 'Garlic Naan (Rs. 60)', 'Fresh Salad (Rs. 40)'],
    ),
    FoodItem(
      id: 'f5',
      title: 'Fudge Chocolate Brownie',
      restaurantName: 'Sweet Tooth Sahiwal',
      price: 260,
      rating: 4.9,
      deliveryTime: '15-20 min',
      category: 'Desserts',
      imageUrl: AssetPaths.chocolateBrownie,
      description:
          'Rich, dense, and gooey chocolate brownie topped with warm chocolate drizzle.',
      addOns: ['Vanilla Ice Cream Scoop (Rs. 80)', 'Extra Chocolate Sauce (Rs. 40)'],
    ),
    FoodItem(
      id: 'f6',
      title: 'Special Chilled Mango Lassi',
      restaurantName: 'Madina Dairy & Refreshment',
      price: 180,
      rating: 4.5,
      deliveryTime: '15-20 min',
      category: 'Drinks',
      imageUrl: AssetPaths.mangoLassi,
      description:
          'Thick and refreshing traditional mango lassi made with fresh yogurt and Sahiwal mangoes.',
      addOns: ['Extra Malai Top (Rs. 30)', 'Dry Fruit Mix (Rs. 50)'],
    ),
  ];

  void loadMockData() {
    emit(state.copyWith(
      foodItems: mockFoodList,
      filteredItems: mockFoodList,
    ));
  }

  void selectCategory(String category) {
    final categoryFiltered = category == 'All'
        ? state.foodItems
        : state.foodItems.where((item) => item.category == category).toList();

    final queryFiltered = state.searchQuery.isEmpty
        ? categoryFiltered
        : categoryFiltered
            .where((item) =>
                item.title.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
                item.restaurantName.toLowerCase().contains(state.searchQuery.toLowerCase()))
            .toList();

    emit(state.copyWith(
      selectedCategory: category,
      filteredItems: queryFiltered,
    ));
  }

  void searchItems(String query) {
    final categoryFiltered = state.selectedCategory == 'All'
        ? state.foodItems
        : state.foodItems.where((item) => item.category == state.selectedCategory).toList();

    final queryFiltered = query.isEmpty
        ? categoryFiltered
        : categoryFiltered
            .where((item) =>
                item.title.toLowerCase().contains(query.toLowerCase()) ||
                item.restaurantName.toLowerCase().contains(query.toLowerCase()))
            .toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredItems: queryFiltered,
    ));
  }

  void updateLocation(String location) {
    emit(state.copyWith(selectedLocation: location));
  }
}
