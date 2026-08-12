import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/asset_paths.dart';

abstract class HomeFeedState extends Equatable {
  const HomeFeedState();
  @override
  List<Object?> get props => [];
}

class HomeFeedLoading extends HomeFeedState {}

class HomeFeedLoaded extends HomeFeedState {
  final String location;
  final String selectedCategory;
  final String searchQuery;
  final List<String> banners;
  final List<Map<String, dynamic>> categories;
  final List<Map<String, dynamic>> restaurants;

  const HomeFeedLoaded({
    required this.location,
    required this.selectedCategory,
    required this.searchQuery,
    required this.banners,
    required this.categories,
    required this.restaurants,
  });

  @override
  List<Object?> get props => [
        location,
        selectedCategory,
        searchQuery,
        banners,
        categories,
        restaurants,
      ];
}

class HomeFeedError extends HomeFeedState {
  final String message;
  const HomeFeedError(this.message);
  @override
  List<Object?> get props => [message];
}

class HomeFeedBloc extends Cubit<HomeFeedState> {
  HomeFeedBloc() : super(HomeFeedLoading());

  Future<void> fetchHomeData() async {
    emit(HomeFeedLoading());

    final savedLocation = await _loadSavedLocation();
    final dummyBanners = AssetPaths.promoBanners;

    final dummyCategories = [
      {'id': 'all', 'name': 'All', 'icon': '🍽️'},
      {'id': 'biryani', 'name': 'Biryani', 'icon': '🍲'},
      {'id': 'burgers', 'name': 'Burgers', 'icon': '🍔'},
      {'id': 'pizza', 'name': 'Pizza', 'icon': '🍕'},
      {'id': 'karahi', 'name': 'Karahi', 'icon': '🥘'},
      {'id': 'desserts', 'name': 'Desserts', 'icon': '🍰'},
      {'id': 'drinks', 'name': 'Drinks', 'icon': '🥤'},
    ];

    final dummyRestaurants = [
      {
        'id': 'rest_1',
        'name': 'Royal Taj Restaurant & Bakers',
        'image': AssetPaths.royalTaj,
        'rating': 4.8,
        'reviewCount': 340,
        'deliveryTime': '20-30 min',
        'deliveryFee': 50,
        'tags': ['Biryani', 'Karahi', 'Pakistani'],
        'branch': 'College Road, Sahiwal',
        'hours': '11:00 AM - 11:30 PM',
      },
      {
        'id': 'rest_2',
        'name': 'Sahiwal Grill & Fast Food',
        'image': AssetPaths.sahiwalGrill,
        'rating': 4.7,
        'reviewCount': 210,
        'deliveryTime': '25-35 min',
        'deliveryFee': 60,
        'tags': ['Burgers', 'Zinger', 'Fries'],
        'branch': 'High Street, Sahiwal',
        'hours': '12:00 PM - 01:00 AM',
      },
      {
        'id': 'rest_3',
        'name': 'Pizza Haven Sahiwal',
        'image': AssetPaths.pizzaHaven,
        'rating': 4.9,
        'reviewCount': 520,
        'deliveryTime': '15-25 min',
        'deliveryFee': 40,
        'tags': ['Pizza', 'Italian', 'Pasta'],
        'branch': 'Scheme 3, Sahiwal',
        'hours': '11:00 AM - 12:00 AM',
      },
    ];

    emit(HomeFeedLoaded(
      location: savedLocation,
      selectedCategory: 'all',
      searchQuery: '',
      banners: dummyBanners,
      categories: dummyCategories,
      restaurants: dummyRestaurants,
    ));
  }

  void selectCategory(String categoryId) {
    if (state is HomeFeedLoaded) {
      final current = state as HomeFeedLoaded;
      emit(HomeFeedLoaded(
        location: current.location,
        selectedCategory: categoryId,
        searchQuery: current.searchQuery,
        banners: current.banners,
        categories: current.categories,
        restaurants: current.restaurants,
      ));
    }
  }

  void updateSearchQuery(String query) {
    if (state is HomeFeedLoaded) {
      final current = state as HomeFeedLoaded;
      emit(HomeFeedLoaded(
        location: current.location,
        selectedCategory: current.selectedCategory,
        searchQuery: query,
        banners: current.banners,
        categories: current.categories,
        restaurants: current.restaurants,
      ));
    }
  }

  void updateLocation(String newLoc) {
    if (state is HomeFeedLoaded) {
      final current = state as HomeFeedLoaded;
      _saveLocation(newLoc);
      emit(HomeFeedLoaded(
        location: newLoc,
        selectedCategory: current.selectedCategory,
        searchQuery: current.searchQuery,
        banners: current.banners,
        categories: current.categories,
        restaurants: current.restaurants,
      ));
    }
  }

  Future<String> _loadSavedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConstants.locationKey) ?? '';
    } catch (_) {
      return '';
    }
  }

  Future<void> _saveLocation(String location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.locationKey, location);
    } catch (_) {
      // Ignore storage failures and keep the app functional.
    }
  }
}
