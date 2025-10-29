import 'dart:io';

import 'package:athenex/controllers/controllers.dart';
import 'package:athenex/pages/home.dart';
import 'package:athenex/widgets/toat_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/product.dart';
import '../../model/category.dart';
import '../constants/status.dart';
import '../services/database_services.dart';
import '../widgets/custom_button1.dart';
import '../widgets/custom_input.dart';

class AddEditProductPage extends StatefulWidget {
  final Product? product;
  final int? productKey;

  const AddEditProductPage({super.key, this.product, this.productKey});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController qtyController;
  late TextEditingController descController;
  String? selectedCategory;
  List<Category> categories = [];
  List<String> imagePaths = [];

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getCat();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    qtyController = TextEditingController(
      text: widget.product?.quantity.toString() ?? '',
    );
    descController = TextEditingController(
      text: widget.product?.quantity.toString() ?? '',
    );
    selectedCategory = widget.product?.category;
    imagePaths = widget.product?.imagePaths ?? [];
  }

  Future<void> pickImage(bool fromCamera) async {
    if (fromCamera) {
      final picked = await picker.pickImage(source: ImageSource.camera);
      if (picked != null) setState(() => imagePaths.add(picked.path));
    } else {
      final pickedList = await picker.pickMultiImage();
      if (pickedList.isNotEmpty) {
        setState(() {
          imagePaths.addAll(pickedList.map((x) => x.path));
        });
      }
    }
  }

  Future<void> getCat() async {
    final cats = await _databaseService.getCategories();
    setState(() {
      categories = cats;
    });
  }

  void saveProduct(bool isNew) async {
    if (!_formKey.currentState!.validate() || selectedCategory == null) {
      toastInfo(msg: 'Please fill all required fields', status: Status.error);
    } else {
      final product = Product(
        id: widget.product?.id,
        name: nameController.text.trim(),
        price: double.parse(priceController.text),
        quantity: int.parse(qtyController.text),
        imagePaths: imagePaths,
        category: selectedCategory ?? 'Uncategorized',
        description: descController.text.trim(),
      );
      isNew ? addToInventory(product) : editInInventory(product);
      final updated = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AthenexHome(),
        ),
      );

      if (updated == true) {
        setState(() {
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 248, 249, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(248, 248, 249, 1.0),
        surfaceTintColor: Colors.transparent,
        title: Text(
          widget.product == null
              ? 'Add Product'.toUpperCase()
              : 'Edit Product'.toUpperCase(),
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Text('Add product image'.toUpperCase()),
                    SizedBox(height: 8.h),
                    SizedBox(
                      height: 100.h,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Add Image button
                          GestureDetector(
                            onTap: _showImagePickerOptions,
                            child: Container(
                              width: 100.w,
                              height: 100.w,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 0.6.w,
                                  color: Colors.black54,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          ),

                          // Display picked images
                          ...imagePaths.map((path) {
                            return Stack(
                              children: [
                                Container(
                                  width: 100.w,
                                  height: 100.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      width: 0.6.w,
                                      color: Colors.black54,
                                    ),
                                    image: DecorationImage(
                                      image: FileImage(File(path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 4,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => imagePaths.remove(path)),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.black54,
                                      child: Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                    CustomInputField(
                      nameController: nameController,
                      inputLabel: 'Product Name',
                      errorText: 'Enter product name',
                      inputType: TextInputType.twitter,
                      isRequired: true,
                    ),
                    CustomInputField(
                      nameController: priceController,
                      inputLabel: 'Product Price',
                      errorText: 'Enter price',
                      inputType: TextInputType.number,
                      isRequired: true,
                      isRight: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Price is invalid';
                        }
                        final number = num.tryParse(val);
                        if (number == null) {
                          return 'Price must be a number';
                        }
                        return null; // valid
                      },
                    ),
                    CustomInputField(
                      nameController: qtyController,
                      inputLabel: 'Quantity',
                      errorText: 'Enter quantity',
                      inputType: TextInputType.number,
                      isRequired: true,
                      isRight: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Price is invalid';
                        }
                        final number = num.tryParse(val);
                        if (number == null) {
                          return 'Price must be a number';
                        }
                        return null; // valid
                      },
                    ),
                    const SizedBox(height: 30),
                    Text('CATEGORY'),
                    SizedBox(height: 8.h),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      isExpanded: true,
                      dropdownColor: Colors.white,
                      items: categories.map<DropdownMenuItem<String>>((cat) {
                        return DropdownMenuItem<String>(
                          value: cat.name,
                          child: Row(
                            children: [
                              Icon(getIcon(cat.iconName)),
                              const SizedBox(width: 8),
                              Text(cat.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => selectedCategory = value),
                      decoration: InputDecoration(
                        hintText: 'Category',
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
                    ),
                    CustomInputField(
                      nameController: descController,
                      inputLabel: 'Description',
                      errorText: 'Enter description',
                      inputType: TextInputType.multiline,
                      isRequired: false,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            CustomButton(
              buttonText: widget.product == null
                  ? 'Add product'
                  : 'Save Changes',
              showIcon: false,
              action: () {
                saveProduct(widget.product == null);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            if (Platform.isAndroid || Platform.isIOS)
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(true);
                },
              ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                pickImage(false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

