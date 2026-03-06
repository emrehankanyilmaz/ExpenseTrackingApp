import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class CategoryIcon {
  final String name;
  final IconData icon;
  final Color color;

  const CategoryIcon({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class AppIcons {
  AppIcons._();

  static const List<CategoryIcon> categoryIcons = [
    CategoryIcon(
      name: 'shopping_cart',
      icon: FluentIcons.cart_24_filled,
      color: Color(0xFF4CAF50),
    ),
    CategoryIcon(
      name: 'car',
      icon: FluentIcons.vehicle_car_24_filled,
      color: Color(0xFF2196F3),
    ),
    CategoryIcon(
      name: 'house',
      icon: FluentIcons.home_24_filled,
      color: Color(0xFFFF9800),
    ),
    CategoryIcon(
      name: 'receipt',
      icon: FluentIcons.receipt_24_filled,
      color: Color(0xFFF44336),
    ),
    CategoryIcon(
      name: 'phone',
      icon: FluentIcons.phone_24_filled,
      color: Color(0xFF00BCD4),
    ),
    CategoryIcon(
      name: 'tshirt',
      icon: FluentIcons.clothes_hanger_24_filled,
      color: Color(0xFFE91E63),
    ),
    CategoryIcon(
      name: 'game',
      icon: FluentIcons.games_24_filled,
      color: Color(0xFF673AB7),
    ),
    CategoryIcon(
      name: 'airplane',
      icon: FluentIcons.airplane_24_filled,
      color: Color(0xFF03A9F4),
    ),
    CategoryIcon(
      name: 'health',
      icon: FluentIcons.heart_pulse_24_filled,
      color: Color(0xFFE53935),
    ),
    CategoryIcon(
      name: 'education',
      icon: FluentIcons.hat_graduation_24_filled,
      color: Color(0xFF3F51B5),
    ),
    CategoryIcon(
      name: 'music',
      icon: FluentIcons.music_note_2_24_filled,
      color: Color(0xFFFF5722),
    ),
    CategoryIcon(
      name: 'wallet',
      icon: FluentIcons.wallet_24_filled,
      color: Color(0xFF4CAF50),
    ),
    CategoryIcon(
      name: 'investment',
      icon: FluentIcons.data_trending_24_filled,
      color: Color(0xFF009688),
    ),
    CategoryIcon(
      name: 'gift',
      icon: FluentIcons.gift_24_filled,
      color: Color(0xFFE91E63),
    ),
    CategoryIcon(
      name: 'sport',
      icon: FluentIcons.sport_24_filled,
      color: Color(0xFF8BC34A),
    ),
    CategoryIcon(
      name: 'food',
      icon: FluentIcons.food_24_filled,
      color: Color(0xFFFF9800),
    ),
    CategoryIcon(
      name: 'coffee',
      icon: FluentIcons.drink_coffee_24_filled,
      color: Color(0xFF795548),
    ),
    CategoryIcon(
      name: 'medicine',
      icon: FluentIcons.pill_24_filled,
      color: Color(0xFFE53935),
    ),
    CategoryIcon(
      name: 'pet',
      icon: FluentIcons.animal_cat_24_filled,
      color: Color(0xFF8D6E63),
    ),
    CategoryIcon(
      name: 'laptop',
      icon: FluentIcons.laptop_24_filled,
      color: Color(0xFF607D8B),
    ),
    CategoryIcon(
      name: 'bank',
      icon: FluentIcons.building_bank_24_filled,
      color: Color(0xFF1565C0),
    ),
    CategoryIcon(
      name: 'entertainment',
      icon: FluentIcons.movies_and_tv_24_filled,
      color: Color(0xFFAB47BC),
    ),
    CategoryIcon(
      name: 'gym',
      icon: FluentIcons.dumbbell_24_filled,
      color: Color(0xFFEF5350),
    ),
    CategoryIcon(
      name: 'child',
      icon: FluentIcons.people_24_filled,
      color: Color(0xFFFF80AB),
    ),
    CategoryIcon(
      name: 'electricity',
      icon: FluentIcons.flash_24_filled,
      color: Color(0xFFFFD600),
    ),
    CategoryIcon(
      name: 'water',
      icon: FluentIcons.drop_24_filled,
      color: Color(0xFF29B6F6),
    ),
    CategoryIcon(
      name: 'internet',
      icon: FluentIcons.wifi_1_24_filled,
      color: Color(0xFF5C6BC0),
    ),
  ];

  static CategoryIcon getByName(String name) {
    return categoryIcons.firstWhere(
      (e) => e.name == name,
      orElse: () => categoryIcons[0],
    );
  }
}
