class AppConstants {
  static const String appName = 'City Bites';
  static const String appTagline = "One Destination, Unlimited Flavours";

  // City & Location
  static const String cityName = 'Sahiwal';
  static const List<String> sahiwalLocations = [
    'Scheme 3, College Road',
    'Farooq-e-Azam Town',
    'High Street Market',
    'Girls College Road',
    'Fateh Sher Colony',
    'Tariq Bin Ziad Colony',
    'Faisal Hospital Area',
  ];
  static const String defaultLocation = 'Scheme 3, College Road, Sahiwal';
  static const String locationPlaceholder = 'Select delivery location';
  static const String locationKey = 'saved_delivery_location';

  // Currency
  static const String currency = 'Rs.';

  // Default Fees & Taxes
  static const double defaultDeliveryFee = 80.0;
  static const double taxPercentage = 0.05; // 5% GST

  // App Categories
  static const List<Map<String, String>> categories = [
    {'name': 'All', 'icon': '🍽️'},
    {'name': 'Biryani', 'icon': '🍲'},
    {'name': 'Burgers', 'icon': '🍔'},
    {'name': 'Pizza', 'icon': '🍕'},
    {'name': 'Karahi', 'icon': '🥘'},
    {'name': 'Desserts', 'icon': '🍰'},
    {'name': 'Drinks', 'icon': '🥤'},
  ];
}
