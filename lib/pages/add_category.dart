import 'package:athenex/widgets/toat_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../model/product.dart';
import '../../model/category.dart';
import '../constants/status.dart';
import '../controllers/controllers.dart';
import '../services/database_services.dart';
import '../widgets/custom_button1.dart';

class AddCategory extends StatefulWidget {
  final Product? product;
  final int? productKey;

  const AddCategory({super.key, this.product, this.productKey});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Category> categories = [];
  late TextEditingController nameController;
  List<String> imagePaths = [];

  @override
  void initState() {
    super.initState();
    getCat();
    nameController = TextEditingController(text: widget.product?.name ?? '');
  }

  Future<void> getCat() async {
    final cats = await _databaseService.getCategories();
    setState(() {
      categories = cats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Categories'.toUpperCase(),
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 12.w,
                        ),
                        margin: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: const Color.fromRGBO(248, 248, 249, 1.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(getIcon(category.iconName)),
                            SizedBox(height: 8.h),
                            Text(category.name, textAlign: TextAlign.center),
                          ],
                        ),
                      ),

                      // Show "CUSTOM" badge for user added
                      if (category.custom == true)
                        Positioned(
                          left: 4.w,
                          top: 4.h,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.black87),
                            onPressed: () {
                              removeCat(category);
                              getCat(); // Refresh the category list
                              setState(() {});
                            },
                          ),
                        ),

                      // Show "delete" option for user added
                      if (category.custom == true)
                        Positioned(
                          right: 14.w,
                          top: 14.h,
                          child: CircleAvatar(
                            radius: 12.r,
                            backgroundColor: Colors.black38,
                            child: Text(
                              'C',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            CustomButton(
              buttonText: 'Add category',
              showIcon: false,
              action: _showAddCategoryDialog,
            ),
          ],
        ),
      ),
    );
  }


  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    IconData? selectedIcon;
    final icons = [
      Icons.category,
      Icons.devices_other,
      Icons.kitchen,
      Icons.watch,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Add Category'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Category Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    children: icons.map((icon) {
                      final isSelected = selectedIcon == icon;
                      return GestureDetector(
                        onTap: () => setState(() => selectedIcon = icon),
                        child: CircleAvatar(
                          backgroundColor: isSelected
                              ? Colors.black
                              : Colors.grey[200],
                          child: Center(
                            child: Icon(
                              icon,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
          actionsOverflowAlignment: OverflowBarAlignment.start,
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel'.toUpperCase(),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: CustomButton(
                buttonText: 'Save',
                showIcon: false,
                action: () async {
                  if (nameController.text.isNotEmpty && selectedIcon != null) {
                    final newCategory = Category(
                      name: nameController.text,
                      iconName: _iconToName(selectedIcon!),
                      custom: true,
                    );
                    addCat(newCategory);
                    Navigator.pop(context);
                    getCat(); // Refresh the category list
                  } else {
                    toastInfo(
                      msg: 'Add required category details',
                      status: Status.error,
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String _iconToName(IconData icon) {
    switch (icon) {
      case Icons.category:
        return 'generic';
      case Icons.devices_other:
        return 'devices_other';
      case Icons.kitchen:
        return 'kitchen';
      case Icons.watch:
        return 'watch';
      default:
        return 'category';
    }
  }
}

