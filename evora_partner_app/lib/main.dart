import 'package:evora_partner_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evora_partner_app/core/routers/app_router.dart';
import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:evora_partner_app/providers/feed_provider.dart';
import 'package:evora_partner_app/providers/vendor_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()..init()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Evora Partner',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          // Force text scale factor to 1
          builder: (context, child) {
            return Container(
              color: AppColors.backgroundColor,
              child: SafeArea(
                top: false,
                child: MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: TextScaler.noScaling),
                  child: child!,
                ),
              ),
            );
          },
          theme: AppTheme.lightTheme,
        );
      },
    );
  }
}
