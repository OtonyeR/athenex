import 'package:flutter/material.dart';


class Category {
  int? id;
  String name;
  String iconName;
  bool? custom;

  Category({
    this.id,
    required this.name,
    required this.iconName,
    this.custom,
  });

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as int?,
    name: map['name'] as String,
    iconName: map['icon'] as String,
    custom: (map['custom'] ?? 0) == 1,
  );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'icon': iconName,
      'custom': (custom ?? false) ? 1 : 0,
    };
    if (id != null) map['id'] = id;
    return map;
  }
}


/// Helper to map stored icon name to IconData
IconData getIcon(String name) {
  switch (name) {
    case 'shopping_basket':
      return Icons.shopping_basket;
    case 'local_drink':
      return Icons.local_drink;
    case 'devices_other':
      return Icons.devices_other;
    case 'checkroom':
      return Icons.checkroom;
    case 'directions_walk':
      return Icons.directions_walk;
    case 'style':
      return Icons.style;
    case 'kitchen':
      return Icons.kitchen;
    case 'spa':
      return Icons.spa;
    case 'edit_note':
      return Icons.edit_note;
    case 'cleaning_services':
      return Icons.cleaning_services;
    case 'chair':
      return Icons.chair;
    case 'build':
      return Icons.build;
    case 'directions_car':
      return Icons.directions_car;
    case 'child_care':
      return Icons.child_care;
    case 'pets':
      return Icons.pets;
    case 'fitness_center':
      return Icons.fitness_center;
    case 'extension':
      return Icons.extension;
    case 'menu_book':
      return Icons.menu_book;
    case 'watch':
      return Icons.watch;
    case 'category':
      return Icons.category;
    default:
      return Icons.inventory;
  }
}

/// Default categories
final List<Category> defaultCategories = [
  Category(name: 'Groceries', iconName: 'shopping_basket'),
  Category(name: 'Beverages', iconName: 'local_drink'),
  Category(name: 'Electronics', iconName: 'devices_other'),
  Category(name: 'Clothing', iconName: 'checkroom'),
  Category(name: 'Footwear', iconName: 'directions_walk'),
  Category(name: 'Accessories', iconName: 'style'),
  Category(name: 'Home & Kitchen', iconName: 'kitchen'),
  Category(name: 'Health & Beauty', iconName: 'spa'),
  Category(name: 'Stationery & Office', iconName: 'edit_note'),
  Category(name: 'Cleaning Supplies', iconName: 'cleaning_services'),
  Category(name: 'Furniture', iconName: 'chair'),
  Category(name: 'Tools & Hardware', iconName: 'build'),
  Category(name: 'Automotive', iconName: 'directions_car'),
  Category(name: 'Baby Products', iconName: 'child_care'),
  Category(name: 'Pet Supplies', iconName: 'pets'),
  Category(name: 'Sports & Fitness', iconName: 'fitness_center'),
  Category(name: 'Toys & Games', iconName: 'extension'),
  Category(name: 'Books & Media', iconName: 'menu_book'),
  Category(name: 'Jewelry & Watches', iconName: 'watch'),
];
