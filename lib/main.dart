import 'package:athenex/pages/home.dart';
import 'package:athenex/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:toast/toast.dart';

import 'model/category.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.instance.seedDefaultCategories(defaultCategories);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        ToastContext().init(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AthenexHome(),
        );
      },
    );
  }
}
