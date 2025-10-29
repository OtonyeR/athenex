import 'package:athenex/pages/add_product.dart';
import 'package:athenex/widgets/floating_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../controllers/controllers.dart';
import '../model/category.dart';
import '../model/product.dart';
import '../widgets/custom_button1.dart';
import '../widgets/custom_button2.dart';
import '../widgets/product_card1.dart';
import '../widgets/product_card2.dart';
import 'add_category.dart';

class AthenexHome extends StatefulWidget {
  const AthenexHome({super.key});

  @override
  State<AthenexHome> createState() => _AthenexHomeState();
}

class _AthenexHomeState extends State<AthenexHome> {
  bool isGridView = false;
  String searchQuery = '';
  final List<Category> _allCategories = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _initCategories();
    loadProducts(searchQuery, selectedCategory);
  }

  Future<void> _initCategories() async {
    final cats = await loadCategories(_allCategories);
    setState(() {
      _allCategories.clear();
      _allCategories.addAll(cats);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('ATHENEX'),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Color.fromRGBO(248, 248, 249, 1.0),
      ),
      backgroundColor: Color.fromRGBO(248, 248, 249, 1.0),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 65.h,
        elevation: 1,
        overlayStyle: const ExpandableFabOverlayStyle(
          color: Colors.black54,
          blur: 4,
        ),
        type: ExpandableFabType.up,
        openButtonBuilder: FloatingActionButtonBuilder(
          size: 56.0,
          builder: (context, onPressed, progress) {
            return FloatingActionButton(
              onPressed: onPressed,
              backgroundColor: Colors.black87,
              shape: const CircleBorder(), // 👈 ensures circular shape
              child: FaIcon(
                FontAwesomeIcons.box,
                color: Colors.white,
                weight: 1,
              ),
            );
          },
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 56.0,
          builder: (context, onPressed, progress) {
            return FloatingActionButton(
              heroTag: null,
              onPressed: onPressed,
              backgroundColor: Colors.black54,
              shape: const CircleBorder(),
              // 👈 ensures circular shape
              child: FaIcon(
                FontAwesomeIcons.box,
                color: Colors.white,
                weight: 1,
              ),
            );
          },
        ),
        children: [
          FloatingOption(
            iconName: Icons.add,
            page: AddEditProductPage(),
            heroTag: 'add',
          ),
          FloatingOption(
            iconName: Icons.category,
            page: AddCategory(),
            heroTag: 'categories',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search inventory',
                prefixIcon: Icon(Icons.search),
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black26,
                    width: 1.4,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black26,
                    width: 1.4,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 12.w),

            // Filter & Layout Toggle
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: selectedCategory ?? 'filter',
                    showIcon: true,
                    action: () async {
                      if (!mounted) return;
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16.r),
                          ),
                        ),
                        builder: (_) => Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Filter by Category'.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              DropdownButtonFormField<String>(
                                initialValue: selectedCategory,
                                hint: const Text('Select a Category'),
                                dropdownColor: Colors.white,
                                onChanged: (value) {
                                  setState(() => selectedCategory = value);
                                  Navigator.pop(context);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black26,
                                      width: 1.4,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black26,
                                      width: 1.4,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 1.4,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                ),
                                items: _allCategories.map((cat) {
                                  return DropdownMenuItem(
                                    value: cat.name,
                                    child: Row(
                                      children: [
                                        Icon(getIcon(cat.iconName), size: 20),
                                        const SizedBox(width: 8),
                                        Text(cat.name),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                CustomOutlineButton(
                  buttonText: isGridView ? 'GRID' : 'LIST',
                  action: () {
                    setState(() => isGridView = !isGridView);
                  },
                  showIcon: true,
                  icon: isGridView ? Icons.grid_view_rounded : Icons.list,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Product List
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: loadProducts(searchQuery, selectedCategory),
                builder: (context, snapshot) {
                  final queryState =
                      searchQuery.isNotEmpty || selectedCategory != null;

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState(context, queryState);
                  }

                  var products = snapshot.data!;

                  return isGridView
                      ? Center(
                          child: GridView.builder(
                            itemCount: products.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 220.h,
                                  mainAxisSpacing: 16.h,
                                  childAspectRatio: 2.0,
                                ),
                            itemBuilder: (context, index) => GridProductCard(
                              product: products[index],
                              button: _buildPopupMenu(products[index]),
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: products.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                          itemBuilder: (context, index) => ListProductCard(
                            product: products[index],
                            size: size,
                            button: _buildPopupMenu(products[index]),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool queryState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 40.h),
            height: MediaQuery.sizeOf(context).height * 0.44,
            width: MediaQuery.sizeOf(context).width * 0.7,
            child: Lottie.asset('assets/empty.json'),
          ),
          queryState
              ? Text(
                  'No product in your inventory match this query',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                )
              : Column(
                  children: [
                    Text(
                      'Your inventory is empty',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Add some products',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget buildCategoryFilter(List<String> categories) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        initialValue: selectedCategory,
        hint: const Text('Filter by category'),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('All Categories'),
          ),
          ...categories.map(
            (cat) => DropdownMenuItem<String>(value: cat, child: Text(cat)),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
          });

          // Optional: trigger your filter logic here
          if (value == null) {
            // show all products
            fetchProducts();
          } else {
            filterProducts(value);
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black26, width: 1.4),
            borderRadius: BorderRadius.circular(10.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black26, width: 1.4),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black26, width: 1.4),
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      ),
    );
  }

  PopupMenuButton<String> _buildPopupMenu(Product product) {
    return PopupMenuButton<String>(
      color: Colors.white,
      borderRadius: BorderRadius.circular(32.r),
      icon: Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'edit') {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditProductPage(product: product),
            ),
          );

          if (updated == true) {
            setState(() {});
          }
        } else if (value == 'delete') {
          deleteProduct(product);
          setState(() {});
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        const PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }
}
