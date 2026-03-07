import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

enum AppIcons {
  shoppingCart('shopping_cart', FluentIcons.cart_24_filled, Color(0xFF4CAF50)),
  car('car', FluentIcons.vehicle_car_24_filled, Color(0xFF2196F3)),
  house('house', FluentIcons.home_24_filled, Color(0xFFFF9800)),
  receipt('receipt', FluentIcons.receipt_24_filled, Color(0xFFF44336)),
  phone('phone', FluentIcons.phone_24_filled, Color(0xFF00BCD4)),
  tshirt('tshirt', FluentIcons.clothes_hanger_24_filled, Color(0xFFE91E63)),
  game('game', FluentIcons.games_24_filled, Color(0xFF673AB7)),
  airplane('airplane', FluentIcons.airplane_24_filled, Color(0xFF03A9F4)),
  health('health', FluentIcons.heart_pulse_24_filled, Color(0xFFE53935)),
  education(
      'education', FluentIcons.hat_graduation_24_filled, Color(0xFF3F51B5)),
  music('music', FluentIcons.music_note_2_24_filled, Color(0xFFFF5722)),
  wallet('wallet', FluentIcons.wallet_24_filled, Color(0xFF4CAF50)),
  investment(
      'investment', FluentIcons.data_trending_24_filled, Color(0xFF009688)),
  gift('gift', FluentIcons.gift_24_filled, Color(0xFFE91E63)),
  sport('sport', FluentIcons.sport_24_filled, Color(0xFF8BC34A)),
  food('food', FluentIcons.food_24_filled, Color(0xFFFF9800)),
  coffee('coffee', FluentIcons.drink_coffee_24_filled, Color(0xFF795548)),
  medicine('medicine', FluentIcons.pill_24_filled, Color(0xFFE53935)),
  pet('pet', FluentIcons.animal_cat_24_filled, Color(0xFF8D6E63)),
  laptop('laptop', FluentIcons.laptop_24_filled, Color(0xFF607D8B)),
  bank('bank', FluentIcons.building_bank_24_filled, Color(0xFF1565C0)),
  entertainment(
      'entertainment', FluentIcons.movies_and_tv_24_filled, Color(0xFFAB47BC)),
  gym('gym', FluentIcons.dumbbell_24_filled, Color(0xFFEF5350)),
  child('child', FluentIcons.people_24_filled, Color(0xFFFF80AB)),
  electricity('electricity', FluentIcons.flash_24_filled, Color(0xFFFFD600)),
  water('water', FluentIcons.drop_24_filled, Color(0xFF29B6F6)),
  internet('internet', FluentIcons.wifi_1_24_filled, Color(0xFF5C6BC0));

  final String iconName;
  final IconData icon;
  final Color color;

  const AppIcons(this.iconName, this.icon, this.color);

  static AppIcons fromName(String name) {
    return AppIcons.values.firstWhere(
      (e) => e.iconName == name,
      orElse: () => AppIcons.shoppingCart,
    );
  }
}
