import 'package:athenex/model/category.dart';
import 'package:athenex/widgets/toat_info.dart';

import '../constants/status.dart';
import '../model/product.dart';
import '../services/database_services.dart';

final DatabaseService _databaseService = DatabaseService.instance;


///PRODUCT CONTROLLERS

void addToInventory(Product product) async {
  await _databaseService.addProduct(product);
  toastInfo(
    msg: '${product.name} has been added to you inventory',
    status: Status.success,
  );
}

void editInInventory(Product product) async {
  _databaseService.updateProduct(product);
  toastInfo(
    msg: '${product.name} has been updated in you inventory',
    status: Status.success,
  );
}

void deleteProduct(Product product) async {
  await _databaseService.deleteProduct(product.id!);
  toastInfo(msg: '${product.name} is delete', status: Status.success);
}

Future<List<Product>> loadProducts(
  String searchQuery,
  String? selectedCategory,
) async {
  if (searchQuery.isNotEmpty) {
    return await _databaseService.searchProducts(searchQuery);
  }
  if (selectedCategory != null && selectedCategory.isNotEmpty) {
    return await _databaseService.filterByCategory(selectedCategory);
  }
  return await _databaseService.getProducts();
}

Future<List<Product>> fetchProducts() async {
  final productList = await _databaseService.getProducts();
  return productList;
}

Future<Product> fetchAProduct(int id) async {
  final product = await _databaseService.getProductById(id);
  return product;
}

Future<List<Product>> filterProducts(category) async {
  final productList = await _databaseService.filterByCategory(category);
  return productList;
}

void removeInInventory(Product product) async {
  await _databaseService.deleteProduct(product.id!);
  toastInfo(
    msg: '${product.name} is removed from inventory',
    status: Status.success,
  );
}


///CATEGORY CONTROLLERS

Future<List<Category>> loadCategories(catList) async {
  final cats = await DatabaseService.instance.getCategories();
  return cats;
}

void addCat(Category cat) async {
  await _databaseService.addCategory(cat);
  toastInfo(msg: '${cat.name} is deleted', status: Status.success);
}

void removeCat(Category cat) async {
  await _databaseService.deleteCategory(cat.id!);
  toastInfo(msg: '${cat.name} is deleted', status: Status.success);
}
