import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_paths.dart';

class OwnerMenuItem extends Equatable {
  final String id;
  final String title;
  final double price;
  final String category;
  final bool isAvailable;
  final String imageUrl;

  const OwnerMenuItem({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.isAvailable,
    required this.imageUrl,
  });

  OwnerMenuItem copyWith({
    String? id,
    String? title,
    double? price,
    String? category,
    bool? isAvailable,
    String? imageUrl,
  }) {
    return OwnerMenuItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, title, price, category, isAvailable, imageUrl];
}

class OwnerDashboardState extends Equatable {
  final int totalOrdersToday;
  final double revenueToday;
  final List<OwnerMenuItem> menuItems;

  const OwnerDashboardState({
    this.totalOrdersToday = 18,
    this.revenueToday = 14500.0,
    this.menuItems = const [],
  });

  int get activeItemsCount => menuItems.where((item) => item.isAvailable).length;

  OwnerDashboardState copyWith({
    int? totalOrdersToday,
    double? revenueToday,
    List<OwnerMenuItem>? menuItems,
  }) {
    return OwnerDashboardState(
      totalOrdersToday: totalOrdersToday ?? this.totalOrdersToday,
      revenueToday: revenueToday ?? this.revenueToday,
      menuItems: menuItems ?? this.menuItems,
    );
  }

  @override
  List<Object?> get props => [totalOrdersToday, revenueToday, menuItems];
}

class OwnerDashboardCubit extends Cubit<OwnerDashboardState> {
  OwnerDashboardCubit() : super(const OwnerDashboardState()) {
    _loadInitialMenu();
  }

  void _loadInitialMenu() {
    emit(state.copyWith(
      menuItems: const [
        OwnerMenuItem(
          id: 'om1',
          title: 'Special Chicken Biryani (Single)',
          price: 380,
          category: 'Biryani',
          isAvailable: true,
          imageUrl: AssetPaths.chickenBiryani,
        ),
        OwnerMenuItem(
          id: 'om2',
          title: 'Double Patty Zinger Burger',
          price: 540,
          category: 'Burgers',
          isAvailable: true,
          imageUrl: AssetPaths.zingerBurger,
        ),
        OwnerMenuItem(
          id: 'om3',
          title: 'Large Cheesy Pepperoni Pizza',
          price: 1450,
          category: 'Pizza',
          isAvailable: true,
          imageUrl: AssetPaths.pepperPizza,
        ),
        OwnerMenuItem(
          id: 'om4',
          title: 'Desi Ghee Chicken Karahi (Half)',
          price: 950,
          category: 'Karahi',
          isAvailable: false, // Inactive / Sold out
          imageUrl: AssetPaths.chickenKarahi,
        ),
      ],
    ));
  }

  void toggleItemAvailability(String id) {
    final updated = state.menuItems.map((item) {
      if (item.id == id) {
        return item.copyWith(isAvailable: !item.isAvailable);
      }
      return item;
    }).toList();

    emit(state.copyWith(menuItems: updated));
  }

  void addNewMenuItem(String title, double price, String category) {
    final newItem = OwnerMenuItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      price: price,
      category: category,
      isAvailable: true,
      imageUrl: AssetPaths.chickenBiryani,
    );

    final updated = List<OwnerMenuItem>.from(state.menuItems)..add(newItem);
    emit(state.copyWith(menuItems: updated));
  }
}
