import 'package:examdril/screens/authentication/splash_screen.dart';
import 'package:examdril/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Full screen mode - hides status bar and navigation bar properly for quiz/game feel
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),   // ← iPhone 14 size from Figma
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'ExamDril',
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF164863),
              primary: const Color(0xFF164863),
              secondary: const Color(0xFFB15F83),
            ),
            textTheme: GoogleFonts.robotoTextTheme(
              ThemeData.light().textTheme,
            ).copyWith(
              // This ensures Roboto is used everywhere unless overridden
              bodyLarge: GoogleFonts.roboto(),
              bodyMedium: GoogleFonts.roboto(),
              bodySmall: GoogleFonts.roboto(),
              titleLarge: GoogleFonts.roboto(),
              titleMedium: GoogleFonts.roboto(),
              titleSmall: GoogleFonts.roboto(),
              headlineLarge: GoogleFonts.roboto(),
              headlineMedium: GoogleFonts.roboto(),
              headlineSmall: GoogleFonts.roboto(),
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}