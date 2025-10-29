import 'dart:io';
import 'package:athenex/controllers/controllers.dart';
import 'package:athenex/pages/home.dart';
import 'package:athenex/widgets/custom_button1.dart';
import 'package:athenex/widgets/custom_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:athenex/model/product.dart';
import 'package:intl/intl.dart';
import 'add_product.dart';

class ViewProductPage extends StatefulWidget {
  final Product product;

  const ViewProductPage({super.key, required this.product});

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  late Product mainGuy;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final product = await fetchAProduct(widget.product.id!);
    setState(() {
      mainGuy = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 249, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(248, 248, 249, 1.0),
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Product Details'.toUpperCase(),
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text('PRODUCT IMAGE'.toUpperCase()),
                  SizedBox(height: 8.h),
                  if (mainGuy.imagePaths.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        File(mainGuy.imagePaths.first),
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Container(
                      height: 200.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 0.6.w, color: Colors.black54),
                      ),
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  SizedBox(height: 0.h),
                  _buildLabel('PRODUCT NAME'),
                  _buildData(mainGuy.name),
                  _buildLabel('PRICE'),
                  _buildData(formatter.format(mainGuy.price)),
                  _buildLabel('QUANTITY'),
                  _buildData(mainGuy.quantity.toString()),
                  _buildLabel('CATEGORY'),
                  _buildData(mainGuy.category),
                  _buildLabel('DESCRIPTION'),
                  _buildData(
                    mainGuy.description!.isEmpty
                        ? 'No description provided.'
                        : mainGuy.description!,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    buttonText: 'edit',
                    showIcon: false,
                    action: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditProductPage(product: mainGuy),
                        ),
                      );
                      setState(() {
                        _loadProduct();
                      });
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomOutlineButton(
                    buttonText: 'delete',
                    action: () async {
                      removeInInventory(mainGuy);
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
                    },
                    showIcon: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 14.h),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildData(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 0.h),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Colors.black87,
        ),
      ),
    );
  }



}
