import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/product.dart';
import '../pages/view_product.dart';
import 'naira_formatter.dart';

class ListProductCard extends StatelessWidget {
  final Product product;
  final Size size;
  final Widget? button;

  const ListProductCard({
    super.key,
    required this.size,
    required this.product,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewProductPage(product: product),
            ));
      },
      child: Container(
        width: size.width,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: Color.fromRGBO(242, 243, 243, 1.0),
            width: 2.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // product image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                    topRight: Radius.circular(0.r),
                    bottomRight: Radius.circular(0.r),
                  ),
                  child: Image.asset(
                    product.imagePaths.isNotEmpty
                        ? product.imagePaths[0]
                        : 'assets/generic.png',
                    height: 120.h,
                    width: 120.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 6.w,
                  top: 6.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      product.quantity.toString(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            // product details
            Expanded(
              flex: 3,
              child: SizedBox(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 9.h),
                    Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      product.category,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    NairaText(amount: product.price),
                  ],
                ),
              ),
            ),
            Spacer(),
            Expanded(child: button!),
          ],
        ),
      ),
    );
  }
}
